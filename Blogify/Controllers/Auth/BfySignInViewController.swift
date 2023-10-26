//
//  BfySignInViewController.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 26.10.2023.
//

import UIKit

class BfySignInViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !BfyIAPManager.shared.isPremium() {
                let vc = BfyPaywallViewController()
                let navVC = UINavigationController(rootViewController: vc)
                self.present(navVC, animated: true)
            }
        }
    }

}
