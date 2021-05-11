//
//  orderSummeryTableViewCell.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-11.
//

import UIKit

class orderSummeryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    class var reuseIdentifier: String {
        return "orderSummeryReusable"
    }
    class var nibName: String {
        return "orderSummeryTableViewCell"
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
