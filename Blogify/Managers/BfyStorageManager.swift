//
//  BfyStorageManager.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 26.10.2023.
//

import UIKit
import FirebaseStorage

final class BfyStorageManager {
    
    static let shared = BfyStorageManager()
    private let container = Storage.storage().reference()
    private init() {}
    
    public func uploadUserProfilePicture(email: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func downloadURLForProfilePicture(user: BfyUser, completion: @escaping (URL?) -> Void) {
        
    }
    
    public func uploadBlogHeaderImage(blogPost: BfyBlogPost, image: UIImage?, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func downloadURLForPostHeader(blogPost: BfyBlogPost, completion: @escaping (URL?) -> Void) {
        
    }
    
}
