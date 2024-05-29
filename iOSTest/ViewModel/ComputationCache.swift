//
//  ComputationCache.swift
//  iOSTest
//
//  Created by Vivek Dhole on 29/05/24.
//
import UIKit
import Foundation
class ComputationCache {
    static let shared = ComputationCache()
    private var cache = [Int: String]()
    private let queue = DispatchQueue(label: "com.example.ComputationCacheQueue")
    
    func getDetails(for post: Post) -> String {
        return queue.sync {
            if let details = cache[post.id] {
                return details
            }
            
            let details = performHeavyComputation(for: post)
            cache[post.id] = details
            return details
        }
    }
    
    private func performHeavyComputation(for post: Post) -> String {
        // Simulate a heavy computation process by blocking the current thread
        sleep(2)
        return "Details for post \(post.id)"
    }
}
