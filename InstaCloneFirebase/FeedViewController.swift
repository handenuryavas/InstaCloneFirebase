//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Hande Nur Yavaş on 17.05.2023.
//

import UIKit


class FeedViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
       
    }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10
        }
     
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
            cell.userEmailLabel.text = "user@email.com"
            cell.likeLabel.text = "0"
            cell.commentLabel.text = "comment"
            cell.userImageView.image = UIImage(named: "select.png")
            return cell
        }


}
