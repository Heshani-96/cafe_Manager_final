//
//  OrderViewController.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-10.
//

import UIKit
import Firebase
import Loaf


class OrderViewController: UIViewController {
    let databaseReference = Database.database().reference()
    
    var orders: [Order] = []
    var filteredOrders: [Order] = []
    

    
    
    @IBOutlet weak var tblOrders: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblOrders.register(UINib(nibName: orderTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: orderTableViewCell.reuseIdentifier)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchOrders()
        
    }
 
    @IBAction func onSegChanged(_ sender: UISegmentedControl) {
        filterOrders(status: sender.selectedSegmentIndex)
    }
    
}

extension OrderViewController {
    func filterOrders(status: Int) {
        filteredOrders.removeAll()
        filteredOrders = self.orders.filter{$0.statusCode == status}
        tblOrders.reloadData()
    }
    func fetchOrders(){
        self.filteredOrders.removeAll()
        self.orders.removeAll()
        self.databaseReference
            .child("order")
            .observe(.value, with: {
                snapshot in
                self.filteredOrders.removeAll()
                self.orders.removeAll()
           // })
//            .observeSingleEvent(of: .value, with: {
//                snapshot in
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
                            self.orders.append(singleOrder)
                            
                        }
                    }
                    
                    self.filteredOrders.append(contentsOf: self.orders)
                    self.onSegChanged(self. segmentControl)
                    
                } else {
                    Loaf("no order found", state: .error, sender: self).show()

                }
            })
    }
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOrders.dequeueReusableCell(withIdentifier: orderTableViewCell.reuseIdentifier, for: indexPath) as! orderTableViewCell
        cell.selectionStyle = .none
        cell.confligXIB(order: filteredOrders[indexPath.row])
        return cell
    }
    
    
}
