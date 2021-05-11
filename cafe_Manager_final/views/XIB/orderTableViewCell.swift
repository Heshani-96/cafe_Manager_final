//
//  orderTableViewCell.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-11.
//

import UIKit

class orderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class var reuseIdentifier: String {
        return "orderReusable"
    }
    class var nibName: String {
        return "orderTableViewCell"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func confligXIB(order: Order) {
        switch order.statusCode {
        case 0:
            orderStatus.text = "  Pending  "
        case 1:
            orderStatus.text = "  Prepairing  "
        case 2:
            orderStatus.text = "  Ready  "
        case 3:
            orderStatus.text = "  Done  "
        case 4:
            orderStatus.text = "  Arrive  "
        case 5:
            orderStatus.text = "  Cancel  "

            
        default:
            return
        }
        lblOrderID.text = order.orderID
        lblCustomerName.text = order.customerName
        
    }
}
