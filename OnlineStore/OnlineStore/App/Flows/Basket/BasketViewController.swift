//
//  BasketViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 13.10.2021.
//

import UIKit

var gBasket = [BasketItem]()

protocol BasketViewControllerDelegate: AnyObject {
    func IncreaseBasketCost(by price: Int)
    func DecreaseBasketCost(by price: Int)
    func MakePayment()
}

class BasketViewController: UIViewController {
    
    private lazy var basketTableView = UITableView()
    private lazy var footerView = BasketFooterView()
    
    private var totalBasketCost: Observable<Int> = Observable(0)
    private let userBasketInstance = UserBasketManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureView()
        
        footerView.basketDelegate = self
        
        totalBasketCost.addObserver(self,
                                    options: [.initial, .new],
                                    closure: {
            [weak self] value, _ in
            self?.footerView.setTotalPrice(price: value)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        totalBasketCost.value = userBasketInstance.getBasketCost()
        basketTableView.reloadData()
    }
    
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        
        addBasketTableView()
        configureBasketTableView()
        
        addBasketFooterView()
    }
    
    private func addBasketTableView() {
        self.view.addSubview(basketTableView)
        
        basketTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            basketTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            basketTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            basketTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ])
    }
    
    private func addBasketFooterView() {
        self.view.addSubview(footerView)
        
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: basketTableView.bottomAnchor, constant: 10),
            footerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            footerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            footerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -75),
        ])
    }
    
    private func configureBasketTableView() {
        basketTableView.delegate = self
        basketTableView.dataSource = self
        
        basketTableView.register(UINib(nibName: "BasketTableViewCell",
                                       bundle: .none),
                                 forCellReuseIdentifier: "BasketCell")
    }
}

extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userBasketInstance.basket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = basketTableView.dequeueReusableCell(withIdentifier: "BasketCell", for: indexPath) as? BasketTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(basketItemAt: indexPath.row)
        cell.basketDelegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let basket = RequestFactory.shared.makeBasketRequestFactory()
            basket.removeFromBasket(productId: userBasketInstance.basket[indexPath.row].product.id) { response in
                switch response.result {
                case .success(let result):
                    switch result.result {
                    case 1:
                        self.userBasketInstance.deleteBasketItem(at: indexPath.row)
                        
                        DispatchQueue.main.async {
                            tableView.reloadData()
                            self.totalBasketCost.value = self.userBasketInstance.getBasketCost()
                        }
                        
                        log(message: "\(result)", .Success)
                    default:
                        DispatchQueue.main.async {
                            showAlert(forController: self, message: "Remove from cart failed")
                        }
                        log(message: "\(result)", .Error)
                    }
                    
                case .failure(let error):
                    log(message: error.localizedDescription, .Error)
                }
            }
        }
    }
}

extension BasketViewController: BasketViewControllerDelegate {
    func IncreaseBasketCost(by price: Int) {
        totalBasketCost.value += price
    }
    
    func DecreaseBasketCost(by price: Int) {
        totalBasketCost.value -= price
    }
    
    func MakePayment() {
        guard !userBasketInstance.basket.isEmpty else { return }
        
        let basket = RequestFactory.shared.makeBasketRequestFactory()
        basket.payBasket(userId: 123, basketCost: totalBasketCost.value, userBalance: 170000) { response in
            switch response.result {
            case .success(let result):
                switch result.result {
                case 1:
                    self.userBasketInstance.clearBasket()
                    
                    DispatchQueue.main.async {
                        self.basketTableView.reloadData()
                        self.totalBasketCost.value = 0
                    }
                    
                    log(message: "\(result)", .Success)
                default:
                    DispatchQueue.main.async {
                        showAlert(forController: self, message: result.userMessage)
                    }
                    log(message: "\(result)", .Error)
                }
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
}
