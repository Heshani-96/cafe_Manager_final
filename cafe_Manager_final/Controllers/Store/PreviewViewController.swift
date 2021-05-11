//
//  PreviewViewController.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-10.
//

import UIKit
import Firebase
import Loaf

class PreviewViewController: UIViewController {
    let databaseReference = Database.database().reference()

    
    
    @IBOutlet weak var colloctionViewCategories: UICollectionView!
    @IBOutlet weak var tblFoodItems: UITableView!
    
    var  categoryList: [Category] = []
    var foodItemList: [FoodItem] = []
    var filteredFood: [FoodItem] = []
    
    var selectedCategoryIndex = 0
    var selectedFoodIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewNib = UINib(nibName: categoryCollectionViewCell.nibName, bundle: nil)
        colloctionViewCategories.register(collectionViewNib, forCellWithReuseIdentifier: categoryCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.colloctionViewCategories?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 80, height: 30)

    }
        tblFoodItems.register(UINib(nibName: foodItemTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: foodItemTableViewCell.reuseIdentifier)
    }
    override func viewDidAppear(_ animated: Bool) {
        refreshCategories()
        refreshFood()
    }

}
extension PreviewViewController {
    
    func filterFood(category: Category){
        filteredFood = foodItemList.filter{$0.foodCategory == category.categoryName}
        tblFoodItems.reloadData()
        
    }

func refreshCategories() {
    self.categoryList.removeAll()
    databaseReference
        .child("categories")
        .observeSingleEvent(of: .value, with: {
        snapshot in
            if snapshot.hasChildren() {
                guard let data = snapshot.value as? [String: Any] else {
                   return
                }
                for category in data  {
                    if let categoryInfo = category.value as? [String: String] {
                        self.categoryList.append(Category(categoryID: category.key, categoryName: categoryInfo["name"]!))
                    }
                }
                self.colloctionViewCategories.reloadData()
            }
       })
    }
    
    func changeFoodStatus(foodItem: FoodItem, status: Bool){
        databaseReference
            .child("foodItems")
            .child(foodItem.foodItemID)
            .child("isActive")
            .setValue(status) {
                error, referance in
                if error != nil {
                    Loaf("food status not changed", state: .error, sender: self).show()
                }
                else {
                    Loaf("food status changed", state: .success, sender: self).show()

                }
            }
    }
   
    func refreshFood() {
        
        foodItemList.removeAll()
        filteredFood.removeAll()
        
        databaseReference
            .child("foodItems")
            .observeSingleEvent(of: .value, with: {
                snapshot in
                if snapshot.hasChildren() {
                    guard let data = snapshot.value as? [String: Any] else {
                        NSLog("could not parse data")
                        return
                    }
                    for food in data {
                        if let foodInfo = food.value as? [String: Any] {
                            self.foodItemList.append(FoodItem(
                                                        foodItemID: food.key,
                                                        foodName: foodInfo["food-name"] as! String,
                                                        foodDescription: foodInfo["description"] as! String,
                                                        foodPrice: foodInfo["price"] as! Double,
                                                        foodDiscount: foodInfo["discount"] as! Int,
                                                        foodImage: foodInfo["image"] as! String,
                                                        foodCategory: foodInfo["category"] as! String,
                                                        isActive: foodInfo["isActive"] as! Bool))
                        }
                    }
                    
                    self.filteredFood.append(contentsOf: self.foodItemList)
                    self.tblFoodItems.reloadData()
                }
            })
        
    }
    
    
}
extension PreviewViewController: UITableViewDelegate, UITableViewDataSource, FoodItemCellActions {
    func onFoodItemStatusChanged(foodItem: FoodItem, status: Bool) {
        self.changeFoodStatus(foodItem: foodItem, status: status)
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFoodItems.dequeueReusableCell(withIdentifier: foodItemTableViewCell.reuseIdentifier, for: indexPath) as! foodItemTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.configXIB(foodItem: filteredFood[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFoodIndex = indexPath.row
    }
}
extension PreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = colloctionViewCategories.dequeueReusableCell(withReuseIdentifier: categoryCollectionViewCell.reuseIdentifier, for: indexPath) as? categoryCollectionViewCell {
            cell.configXIB(category: categoryList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.row
        UIView.transition(with: colloctionViewCategories, duration: 0.3, options: .transitionCrossDissolve, animations: {self.colloctionViewCategories.reloadData()}, completion: nil)
        
        filterFood(category: categoryList[indexPath.row])
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: categoryCollectionViewCell = Bundle.main.loadNibNamed(categoryCollectionViewCell.nibName,
                                                                owner: self,
                                                                options: nil)?.first as? categoryCollectionViewCell else {
            return CGSize.zero
        }
        cell.configXIB(category: categoryList[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 30)
    }
    
    
}

