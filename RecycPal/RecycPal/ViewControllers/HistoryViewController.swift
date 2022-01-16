//
//  HistoryViewController.swift
//  RecycPal
//
//  Created by Denielle Abaquita on 1/15/22.
//

import UIKit

class HistoryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.green
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 35)]
        appearance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        tableView.backgroundColor = Colors.green
        tableView.separatorColor = Colors.green
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
            return 10
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
            return "Previous Pictures"
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
            cell.cellContentButton.configuration = setUpButtonConfig(
                title: "Find Your Nearest Recycling Center",
                image: UIImage(named: "location")!
            )
            
            cell.selectCellHandler = {
                if let url = URL(
                    string: "https://search.earth911.com/?utm_source=earth911-header"
                ) {
                    UIApplication.shared.open(url as URL, options:[:], completionHandler:nil)
                }
            }
        } else {
            var buttonConfig = UIButton.Configuration.filled()
            buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
            buttonConfig.background.backgroundColor = Colors.yellow
            buttonConfig.cornerStyle = .medium
            
            cell.cellContentButton.configuration = buttonConfig
            
            cell.selectCellHandler = {
                print("TODO - Implement previous pictures")
            }
        }
        
        cell.backgroundColor = Colors.green
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Pressed a cell")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height / 5
    }
    
    private func setUpButtonConfig(title: String, image: UIImage) -> UIButton.Configuration {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
        buttonConfig.background.backgroundColor = Colors.yellow
        buttonConfig.cornerStyle = .medium
        buttonConfig.imagePlacement = .leading
        buttonConfig.image = image
        
        let attributes = AttributeContainer(
            [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
             NSAttributedString.Key.foregroundColor: Colors.green]
        )
        buttonConfig.attributedTitle = AttributedString(title, attributes: attributes)
        
        buttonConfig.imagePadding = 40
        return buttonConfig
    }
}
