//
//  AccountViewController.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-10.
//

import UIKit
import Firebase
import Loaf

class AccountViewController: UIViewController {
    let databaseReference = Database.database().reference()

    
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var tblAccount: UITableView!
    
    var orderList: [Order] = []
    var filteredOrders: [Order] = []
    
    var orderTotal: Double = 0
    let sessionManager = SessionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblAccount.register(UINib(nibName: orderSummeryTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: orderSummeryTableViewCell.reuseIdentifier)
        
//        self.tblAccount.estimatedRowHeight = 100
//        self.tblAccount.rowHeight = UITableView.automaticDimension

    }
    override func viewDidAppear(_ animated: Bool) {
        fetchOrders()
    }
  
    @IBAction func btnSignOut(_ sender: UIButton) {
        sessionManager.clearUserLoggedState()
        dismiss(animated: true, completion: nil)
    }
}

extension AccountViewController {
    func filterOrders() {
        
    }
    func getOrderTotal() {
        self.orderTotal = 0
        for order in filteredOrders {
            for item in order.orderItems {
                self.orderTotal += item.price
            }
        }
        lblPrice.text = "\(orderTotal) LKR"
    }
    
    func fetchOrders(){
        self.filteredOrders.removeAll()
        self.orderList.removeAll()
        self.databaseReference
            .child("order")


            .observeSingleEvent(of: .value, with: {
                snapshot in
                if snapshot.hasChildren() {
                   
                    guard let data = snapshot.value as? [String: Any] else {
                        Loaf("cannot parse data", state: .error, sender: self).show()
                          return
                    }
                    for order in data {
                        if let orderInfo = order.value as? [String: Any] {
                            var singleOrder = Order(
                                orderID: order.key,
                                customerName: orderInfo["customerName"] as! String,
                                date: orderInfo["date"] as! Double,
                                customerEmail: orderInfo["customerEmail"] as! String,
                                statusCode: orderInfo["statusCode"] as! Int)
                            
                            if let orderItems = orderInfo["items"] as? [String: Any] {
                                for item in orderItems {
                                    if let singleItem = item.value as? [String: Any] {
                                        singleOrder.orderItems.append(orderItem(
                                                                        itemName: singleItem["itemName"] as! String,
                                                                        price: singleItem["price"] as! Double ))
                                    }
                                }
                            }
                            self.orderList.append(singleOrder)
                            
                        }
                    }
                    
                    self.filteredOrders.append(contentsOf: self.orderList)
                    self.getOrderTotal()
                    self.tblAccount.reloadData()
                    
                } else {
                    Loaf("no order found", state: .error, sender: self).show()

                }
            })
    }
    
}
extension AccountViewController: UITableViewDelegate, UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOrders.count
     }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblAccount.dequeueReusableCell(withIdentifier: orderSummeryTableViewCell.reuseIdentifier, for: indexPath) as! orderSummeryTableViewCell
        cell.selectionStyle = .none
//        cell.delegate = self
        cell.configXIB(order: filteredOrders[indexPath.row])
        return cell
    }
    
}

