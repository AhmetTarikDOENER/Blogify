//
//  BfyPaywallDescriptionView.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 26.10.2023.
//

import UIKit

class BfyPaywallDescriptionView: UIView {

    private let descriptorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.numberOfLines = 0
        label.text = "Join blogify premium to read unlimited post and articles!Browse thousands of posts."
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 1
        label.text = "$4.99 / month"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubviews(priceLabel, descriptorLabel)
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptorLabel.frame = CGRect(x: 20, y: 0, width: width - 40, height: height / 2)
        priceLabel.frame = CGRect(x: 20, y: height / 2, width: width - 40, height: height / 2)
    }
    
}
