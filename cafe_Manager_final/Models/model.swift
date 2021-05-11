//
//  model.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-10.
//

import Foundation

struct Category {
    var categoryID: String
    var categoryName: String
}

struct Admin {
    var userName: String
    var email: String
    var password: String
    var phoneNo: String
}

struct FoodItem {
    var foodItemID: String
    var foodName: String
    var foodDescription: String
    var foodPrice: Double
    var foodDiscount: Int
    var foodImage: String
    var foodCategory: String
    var isActive: Bool
}
struct Order {
    var orderID: String
    var customerName: String
    var date: Double
    var customerEmail: String
    var statusCode: Int
    var orderItems: [orderItem] = []
}
struct orderItem {
    var itemName: String
    var price: Double
}
