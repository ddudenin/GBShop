//
//  ProductsTableViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 03.10.2021.
//

import UIKit

class ProductsTableViewController: UITableViewController {
    
    private var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ProductTableViewCell", bundle: .none), forCellReuseIdentifier: "ProductCell")
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        
        let product = products[indexPath.row]
        cell.configure(product: product)
        
        return cell
    }
    
    private func loadProductList() {
        let catalog = RequestFactory.instance.makeCatalogRequestFactory()
        catalog.getProducts(page: 1, category: 1) { response in
            switch response.result {
            case .success(let products):
                DispatchQueue.main.async {
                    self.products = products
                    self.tableView.reloadData()
                }
                
                log(message: "\(products)", .Success)
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
}
