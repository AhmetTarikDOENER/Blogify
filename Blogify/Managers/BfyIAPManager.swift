//
//  BfyIAPManager.swift
//  Blogify
//
//  Created by Ahmet Tarik DÖNER on 26.10.2023.
//

import Foundation
import RevenueCat
import StoreKit

final class BfyIAPManager {
    
    static let shared = BfyIAPManager()
    
    static let formatter = ISO8601DateFormatter()
    
    private var postEligibleViewDate: Date? {
        get {
            guard let string = UserDefaults.standard.string(forKey: "postEligibleViewDate") else {
                return nil
            }
            return BfyIAPManager.formatter.date(from: string)
        } set {
            guard let date = newValue else { return }
            let string = BfyIAPManager.formatter.string(from: date)
            UserDefaults.standard.set(string, forKey: "postEligibleViewDate")
        }
    }
    
    private init() {}
    
    //MARK: - Public
    
    func isPremium() -> Bool {
        return UserDefaults.standard.bool(forKey: "premium")
    }
        
    public func getSubscriptionStatus(completion: ((Bool) -> Void)?) {
        Purchases.shared.getCustomerInfo {
            customerInfo, error in
            guard let entitlements = customerInfo?.entitlements,
                  error == nil else {
                return
            }
            if entitlements.all["Premium"]?.isActive == true {
                print("Got updated status of subscribed.")
                UserDefaults.standard.set(true, forKey: "premium")
                completion?(true)
            } else {
                print("Got updated status of NOT subscribed.")
                UserDefaults.standard.set(false, forKey: "premium")
                completion?(false)
            }
        }
    }
    
    public func fetchPackages(completion: @escaping (RevenueCat.Package?) -> Void) {
        Purchases.shared.getOfferings {
            offerings, error in
            guard let package = offerings?.offering(identifier: "default")?.availablePackages.first,
                  error == nil else {
                completion(nil)
                return
            }
            completion(package)
        }
    }
    
    public func subscribe(package: RevenueCat.Package, completion: @escaping (Bool) -> Void) {
        guard !isPremium() else {
            completion(true)
            print(String(describing: "User is already subscribed."))
            return
        }
        
        Purchases.shared.purchase(package: package) {
            transaction, info, error, userCancelled in
            guard let transaction = transaction as? SK1Transaction,
                  let entitlements = info?.entitlements,
                  error == nil,
                  !userCancelled else {
                return
            }
            switch transaction.transactionState {
            case .purchasing:
                print("purchasing")
            case .purchased:
                if entitlements.all["Premium"]?.isActive == true {
                    print("Purchased!")
                    UserDefaults.standard.set(true, forKey: "premium")
                    completion(true)
                } else {
                    print("Purchased failed.")
                    UserDefaults.standard.set(false, forKey: "premium")
                    completion(false)
                }
            case .failed:
                print("failed")
            case .restored:
                print("restored")
            case .deferred:
                print("deferred")
            @unknown default:
                print("default case")
            }
        }
    }
    
    public func restorePurchases(completion: @escaping (Bool) -> Void) {
        Purchases.shared.restorePurchases {
            info, error in
            guard let entitlements = info?.entitlements,
                  error == nil else {
                return
            }
            
            if entitlements.all["Premium"]?.isActive == true {
                print("Restored success")
                UserDefaults.standard.set(true, forKey: "premium")
                completion(true)
            } else {
                print("Restored failure.")
                UserDefaults.standard.set(false, forKey: "premium")
                completion(false)
            }
        }
    }
    
}

//MARK: - Track Post Views

extension BfyIAPManager {
    var canViewPost: Bool {
        if isPremium() {
            return true
        }
        
        guard let date = postEligibleViewDate else {
            return true
        }
        
        UserDefaults.standard.set(0, forKey: "post_views")
        return Date() >= date
    }
    
    public func logPostViewed() {
        let total = UserDefaults.standard.integer(forKey: "post_views")
        UserDefaults.standard.set(total + 1, forKey: "post_views")
    
        if total == 2 {
            let hour: TimeInterval = 60 * 60
            postEligibleViewDate = Date().addingTimeInterval(hour * 24)
        }
    }
    
}
