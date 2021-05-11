//
//  foodItemTableViewCell.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-11.//
import UIKit
import Kingfisher
class foodItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodDescription: UILabel!
    @IBOutlet weak var imgFood: UIImageView!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var switchFoodStatus: UISwitch!
    
    var delegate: FoodItemCellActions?
    var foodItem: FoodItem?
    
    var rowIndex = 0
    
    
    class var reuseIdentifier: String {
        return "foodItemCellReusable"
    }
    class var nibName: String {
        return "foodItemTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configXIB(foodItem: FoodItem, index: Int) {
        
        lblFoodName.text = foodItem.foodName
        lblFoodDescription.text = foodItem.foodDescription
        imgFood.kf.setImage(with: URL(string: foodItem.foodImage))
        lblDiscount.text = "\(foodItem.foodDiscount)%"
        
        switchFoodStatus.isOn = foodItem.isActive
        
        self.rowIndex = index
        self.foodItem = foodItem
        
        
    }
    
    @IBAction func onFoodStatusChanged(_ sender: UISwitch) {
        
        self.delegate?.onFoodItemStatusChanged(foodItem: self.foodItem!, status: sender.isOn)
    }
}
protocol FoodItemCellActions {
    func onFoodItemStatusChanged(foodItem: FoodItem, status: Bool)
    
    
}
