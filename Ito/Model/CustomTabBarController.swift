//
//  CustomTabBarController.swift
//  Ito
//
//  Created by 二宮啓 on 2020/04/03.
//  Copyright © 2020 二宮啓. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate  {

    var addFriendViewController: AddFriendViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        addFriendViewController = AddFriendViewController()
        
        addFriendViewController.tabBarItem.image = UIImage(named: "action")
        addFriendViewController.tabBarItem.selectedImage = UIImage(named: "action-selected")
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
      if viewController.isKind(of: AddFriendViewController.self) {
         let vc =  AddFriendViewController()
         vc.modalPresentationStyle = .overFullScreen
         self.present(vc, animated: true, completion: nil)
         return false
      }
      return true
    }
}
