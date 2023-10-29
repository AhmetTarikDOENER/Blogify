//
//  BfyProfileViewController.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 26.10.2023.
//

import UIKit

class BfyProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var user: BfyUser?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(BfyPostPreviewTableViewCell.self, forCellReuseIdentifier: BfyPostPreviewTableViewCell.identifier)
        
        return table
    }()
    
    let currentEmail: String
    
//    MARK: - Init
    
    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSignOutButton()
        setupTable()
        title = "Profile"
        fetchPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - Private
    
    private func setupTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupTableHeader()
        fetchProfileData()
    }
    
    private func setupTableHeader(profilePhotoRef: String? = nil, name: String? = nil) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width / 1.5))
        headerView.backgroundColor = .systemBlue
        headerView.isUserInteractionEnabled = true
        headerView.clipsToBounds = true
        tableView.tableHeaderView = headerView
        
        let profilePhoto = UIImageView(image: UIImage(systemName: "person.circle"))
        profilePhoto.tintColor = .white
        profilePhoto.contentMode = .scaleAspectFit
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.width / 2
        profilePhoto.isUserInteractionEnabled = true
        profilePhoto.frame = CGRect(
            x: (view.width - (view.width / 4)) / 2,
            y: (headerView.height - (view.width / 4)) / 2.5,
            width: view.width / 4,
            height: view.width / 4
        )
        headerView.addSubview(profilePhoto)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto))
        profilePhoto.addGestureRecognizer(tap)
        
        let emailLabel = UILabel(frame: CGRect(x: 20, y: profilePhoto.bottom + 10, width: view.width - 40, height: 100))
        headerView.addSubview(emailLabel)
        emailLabel.text = currentEmail
        emailLabel.textColor = .white
        emailLabel.textAlignment = .center
        emailLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        if let name = name {
            title = name
        }
        
        if let ref = profilePhotoRef {
            BfyStorageManager.shared.downloadURLForProfilePicture(path: ref) {
                url in
                guard let url = url else {
                    return
                }
                
                let task = URLSession.shared.dataTask(with: url) {
                    data, _, _ in
                    guard let data = data else { return }
                    
                    DispatchQueue.main.async {
                        profilePhoto.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
    }
    
    @objc private func didTapProfilePhoto() {
        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
                  myEmail == currentEmail else {
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func fetchProfileData() {
        BfyDatabaseManager.shared.getUser(email: currentEmail) {
            [weak self] user in
            guard let user = user else {
                return
            }
            
            self?.user = user
            
            DispatchQueue.main.async {
                self?.setupTableHeader(profilePhotoRef: user.profilePicReference, name: user.name)
            }
        }
    }
    
    private func setupSignOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(didTapSignOut))
    }
    
    /// Sign Out
    @objc private func didTapSignOut() {
        let sheet = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?🥹", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: {
            _ in
            BfyAuthManager.shared.signOut {
                [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "name")
                        let signInVC = BfySignInViewController()
                        signInVC.navigationItem.largeTitleDisplayMode = .always
                        
                        let navVC = UINavigationController(rootViewController: signInVC)
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true, completion: nil)
                    }
                }
            }
        }))
        present(sheet, animated: true)
    }
    
    //MARK: - TableView
    
    private var posts: [BfyBlogPost] = []
    
    private func fetchPosts() {
        BfyDatabaseManager.shared.getPosts(for: currentEmail) {
            [weak self] posts in
            self?.posts = posts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BfyPostPreviewTableViewCell.identifier,
            for: indexPath
        ) as? BfyPostPreviewTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(title: post.title, imageURL: post.headerImageURL))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var isOwnedByCurrentUser = false
        if let email = UserDefaults.standard.string(forKey: "email") {
            isOwnedByCurrentUser = email == currentEmail
        }
        
        if !isOwnedByCurrentUser {
            if BfyIAPManager.shared.canViewPost {
                let vc = BfyViewPostViewController(post: posts[indexPath.row], isOwnedByCurrentUser: isOwnedByCurrentUser)
                vc.navigationItem.largeTitleDisplayMode = .never
                vc.title = "Post"
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = BfyPaywallViewController()
                present(vc, animated: true)
            }
        } else {
            // Our post
            let vc = BfyViewPostViewController(post: posts[indexPath.row], isOwnedByCurrentUser: isOwnedByCurrentUser)
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = "Post"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension BfyProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        BfyStorageManager.shared.uploadUserProfilePicture(email: currentEmail, image: image) {
            [weak self] success in
            guard let strongSelf = self else { return }
            if success {
                BfyDatabaseManager.shared.updateProfilePhoto(email: strongSelf.currentEmail) {
                    updated in
                    guard updated else { return }
                    DispatchQueue.main.async {
                        strongSelf.fetchProfileData()
                    }
                }
            }
        }
    }
}
