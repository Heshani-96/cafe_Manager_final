//
//  RootStoreViewController.swift
//  cafe_Manager_final
//
//  Created by Heshani Chamalka on 2021-05-10.
//

import UIKit

class RootStoreViewController: UIViewController {
    
    var tabBarContainer: UITabBarController?
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tabBarSegue" {
            self.tabBarContainer = segue.destination as? UITabBarController
        }
        self.tabBarContainer?.tabBar.isHidden = true
    }
    
    
    @IBAction func onSegmentedIndexChange(_ sender: UISegmentedControl) {
        tabBarContainer?.selectedIndex = sender.selectedSegmentIndex
    }
    
}
