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
    private let container = Storage.storage()
    private init() {}
    
    public func uploadUserProfilePicture(email: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        guard let pngData = image?.pngData() else {
            return
        }
        
        container
            .reference(withPath: "profile_pictures/\(path)/photo.png")
            .putData(pngData, metadata: nil) {
                metadata, error in
                guard metadata != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    public func downloadURLForProfilePicture(path: String, completion: @escaping (URL?) -> Void) {
        container.reference(withPath: path)
            .downloadURL {
                url, _ in
                completion(url)
            }
    }
    
    public func uploadBlogHeaderImage(blogPost: BfyBlogPost, image: UIImage?, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func downloadURLForPostHeader(blogPost: BfyBlogPost, completion: @escaping (URL?) -> Void) {
        
    }
    
}
