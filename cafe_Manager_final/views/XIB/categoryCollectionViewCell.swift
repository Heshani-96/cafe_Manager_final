//
//  categoryCollectionViewCell.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-11.
//

import UIKit

class categoryCollectionViewCell: UICollectionViewCell {
     
    @IBOutlet weak var lblCategoryName: UILabel!
    
    class var reuseIdentifier: String {
        return "categoryCollectionCellReusable"
    }
    class var nibName: String {
        return "categoryCollectionViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configXIB(category: Category) {
        lblCategoryName.text = category.categoryName
    }

}
