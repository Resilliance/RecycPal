//
//  InfoViewController.swift
//  RecycPal
//
//  Created by Denielle Abaquita on 1/15/22.
//

import UIKit

class InfoViewController: UITableViewController {
    
    let materials: [Material] = [
        Material(title: "Paper", image: UIImage(named: "paper")!, content: "Lorem ipsum"),
        Material(title: "Plastic", image: UIImage(named: "plastic")!, content: "Lorem ipsum"),
        Material(title: "Metal", image: UIImage(named: "metal")!, content: "Lorem ipsum"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Information"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.green
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 35)]
        appearance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        tableView.backgroundColor = .clear
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 30
        }
        self.registerCustomCells()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }
    
    private func registerCustomCells() {
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
    }

    // MARK: Table View Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return materials.count
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        header.textLabel?.frame = header.bounds
        header.textLabel?.textAlignment = .left
        header.textLabel?.text =  header.textLabel?.text?.capitalized
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else {
            return "Materials"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier,
            for: indexPath
        ) as? CustomTableViewCell else {
            print("Something went wrong with CustomTableViewCell")
            return UITableViewCell()
        }
        if indexPath.section == 0 {
            var buttonConfig = UIButton.Configuration.filled()
            buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
            buttonConfig.background.backgroundColor = Colors.yellow
            buttonConfig.cornerStyle = .medium
            
            cell.cellContentButton.configuration = buttonConfig
        } else {
            let material = materials[indexPath.row]
            
            // Button Config
            cell.cellContentButton.configuration = setUpButtonConfig(
                material: material
            )
            
            // Inject cell navigation
            cell.selectCellHandler = { [weak self] in
                guard let self = self else { return }
                let vc = MoreInfoViewController()
                vc.material = material
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Pressed a cell")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height / 5
    }
    
    private func setUpButtonConfig(material: Material) -> UIButton.Configuration {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
        buttonConfig.background.backgroundColor = Colors.yellow
        buttonConfig.cornerStyle = .medium
        buttonConfig.imagePlacement = .leading
        buttonConfig.image = material.image
        
        let attributes = AttributeContainer(
            [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 50),
             NSAttributedString.Key.foregroundColor: Colors.green]
        )
        buttonConfig.attributedTitle = AttributedString(material.title, attributes: attributes)
        
        buttonConfig.imagePadding = 40
        return buttonConfig
    }
}
