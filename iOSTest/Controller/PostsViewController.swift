//
//  PostsViewController.swift
//  iOSTest
//
//  Created by Vivek Dhole on 29/05/24.
//

import UIKit

class PostsViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    
     private var viewModel = PostViewModel()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        bindViewModel()
        viewModel.fetchPosts()
    }
    
    private func bindViewModel() {
        viewModel.updatePosts = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.showError = { [weak self] error in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        let post = viewModel.post(at: indexPath.row)
        cell.postLabel?.text = "\(post.id): \(post.title)"
        
        // Perform heavy computation using the cache
        DispatchQueue.global().async {
            let startTime = Date()
            let details = ComputationCache.shared.getDetails(for: post)
            let endTime = Date()
            let timeInterval = endTime.timeIntervalSince(startTime)
            print("Heavy computation time for post \(post.id): \(timeInterval) seconds")
            
            DispatchQueue.main.async {
                // Ensure the cell is still displaying the same post before updating
                if let currentCell = tableView.cellForRow(at: indexPath), currentCell.textLabel?.text == "\(post.id): \(post.title)" {
                    currentCell.detailTextLabel?.text = details
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfPosts - 1 {
            viewModel.fetchPosts()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.post(at: indexPath.row)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                detailVC.post = post
                navigationController?.pushViewController(detailVC, animated: true)
            }
    }
}
