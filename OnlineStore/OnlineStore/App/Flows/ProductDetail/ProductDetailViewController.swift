//
//  ProductDetailViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 07.10.2021.
//

import UIKit

protocol ProductDetailViewControllerDelegate: AnyObject {
    func addProductToBasket()
}

class ProductDetailViewController: UIViewController {
    
    private lazy var productHeaderView = ProductHeaderView()
    private lazy var productInfoView = ProductInfoView()
    private lazy var reviewsTableView = UITableView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var product = Product(id: -1, name: "", price: 0)
    private var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        loadReviews()
        
        productHeaderView.productDelegate = self
    }
    
    func configure(product: Product) {
        self.product = product
        
        let catalog = RequestFactory.shared.makeCatalogRequestFactory()
        catalog.getProduct(by: product.id) { response in
            switch response.result {
            case .success(let data):
                DispatchQueue
                    .main
                    .async {
                        self.productHeaderView.configure(product: data.productInfo)
                        self.productInfoView.configure(description: data.productInfo.description)
                    }
                log(message: "\(product)", .Success)
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    func configureView() {
        self.view.backgroundColor = .systemBackground
        configureScrollView()
        
        addHeaderView()
        addInfoView()
        
        addReviewsTableView()
        configureReviewsTableView()
    }
    
    private func configureScrollView() {
        self.view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView
                .topAnchor
                .constraint(equalTo: self.view.topAnchor),
            scrollView
                .trailingAnchor
                .constraint(equalTo: self.view.trailingAnchor),
            scrollView
                .leadingAnchor
                .constraint(equalTo: self.view.leadingAnchor),
            scrollView
                .bottomAnchor
                .constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func addHeaderView() {
        scrollView.addSubview(productHeaderView)
        
        productHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productHeaderView
                .topAnchor
                .constraint(equalTo: self.scrollView.topAnchor,
                            constant: 5),
            productHeaderView
                .leadingAnchor
                .constraint(equalTo: self.view.leadingAnchor),
            productHeaderView
                .trailingAnchor
                .constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func addInfoView() {
        scrollView.addSubview(productInfoView)
        
        productInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productInfoView
                .topAnchor
                .constraint(equalTo: productHeaderView.bottomAnchor),
            productInfoView
                .leadingAnchor
                .constraint(equalTo: self.view.leadingAnchor),
            productInfoView
                .trailingAnchor
                .constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    private func addReviewsTableView() {
        scrollView.addSubview(reviewsTableView)
        
        reviewsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reviewsTableView
                .topAnchor
                .constraint(equalTo: productInfoView.bottomAnchor,
                           constant: 10),
            reviewsTableView
                .leadingAnchor
                .constraint(equalTo: self.view.leadingAnchor,
                            constant: 10),
            reviewsTableView
                .trailingAnchor
                .constraint(equalTo: self.view.trailingAnchor,
                            constant: -10),
            reviewsTableView
                .bottomAnchor
                .constraint(equalTo: scrollView.bottomAnchor),
            reviewsTableView
                .heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    private func configureReviewsTableView() {
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
        reviewsTableView.register(UINib(nibName: "ReviewTableViewCell",
                                        bundle: .none),
                                  forCellReuseIdentifier: "ReviewCell")
    }
    
    private func loadReviews() {
        let review = RequestFactory.shared.makeReviewRequestFactory()
        review.getReviewsForProduct(withId: 2707) { response in
            switch response.result {
            case .success(let reviews):
                log(message: "\(reviews)", .Success)
                DispatchQueue
                    .main
                    .async {
                        self.reviews = reviews
                        self.reviewsTableView.reloadData()
                    }
            case .failure(let error):
                log(message: error.localizedDescription, .Error)
            }
        }
    }
}

extension ProductDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewTableViewCell else {
            return UITableViewCell()
        }
        
        let review = reviews[indexPath.row]
        cell.configure(review: review)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProductDetailViewController: ProductDetailViewControllerDelegate {
    
    func addProductToBasket() {
        let basket = RequestFactory.shared.makeBasketRequestFactory()
        
        basket.addToBasket(productId: product.id,
                           quantity: 1) { response in
            switch response.result {
            case .success(let result):
                switch result.result {
                case 1:
                    UserBasketManager.shared.addBasketItem(from: self.product)
                    log(message: "\(result)", .Success)
                default:
                    DispatchQueue
                        .main
                        .async {
                            showAlertController(forController: self,
                                                message: "Add to cart failed")
                        }
                    log(message: "\(result)", .Error)
                }
                
            case .failure(let error):
                DispatchQueue
                    .main
                    .async {
                        showAlertController(forController: self,
                                            message: error.localizedDescription)
                    }
                log(message: error.localizedDescription, .Error)
            }
        }
    }
}
