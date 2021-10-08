//
//  ProductDetailViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 07.10.2021.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    private lazy var productHeaderView = ProductHeaderView()
    private lazy var productInfoView = ProductInfoView()
    private lazy var reviewsTableView = UITableView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var productInfo = ProductInfo(name: "", price: 0, description: "")
    private var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        loadReviews()
    }
    
    func configure(product: Product) {
        let catalog = RequestFactory.instance.makeCatalogRequestFactory()
        catalog.getProduct(by: product.id) { response in
            switch response.result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.productInfo = data.productInfo
                    self.productHeaderView.configure(product: self.productInfo)
                    self.productInfoView.configure(description: self.productInfo.description)
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
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func addHeaderView() {
        scrollView.addSubview(productHeaderView)
        
        productHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productHeaderView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 5),
            productHeaderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productHeaderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func addInfoView() {
        scrollView.addSubview(productInfoView)
        
        productInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productInfoView.topAnchor.constraint(equalTo: self.productHeaderView.bottomAnchor),
            productInfoView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            productInfoView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ])
    }
    
    private func addReviewsTableView() {
        scrollView.addSubview(reviewsTableView)
        
        reviewsTableView.separatorInset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 0.0)
        reviewsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reviewsTableView.topAnchor.constraint(equalTo: productInfoView.bottomAnchor),
            reviewsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            reviewsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            reviewsTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            reviewsTableView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    private func configureReviewsTableView() {
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
        reviewsTableView.register(UINib(nibName: "ReviewTableViewCell", bundle: .none), forCellReuseIdentifier: "ReviewCell")
    }
    
    private func loadReviews() {
        let review = RequestFactory.instance.makeReviewRequestFactory()
        review.getReviewsForProduct(withId: 2707) { response in
            switch response.result {
            case .success(let reviews):
                log(message: "\(reviews)", .Success)
                DispatchQueue.main.async {
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
