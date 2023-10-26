//
//  BfyPaywallHeaderView.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 26.10.2023.
//

import UIKit

class BfyPaywallHeaderView: UIView {
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "crown.fill"))
        imageView.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        imageView.tintColor = UIColor(cgColor: CGColor(red: 0.30, green: 0.325, blue: 0.407, alpha: 1))
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(headerImageView)
        backgroundColor = UIColor(cgColor: CGColor(red: 0.80, green: 0.878, blue: 1, alpha: 1))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImageView.frame = CGRect(x: (bounds.width - 110) / 2, y: (bounds.height - 110) / 2, width: 110, height: 110)
    }
    
}
