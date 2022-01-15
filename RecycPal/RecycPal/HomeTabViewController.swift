//
//  ViewController.swift
//  RecycPal
//
//  Created by Justin Esguerra on 1/15/22.
//

import UIKit

class HomeTabViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.tabBar.unselectedItemTintColor = UIColor.white
        self.tabBar.barTintColor = Colors.green
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let item1 = UINavigationController(rootViewController: HistoryViewController())
        let icon1 = UITabBarItem(
            title: "History",
            image: UIImage(systemName: "books.vertical"),
            selectedImage: UIImage(systemName: "books.vertical.fill")
        )
        item1.tabBarItem = icon1
        item1.navigationItem.largeTitleDisplayMode = .always
        item1.navigationBar.prefersLargeTitles = true
        
        let item2 = UINavigationController(rootViewController: CameraViewController())
        let icon2 = UITabBarItem(
            title: "Camera",
            image: UIImage(systemName: "camera"),
            selectedImage: UIImage(systemName: "camera.fill")
        )
        item2.tabBarItem = icon2
        item2.navigationItem.largeTitleDisplayMode = .always
        item2.navigationBar.prefersLargeTitles = true
        
        let item3 = UINavigationController(rootViewController: InfoViewController())
        let icon3 = UITabBarItem(
            title: "Info",
            image: UIImage(systemName: "info.circle"),
            selectedImage: UIImage(systemName: "info.circle.fill")
        )
        item3.tabBarItem = icon3
        item3.navigationItem.largeTitleDisplayMode = .always
        item3.navigationBar.prefersLargeTitles = true
        
        let controllers = [item1, item2, item3]
        self.viewControllers = controllers
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
      print("Should select viewController: \(viewController.title ?? "") ?")
      return true;
    }
}

