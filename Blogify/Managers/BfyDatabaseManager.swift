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
        
    }
    
}
