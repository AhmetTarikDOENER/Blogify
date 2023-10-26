//
//  BfyPaywallViewController.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 26.10.2023.
//

import UIKit

class BfyPaywallViewController: UIViewController {
    
    private let headerView = BfyPaywallHeaderView()
    private let heroView = BfyPaywallDescriptionView()
    
    private let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Subscribe", for: .normal)
        button.backgroundColor = UIColor(cgColor: CGColor(red: 0.30, green: 0.325, blue: 0.407, alpha: 1))
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let restoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Restore Purchases", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let termsView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.textAlignment = .center
        textView.textColor = .secondaryLabel
        textView.font = .systemFont(ofSize: 14)
        textView.text = "This is an auto-renewable Subscription. It will be charged to your iTunes account before each pay period.\nYou can cancel anytime by going under into your Settings > Subscriptions. Restore purchases if previously subscribed."
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Blogify Premium"
        view.addSubviews(headerView, buyButton, restoreButton, termsView, heroView)
        setupCloseButton()
        setupButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height / 3.2)
        termsView.frame = CGRect(x: 10, y: view.height - 100, width: view.width - 20, height: 100)
        
        restoreButton.frame = CGRect(x: 25, y: termsView.top - 70, width: view.width - 50, height: 50)
        buyButton.frame = CGRect(x: 25, y: restoreButton.top - 60, width: view.width - 50, height: 50)
        
        heroView.frame = CGRect(x: 0, y: headerView.bottom, width: view.width, height: buyButton.top - view.safeAreaInsets.top - headerView.height)
    }
    
    private func setupButtons() {
        buyButton.addTarget(self, action: #selector(didTapSubcribe), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(didTapRestore), for: .touchUpInside)
    }
    
    @objc private func didTapSubcribe() {
        
    }
    
    @objc private func didTapRestore() {
        
    }
    
    private func setupCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
}
