//
//  BfySignInViewController.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 26.10.2023.
//

import UIKit

class BfySignInViewController: UITabBarController {

    private let headerView = BfySignInHeaderView()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Email Adress"
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        
        return field
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.layer.borderColor = .init(red: 0.30, green: 0.325, blue: 0.407, alpha: 1)
        button.backgroundColor = UIColor(cgColor: CGColor(red: 0.80, green: 0.878, blue: 1, alpha: 1))
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(UIColor(cgColor: CGColor(red: 0.30, green: 0.325, blue: 0.407, alpha: 1)), for: .normal)
        
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.layer.borderColor = .init(red: 0.30, green: 0.325, blue: 0.407, alpha: 1)
        button.backgroundColor = UIColor(cgColor: CGColor(red: 0.80, green: 0.878, blue: 1, alpha: 1))
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(UIColor(cgColor: CGColor(red: 0.30, green: 0.325, blue: 0.407, alpha: 1)), for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubviews(headerView, emailField, passwordField, signInButton, createAccountButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height / 4)
        emailField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width - 40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 10, width: view.width - 40, height: 50)
        signInButton.frame = CGRect(x: 20, y: passwordField.bottom + 20, width: view.width - 40, height: 50)
        createAccountButton.frame = CGRect(x: 20, y: signInButton.bottom + 40, width: view.width - 40, height: 50)
    }
    
    @objc func didTapSignIn() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            return
        }
        
        BfyHapticsManager.shared.vibrateForSelection()
        
        BfyAuthManager.shared.signIn(email: email, password: password) {
            [weak self] success in
            guard success else {
                return
            }
            // Update subs status for newly signed in user
            BfyIAPManager.shared.getSubscriptionStatus(completion: nil)
            
            DispatchQueue.main.async {
                UserDefaults.standard.set(email, forKey: "email")
                let vc = BfyTabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }
        }
    }
    
    @objc func didTapCreateAccount() {
        let vc = BfySignUpViewController()
        vc.title = "Create Account"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
