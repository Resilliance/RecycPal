//
//  MoreInfoViewController.swift
//  RecycPal
//
//  Created by Denielle Abaquita on 1/16/22.
//

import UIKit

class MoreInfoViewController: UIViewController {
    
    var material: Material?
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = Colors.yellow
        return scrollView
    }()
    
    private var parentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .top
        stackView.spacing = 33
        return stackView
    }()
    
    private var horizStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 30
        return stackView
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.green
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    private var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.green
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 23)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.green
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 35)]
        appearance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        view.backgroundColor = Colors.green
        
        // Set up subviews
        scrollView.layer.cornerRadius = 10
        scrollView.layer.masksToBounds = true
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25)
        ])
        
        // Layout scrollview subviews
        scrollView.addSubview(parentStackView)
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            parentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25),
            parentStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            parentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            parentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -25)
        ])
        
        imageView.image = material?.image
        horizStackView.addArrangedSubview(imageView)
        titleLabel.text = material?.title
        horizStackView.addArrangedSubview(titleLabel)
        parentStackView.addArrangedSubview(horizStackView)
        
        contentLabel.text = material?.content
        parentStackView.addArrangedSubview(contentLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentLabel.sizeToFit()
    }
}
