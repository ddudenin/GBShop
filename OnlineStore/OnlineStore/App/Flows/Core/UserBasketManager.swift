//
//  UserBasketManager.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 14.10.2021.
//

import Foundation

class UserBasketManager {
    
    static let shared = UserBasketManager()
    
    private(set) var basket = [BasketItem]()
    
    private init() {
        
    }
    
    func getBasketCost() -> Int{
        var basketCost = 0
        
        for item in basket {
            basketCost += item.product.price * item.count
        }
        
        return basketCost
    }
    
    func addBasketItem(from product: Product) {
        let index = basket.firstIndex(where: { $0.product.id == product.id })
        
        if let basketItemIndex = index {
            basket[basketItemIndex].count += 1
        } else {
            basket.append(BasketItem(product: product, count: 1))
        }
    }
    
    func deleteBasketItem(at index: Int) {
        basket.remove(at: index)
    }
    
    func clearBasket() {
        basket.removeAll()
    }
    
    func changeCount(at index: Int, increase: Bool) {
        basket[index].count += increase ? 1 : -1
    }
}
