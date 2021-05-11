//
//  categoryInfoTableViewCell.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-11.
//

import UIKit

class categoryInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCategoryName: UILabel!
    
    class var reuseIdentifier: String {
        return "categoryInfoReusable"
    }
    
    class var nibName: String {
        return "categoryInfoTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configXIB(category: Category) {
        lblCategoryName.text = category.categoryName
    }
    
}
