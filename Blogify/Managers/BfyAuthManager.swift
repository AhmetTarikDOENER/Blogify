//
//  BfyAuthManager.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 26.10.2023.
//

import Foundation
import FirebaseAuth

final class BfyAuthManager {
    
    static let shared = BfyAuthManager()
    private let auth = Auth.auth()
    private init() {}
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    public func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            return
        }
        
        auth.signIn(withEmail: email, password: password) {
            result, error in
            guard result != nil, error != nil else {
                completion(false)
                return
            }
            completion(true)
        }
        
        auth.createUser(withEmail: email, password: password) {
            result, error in
            guard result != nil, error != nil else {
                completion(false)
                return
            }
            // Account created
            completion(true)
        }
    }
    
    public func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func signOut(completion: (Bool) -> Void) {
        do {
            try auth.signOut()
        } catch {
            print(error)
            completion(false)
        }
    }
    
}
