//
//  PostViewModel.swift
//  iOSTest
//
//  Created by Vivek Dhole on 29/05/24.
//

import Foundation

class PostViewModel {
    private var posts: [Post] = []
    private var currentPage = 1
    private var isFetching = false
    var updatePosts: (() -> Void)?
    var showError: ((String) -> Void)?
    
    var numberOfPosts: Int {
        return posts.count
    }
    
    func post(at index: Int) -> Post {
        return posts[index]
    }
    
    func fetchPosts() {
        guard !isFetching else { return }
        isFetching = true
        APIService.shared.fetchPosts(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            switch result {
            case .success(let newPosts):
                self.posts.append(contentsOf: newPosts)
                self.currentPage += 1
                self.updatePosts?()
            case .failure(let error):
                self.showError?(error.localizedDescription)
            }
        }
    }
}
