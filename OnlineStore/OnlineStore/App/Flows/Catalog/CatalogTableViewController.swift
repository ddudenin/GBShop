//
//  CatalogTableViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 03.10.2021.
//

import UIKit
import Firebase

class CatalogTableViewController: UITableViewController {
    
    private var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ProductTableViewCell",
                                      bundle: .none),
                                forCellReuseIdentifier: "ProductCell")
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProductList()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductTableViewCell else {
            let message = "Ошибка создания ячейки продукта"
            Firebase.Crashlytics.crashlytics().log(message)
            assertionFailure(message)
            return UITableViewCell()
        }
        
        let product = products[indexPath.row]
        cell.configure(product: product)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let product = products[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailScreen") as? ProductDetailViewController else {
            let message = "Can not convert VC to ProductDetailViewController"
            log(message: message, .Error)
            Firebase.Crashlytics.crashlytics().log(message)
            assertionFailure(message)
            return
        }
        
        detailViewController.configure(product: product)
        
        self.navigationController?
            .pushViewController(detailViewController,
                                animated: true)
    }
    
    private func loadProductList() {
        let catalog = RequestFactory.shared.makeCatalogRequestFactory()
        catalog.getProducts(page: 1,
                            category: 1) { response in
            switch response.result {
            case .success(let products):
                DispatchQueue
                    .main
                    .async {
                        self.products = products
                        self.tableView.reloadData()
                    }
                
                log(message: "\(products)", .Success)
                Firebase.Analytics.logEvent(AnalyticsEventScreenView,
                                            parameters: [
                                                AnalyticsParameterSuccess: true,
                                                AnalyticsParameterValue: products.count
                                            ])
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
                Firebase.Analytics.logEvent(AnalyticsEventScreenView,
                                            parameters: [
                                                AnalyticsParameterSuccess: false,
                                                AnalyticsParameterContent: error.localizedDescription
                                            ])
            }
        }
    }
    
    @objc private func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let pressPoint = longPressGesture.location(in: self.tableView)
        
        guard let indexPath = self.tableView.indexPathForRow(at: pressPoint) else { return }
        
        switch longPressGesture.state {
        case .began:
            print("Long press on row, at \(indexPath.row)")
            let product = products[indexPath.row]
        default:
            return
        }
    }
}
