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
        self.tabBar.backgroundColor = Colors.green
        self.tabBar.isTranslucent = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = view.frame.height / 10
        tabBar.frame.origin.y = view.frame.height - view.frame.height / 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let item1 = UINavigationController(rootViewController: HistoryViewController(style: .grouped))
        let icon1 = UITabBarItem(
            title: "History",
            image: UIImage(systemName: "books.vertical"),
            selectedImage: UIImage(systemName: "books.vertical.fill")
        )
        item1.tabBarItem = icon1
        item1.navigationItem.largeTitleDisplayMode = .automatic
        item1.navigationBar.prefersLargeTitles = true
        
        let item2 = UINavigationController(rootViewController: CameraViewController())
        let icon2 = UITabBarItem(
            title: "Camera",
            image: UIImage(systemName: "camera"),
            selectedImage: UIImage(systemName: "camera.fill")
        )
        item2.tabBarItem = icon2
        
        let item3 = UINavigationController(rootViewController: InfoViewController(style: .grouped))
        let icon3 = UITabBarItem(
            title: "Info",
            image: UIImage(systemName: "info.circle"),
            selectedImage: UIImage(systemName: "info.circle.fill")
        )
        item3.tabBarItem = icon3
        item3.navigationItem.largeTitleDisplayMode = .automatic
        item3.navigationBar.prefersLargeTitles = true
        
        let controllers = [item1, item2, item3]
        self.viewControllers = controllers
        self.selectedIndex = 1
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
      print("Should select viewController: \(viewController.title ?? "") ?")
      return true;
    }
}

