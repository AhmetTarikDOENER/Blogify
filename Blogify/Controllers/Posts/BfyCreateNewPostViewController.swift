//
//  BfyCreateNewPostViewController.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 26.10.2023.
//

import UIKit

class BfyCreateNewPostViewController: UITabBarController {
    
    private let titleField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Enter Title..."
        field.autocapitalizationType = .words
        field.autocorrectionType = .yes
        field.backgroundColor = .secondarySystemBackground
        field.layer.masksToBounds = true
        
        return field
    }()
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "photo")
        imageView.backgroundColor = .tertiarySystemBackground
        
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 28)
        textView.backgroundColor = .tertiarySystemBackground
        
        return textView
    }()
    
    private var selectedHeaderImage: UIImage?
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(textView, headerImageView, titleField)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        headerImageView.addGestureRecognizer(tap)
        configureButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleField.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.width - 20, height: 50)
        headerImageView.frame = CGRect(x: 0, y: titleField.bottom + 5, width: view.width, height: 160)
        textView.frame = CGRect(x: 10, y: headerImageView.bottom + 10, width: view.width - 20, height: view.height - 210 - view.safeAreaInsets.top)
    }
    
    //MARK: - Private
    
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
    }
    
    @objc private func didTapHeader() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc private func didTapPost() {
        guard let title = titleField.text,
              let body = textView.text,
              let headerImage = selectedHeaderImage,
              let email = UserDefaults.standard.string(forKey: "email"),
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let newPostId = UUID().uuidString
        BfyStorageManager.shared.uploadBlogHeaderImage(email: email, image: headerImage, postId: newPostId) {
            success in
            guard success else { return }
            BfyStorageManager.shared.downloadURLForPostHeader(email: email, postId: newPostId) {
                url in
                guard let headerUrl = url else { return }
                let post = BfyBlogPost(identifier: newPostId, title: title, timestamp: Date().timeIntervalSince1970, headerImageURL: headerUrl, text: body)
            }
        }
    }
}

extension BfyCreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        selectedHeaderImage = image
        headerImageView.image = image
    }
}
