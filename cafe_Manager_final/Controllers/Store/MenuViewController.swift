//
//  MenuViewController.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-10.
//

import UIKit
import Firebase
import FirebaseStorage
import Loaf

class MenuViewController: UIViewController {
    
    @IBOutlet weak var lblAddNewFoodItem: UILabel!
    @IBOutlet weak var txtFoodName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var imgFood: UIImageView!
    
    let databaseReference = Database.database().reference()
    
    var categoryPicker =  UIPickerView()
    var categoryList: [Category] = []
    var selectedCategoryIndex = 0

    var selectedImage: UIImage?
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onPickImageClicked))
        self.imgFood.isUserInteractionEnabled = true
        self.imgFood.addGestureRecognizer(gesture)
        self.refreshCategories()
    }
    
    
    
    @IBAction func onAddPressed(_ sender: UIButton) {
        if let text = txtFoodName.text, text.isEmpty {
            Loaf("Enter a food name", state: .error, sender: self).show()
            return
        }
        if let text = txtDescription.text, text.isEmpty {
            Loaf("Enter a Description", state: .error, sender: self).show()
            return
        }
        if let text = txtPrice.text, text.isEmpty {
            Loaf("Enter a price", state: .error, sender: self).show()
            return
        }
        if let text = txtCategory.text, text.isEmpty {
            Loaf("Enter a food category", state: .error, sender: self).show()
            return
        }
        
        let foodItem = FoodItem(
            foodItemID: "",
            foodName: txtFoodName.text ?? "",
            foodDescription: txtDescription.text ?? "",
            foodPrice: Double (txtPrice.text ?? "") ?? 0,
            foodDiscount: Int (txtDiscount.text ?? "") ?? 0,
            foodImage: "",
            foodCategory: categoryList[selectedCategoryIndex].categoryName,
            isActive: true)
        
        self.addFoodItem(foodItem: foodItem)
        
//        if !inputValidator.isValidFoodName(foodName: txtFoodName.text ?? "") {
//            Loaf("Please enter a valid Food name", state: .error, sender: self).show()
//            return
//        }
     
        
    }
    
    
    @objc func onPickImageClicked( sender: UIImageView){
        self.imagePicker.present(from: sender)
    }
}

extension MenuViewController {
    func addFoodItem(foodItem: FoodItem){
        
        
        guard let image = self.selectedImage else {
            Loaf("Add an image", state: .error, sender: self).show()
            return
        }
        
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            Storage.storage().reference().child("foodItemImages").child(foodItem.foodName).putData(uploadData, metadata: metaData) {
                meta, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    Loaf(error.localizedDescription, state: .error, sender: self).show()
                    return
                }
                
                Storage.storage().reference().child("foodItemImages").child(foodItem.foodName).downloadURL(completion: {
                    (url,error) in
                    guard let downloadURL = url else {
                        if let error = error {
                            print(error.localizedDescription)
                            Loaf(error.localizedDescription, state: .error, sender: self).show()
                        }

                        return
                    }
                    Loaf("image uploaded", state: .success, sender: self).show()

                    
                    let data = [
                        "food-name" : foodItem.foodName,
                        "description": foodItem.foodDescription,
                        "price": foodItem.foodPrice,
                        "discount": foodItem.foodDiscount,
                        "category": foodItem.foodCategory,
                        "isActive": foodItem.isActive,
                        "image": downloadURL.absoluteString
                        
                    ] as [String : Any]
                                self.databaseReference
                        .child("foodItems")
                        .childByAutoId()
                        .setValue(data) {
                            error, ref in
                            if let error = error {
                                Loaf(error.localizedDescription, state: .error, sender: self).show()
                            }
                            else {
                                Loaf("Food Item Added", state: .success, sender: self).show()
                                self.refreshCategories()

                            }
                        }
                    
                    
                })
            }
        }

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
                    self.setupCategoryPicker()
                }
           })
    }
}

extension MenuViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func setupCategoryPicker() {
        let pickerToolBar = UIToolbar()
        pickerToolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(onPickerCancelled))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        pickerToolBar.setItems([space, cancelButton], animated: true)
        
        txtCategory.inputAccessoryView = pickerToolBar
        txtCategory.inputView = categoryPicker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
    }
    @objc func onPickerCancelled() {
        self.view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row].categoryName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCategory.text = categoryList[row].categoryName
        selectedCategoryIndex = row
    }
}


extension MenuViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imgFood.image = image
        self.selectedImage = image
    }
}
