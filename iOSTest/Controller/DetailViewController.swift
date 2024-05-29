//
//  DetailViewController.swift
//  iOSTest
//
//  Created by Vivek Dhole on 29/05/24.
//

import UIKit

class DetailViewController: UIViewController {
    var post: Post?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
   override func viewDidLoad() {
        super.viewDidLoad()
        displayPostDetails()
    }
    
    private func displayPostDetails() {
        guard let post = post else { return }
        titleLabel.text = post.title
        bodyLabel.text = post.body
    }
}
