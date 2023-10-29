//
//  BfyDatabaseManager.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 26.10.2023.
//

import Foundation
import FirebaseFirestore

final class BfyDatabaseManager {
    
    static let shared = BfyDatabaseManager()
    private let database = Firestore.firestore()
    private init() {}
    
    public func insert(blogPost: BfyBlogPost, email: String, completion: @escaping (Bool) -> Void) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data: [String : Any] = [
            "id": blogPost.identifier,
            "title": blogPost.title,
            "body": blogPost.text,
            "created": blogPost.timestamp,
            "headerImageURL": blogPost.headerImageURL?.absoluteString ?? ""
        ]
        
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .document(blogPost.identifier)
            .setData(data) {
                error in
                completion(error == nil)
            }
    }
    
    public func getAllPosts(completion: @escaping ([BfyBlogPost]) -> Void) {
        
    }
    
    public func getPosts(for email: String, completion: @escaping ([BfyBlogPost]) -> Void) {
        let userEmail = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .getDocuments {
                snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0.data() }), error == nil else {
                    return
                }
                
                let posts: [BfyBlogPost] = documents.compactMap {
                    dictionary in
                    guard let id = dictionary["id"] as? String,
                          let title = dictionary["title"] as? String,
                          let body = dictionary["body"] as? String,
                          let created = dictionary["created"] as? TimeInterval,
                          let imageURLString = dictionary["headerImageURL"] as? String else {
                        print("Invalid post fetch convertion.")
                        return nil
                    }
                
                    let post = BfyBlogPost(
                        identifier: id,
                        title: title,
                        timestamp: created,
                        headerImageURL: URL(string: imageURLString),
                        text: body
                    )
                    return post
                }
                completion(posts)
            }
    }
    
    public func insert (user: BfyUser, completion: @escaping (Bool) -> Void) {
        let documentId = user.email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data = [
            "email": user.email,
            "name": user.name
        ]
        
        database
            .collection("users")
            .document(documentId)
            .setData(data) {
                error in
                completion(error == nil)
            }
    }
    
    public func getUser(email: String, completion: @escaping (BfyUser?) -> Void) {
        let documentId = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        database
            .collection("users")
            .document(documentId)
            .getDocument {
                snapshot, error in
                guard let data = snapshot?.data() as? [String : String],
                      let name = data["name"],
                        error == nil else {
                    return
                }
                
                let ref = data["profile_photo"]
                let user = BfyUser(name: name, email: email, profilePicReference: ref)
                completion(user)
            }
        
    }
    
    func updateProfilePhoto(email: String, completion: @escaping (Bool) -> Void) {
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        let photoReference = "profile_pictures/\(path)/photo.png"
        
        let dbReference = database
            .collection("users")
            .document(path)
        
        dbReference.getDocument {
            snapshot, error in
            guard var data = snapshot?.data(), error == nil else {
                return
            }
            data["profile_photo"] = photoReference
            
            dbReference.setData(data) {
                error in
                completion(error == nil)
            }
        }
    }
    
}
