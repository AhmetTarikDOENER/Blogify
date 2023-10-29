//
//  ViewController.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 26.10.2023.
//

import UIKit

class BfyHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let composeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setImage(
            UIImage(
                systemName: "square.and.pencil",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
            ),
            for: .normal
        )
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.45
        button.layer.shadowRadius = 10
        
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(BfyPostPreviewTableViewCell.self, forCellReuseIdentifier: BfyPostPreviewTableViewCell.identifier)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(composeButton, tableView)
        composeButton.addTarget(self, action: #selector(didTapCreatePost), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        composeButton.frame = CGRect(x: view.frame.width - 88, y: view.frame.height - 88 - view.safeAreaInsets.bottom, width: 60, height: 60)
        tableView.frame = view.bounds
    }
    
    @objc private func didTapCreatePost() {
        let vc = BfyCreateNewPostViewController()
        vc.title = "Create Post"
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private var posts: [BfyBlogPost] = []
    
    private func fetchAllPosts() {
        BfyDatabaseManager.shared.getAllPosts {
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
        
        guard BfyIAPManager.shared.canViewPost else {
            let vc = BfyPaywallViewController()
            present(vc, animated: true)
            return
        }
        
        let vc = BfyViewPostViewController(post: posts[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
    }

}

