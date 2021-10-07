//
//  ProductDetailViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 07.10.2021.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    private lazy var productDetailView = ProductDetailView()
    private lazy var productInfoView = ProductInfoView()
    private lazy var reviewsTableView = UITableView()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var product: Product?
    private var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        loadReviews()
        
        guard let product = self.product else { return }
        productDetailView.configure(product: product)
    }
    
    func configure(product: Product) {
        self.product = product
    }
    
    func configureView() {
        self.view.backgroundColor = .systemBackground
        configureScrollView()
        
        addDetailView()
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
    
    private func addDetailView() {
        scrollView.addSubview(productDetailView)
        
        productDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productDetailView.topAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 25),
            productDetailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productDetailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func addInfoView() {
        scrollView.addSubview(productInfoView)
        
        productInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productInfoView.topAnchor.constraint(equalTo: self.productDetailView.bottomAnchor),
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
