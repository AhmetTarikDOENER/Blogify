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
    
    // TODO: Add user to the database, Query all blogposts, Query all blogposts for a particular user, Post blogpost
    public func insert(blogPost: BfyBlogPost, user: BfyUser, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func getAllPosts(completion: @escaping ([BfyBlogPost]) -> Void) {
        
    }
    
    public func getPosts(for user: BfyUser, completion: @escaping ([BfyBlogPost]) -> Void) {
        
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
    
}
