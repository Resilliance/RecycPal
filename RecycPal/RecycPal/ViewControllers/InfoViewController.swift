//
//  InfoViewController.swift
//  RecycPal
//
//  Created by Denielle Abaquita on 1/15/22.
//

import UIKit

class InfoViewController: UITableViewController {
    
    let materials: [Material] = [
        Material(
            title: "Paper",
            image: UIImage(named: "paper")!,
            content: "Paper, newspaper, cardboard, paperboard and magazines are good to recycle.\n\n\nFlatten and recycle all cardboard and paperboard by breaking down and flatten them to make room for more materials to fit in your recycling. Be sure to close the lid on your recycling container to keep materials dry!\n\n\n* If paper is soiled or wet, compost it."
        ),
        Material(
            title: "Plastic",
            image: UIImage(named: "plastic")!,
            content: "Recycle plastics like empty bottles, jars, jugs, and tubs by their shapes. Chasing arrows don’t necessarily indicate recyclability.\n\n\nCaps are recyclable, but you must put them back on empty containers before tossing in the bin!"
        ),
        Material(
            title: "Metal",
            image: UIImage(named: "metal")!,
            content: "Recycle plastics like empty bottles, jars, jugs, and tubs by their shapes. Chasing arrows don’t necessarily indicate recyclability.\n\n\nCaps are recyclable, but you must put them back on empty containers before tossing in the bin!"
        ),
        Material(
            title: "Glass",
            image: UIImage(named: "glass")!,
            content: "Glass should be cleaned and recycled in your household bin. Be sure to deposit the items carefully. Broken glass presents a hazard to sanitation workers and wildlife and should not be recycled. Metal bottle caps should be recycled separately from glass bottles."
        ),
        Material(
            title: "Trash",
            image: UIImage(named: "trash")!,
            content: "Deposit this kind of material into your household waste bin.\n\n\nBe aware that hazardous waste materials such as batteries, nail polish, and light bulbs may be dangerous to people and are bad for the environment. Hazardous waste products should never be flushed or poured down the drain.\n\n\nCheck with your local waste disposal agency and keep an eye out for community events that will allow you to dispose of this waste."
        ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Information"
        
        setNavBarAppearance()
        
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setNavBarAppearance()
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
    
    private func setNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.green
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 35)]
        appearance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        self.navigationController?.navigationBar.layoutIfNeeded()
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
    
    private func setUpButtonConfig(material: Material) -> UIButton.Configuration {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
        buttonConfig.background.backgroundColor = Colors.yellow
        buttonConfig.cornerStyle = .medium
        buttonConfig.imagePlacement = .leading
        buttonConfig.image = material.image
        
        let attributes = AttributeContainer(
            [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 40),
             NSAttributedString.Key.foregroundColor: Colors.green]
        )
        buttonConfig.attributedTitle = AttributedString(material.title, attributes: attributes)
        
        buttonConfig.imagePadding = 40
        return buttonConfig
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
