//
//  BasketViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 13.10.2021.
//

import UIKit

var gBasket = [BasketItem]()

protocol BasketViewControllerDelegate: AnyObject {
    func increaseBasketCost(by price: Int)
    func decreaseBasketCost(by price: Int)
    func makePayment()
}

class BasketViewController: UIViewController {
    
    private lazy var basketTableView = UITableView()
    private lazy var paymentView = PaymentView()
    
    private var totalBasketCost: Observable<Int> = Observable(0)
    private let userBasketInstance = UserBasketManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureView()
        
        paymentView.basketDelegate = self
        
        totalBasketCost.addObserver(self,
                                    options: [.initial, .new],
                                    closure: {
            [weak self] value, _ in
            self?.paymentView.setTotalPrice(price: value)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        totalBasketCost.value = userBasketInstance.getBasketCost()
        basketTableView.reloadData()
    }
    
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        
        addPaymentView()
        
        addBasketTableView()
        configureBasketTableView()
    }
    
    private func addBasketTableView() {
        self.view.addSubview(basketTableView)
        
        basketTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            basketTableView
                .topAnchor
                .constraint(equalTo: self.view.topAnchor,
                            constant: 50),
            basketTableView
                .leadingAnchor
                .constraint(equalTo: self.view.leadingAnchor),
            basketTableView
                .trailingAnchor
                .constraint(equalTo: self.view.trailingAnchor),
            basketTableView
                .bottomAnchor
                .constraint(equalTo: paymentView.topAnchor,
                            constant: -10)
        ])
    }
    
    private func addPaymentView() {
        self.view.addSubview(paymentView)
        
        paymentView.translatesAutoresizingMaskIntoConstraints = false
        
        let tabBarHeight: CGFloat = self.tabBarController?
            .tabBar
            .frame
            .size
            .height ?? 0
        let constraint: CGFloat = 20
        
        NSLayoutConstraint.activate([
            paymentView
                .leadingAnchor
                .constraint(equalTo: self.view.leadingAnchor),
            paymentView
                .trailingAnchor
                .constraint(equalTo: self.view.trailingAnchor),
            paymentView
                .bottomAnchor
                .constraint(equalTo: self.view.bottomAnchor,
                            constant: -(tabBarHeight + constraint)),
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
        guard let cell = basketTableView.dequeueReusableCell(withIdentifier: "BasketCell",
                                                             for: indexPath) as? BasketTableViewCell else {
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
            let id = userBasketInstance.basket[indexPath.row].product.id
            let basket = RequestFactory.shared.makeBasketRequestFactory()
            
            basket.removeFromBasket(productId: id) { response in
                switch response.result {
                case .success(let result):
                    switch result.result {
                    case 1:
                        UserBasketManager.shared.deleteBasketItem(at: indexPath.row)
                        
                        DispatchQueue
                            .main
                            .async {
                                tableView.reloadData()
                                self.totalBasketCost.value = UserBasketManager.shared.getBasketCost()
                            }
                        
                        log(message: "\(result)", .Success)
                    default:
                        DispatchQueue
                            .main
                            .async {
                                showAlertController(forController: self,
                                                    message: "Remove from cart failed")
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
    func increaseBasketCost(by price: Int) {
        totalBasketCost.value += price
    }
    
    func decreaseBasketCost(by price: Int) {
        totalBasketCost.value -= price
    }
    
    func makePayment() {
        guard !userBasketInstance.basket.isEmpty else { return }
        
        let basket = RequestFactory.shared.makeBasketRequestFactory()
        basket.payBasket(userId: 123,
                         basketCost: totalBasketCost.value,
                         userBalance: 170000) { response in
            switch response.result {
            case .success(let result):
                switch result.result {
                case 1:
                    UserBasketManager.shared.clearBasket()
                    
                    DispatchQueue
                        .main
                        .async {
                            self.basketTableView.reloadData()
                            self.totalBasketCost.value = 0
                        }
                    
                    log(message: "\(result)", .Success)
                default:
                    DispatchQueue
                        .main
                        .async {
                            showAlertController(forController: self,
                                                message: result.userMessage)
                        }
                    log(message: "\(result)", .Error)
                }
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
}
