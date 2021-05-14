//
//  CategoryViewController.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-10.
//

import UIKit
import FirebaseDatabase
import Loaf

class CategoryViewController: UIViewController {
    
    let databaseReference = Database.database().reference()
    
    var categoryList: [Category] = []
    

    @IBOutlet weak var lblAddNewCategory: UILabel!
    @IBOutlet weak var txtAddCategory: UITextField!
    @IBOutlet weak var tblAddCategory: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblAddCategory.register(UINib(nibName: categoryInfoTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: categoryInfoTableViewCell.reuseIdentifier)
        
        refreshCategories()
    }
    

    @IBAction func btnAddCategory(_ sender: UIButton) {
        
        if let text = txtAddCategory.text, text.isEmpty {
            Loaf("Add a category!!", state: .error, sender: self).show()
            return
        }
        if let name = txtAddCategory.text {
            addCategory(name: name)
        }
        else {
            Loaf("Enter a category name", state: .error, sender: self).show()

        }
       
    }
}
extension CategoryViewController {
    func addCategory(name: String) {
         databaseReference
            .child("categories")
            .childByAutoId()
            .child("name")
            .setValue(name) {
                error, ref in
                if let error = error {
                    Loaf(error.localizedDescription, state: .error, sender: self).show()
                }
                else {
                    Loaf("Category Created", state: .success, sender: self).show()
                    self.refreshCategories()

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
                    self.tblAddCategory.reloadData()
                }
           })
    }
    
    func removeCategory(category: Category) {
        databaseReference
            .child("categories")
            .child(category.categoryID)
            .removeValue() {
                error, databaseReference in
                if let error = error {
                    Loaf("could not remove category", state: .error, sender: self).show()
                }
                else {
                    Loaf("Category removed", state: .success, sender: self).show()
                    self.refreshCategories()

                }
            }
        
    }
    
 }
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblAddCategory.dequeueReusableCell(withIdentifier: categoryInfoTableViewCell.reuseIdentifier, for: indexPath) as! categoryInfoTableViewCell
        cell.selectionStyle = .none
        cell.configXIB(category: self.categoryList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeCategory(category: categoryList[indexPath.row])
            refreshCategories()
        }
    }
}
