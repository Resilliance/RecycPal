//
//  MoreInfoViewController.swift
//  RecycPal
//
//  Created by Denielle Abaquita on 1/16/22.
//

import UIKit

class MoreInfoViewController: UIViewController {
    
    var material: Material?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.green
        appearance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        view.backgroundColor = Colors.green
    }
}
