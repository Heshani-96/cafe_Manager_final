//
//  orderSummeryTableViewCell.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-11.
//

import UIKit

class orderSummeryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblItems: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblOrderTotal: UILabel!
    
    class var reuseIdentifier: String {
        return "orderSummeryReusable"
    }
    class var nibName: String {
        return "orderSummeryTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configXIB(order: Order) {
        lblOrderID.text = order.orderID
        
        var foodName: String = ""
        var orderInfo: String = ""
        var totalAmount: Double = 0
        
        
        for orderItem in order.orderItems {
            print(orderItem.itemName)
            foodName += "\n\(orderItem.itemName)"
            orderInfo += "\n1 X \(orderItem.price) LKR"
            totalAmount += 1 + orderItem.price
        }
        lblItems.text = foodName
        lblQuantity.text = orderInfo
        lblOrderTotal.text = "Total: \(totalAmount)"
    }
}
