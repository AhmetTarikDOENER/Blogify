//
//  BfySignOutViewController.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 26.10.2023.
//

import UIKit

class BfySignUpViewController: UITabBarController {

    private let headerView = BfySignInHeaderView()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Full Name"
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
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
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        
        return field
    }()
    
    private let signUpButton: UIButton = {
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
        title = "Create Account"
        view.backgroundColor = .systemBackground
        view.addSubviews(headerView, emailField, passwordField, signUpButton, nameField)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height / 4)
        nameField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width - 40, height: 50)
        emailField.frame = CGRect(x: 20, y: nameField.bottom + 10, width: view.width - 40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 10, width: view.width - 40, height: 50)
        signUpButton.frame = CGRect(x: 20, y: passwordField.bottom + 20, width: view.width - 40, height: 50)
    }
    
    @objc func didTapSignUp() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let name = nameField.text, !name.isEmpty else {
            return
        }
        
        BfyHapticsManager.shared.vibrateForSelection()
        
        BfyAuthManager.shared.signUp(email: email, password: password) {
            [weak self] success in
            if success {
                let newUser = BfyUser(name: name, email: email, profilePicReference: nil)
                BfyDatabaseManager.shared.insert(user: newUser) {
                    inserted in
                    guard inserted else {
                        return
                    }
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(name, forKey: "name")
                    
                    DispatchQueue.main.async {
                        let vc = BfyTabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true)
                    }
                }
            } else {
                print("Failed to create account.")
            }
        }
    }
}
