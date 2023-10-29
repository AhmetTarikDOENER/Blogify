//
//  BfyPostPreviewTableViewCell.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 30.10.2023.
//

import UIKit

class BfyPostPreviewTableViewCellViewModel {
    let title: String
    let imageURL: URL?
    var imageData: Data?
    
    init(title: String, imageURL: URL?, imageData: Data? = nil) {
        self.title = title
        self.imageURL = imageURL
        self.imageData = imageData
    }
}

class BfyPostPreviewTableViewCell: UITableViewCell {
    
    static let identifier = "BfyPostPreviewTableViewCell"
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        
        return imageView
    }()
    
    private let postTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubviews(postImageView, postTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = CGRect(x: separatorInset.left, y: 5, width:  contentView.height - 10, height: contentView.height - 10)
        postImageView.frame = CGRect(
            x: postImageView.right + 5,
            y: 5,
            width: contentView.width - 5 - separatorInset.left - postImageView.width,
            height: contentView.height - 10
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postTitleLabel.text = nil
        postImageView.image = nil
    }
    
    func configure(with viewModel: BfyPostPreviewTableViewCellViewModel) {
        postTitleLabel.text = viewModel.title
        
        if let data = viewModel.imageData {
            postImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            let task = URLSession.shared.dataTask(with: url) {
                [weak self] data, _, _ in
                guard let data = data else {
                    return
                }
                
                viewModel.imageData = data
                
                DispatchQueue.main.async {
                    self?.postImageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
    
}
