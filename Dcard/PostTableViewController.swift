//
//  PostTableViewController.swift
//  Dcard
//
//  Created by 陳博軒 on 2020/2/3.
//  Copyright © 2020 Bozin. All rights reserved.
//

import UIKit

class PostTableViewController: UITableViewController {
    
    var posts = [Post]()
//    宣吿一個類型為 UIRefreshControl 的變數,啟動更新 TableView
    var refresh = UIRefreshControl()

//    在 viewDidLoad初始化，add到TableView上
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

        tableView.addSubview(refresh)
//        將loadData方法加到refresh
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
    }

    // MARK: - Table view data source

    @objc func loadData() {
//        用一個延遲讀取的方法,來模擬網路延遲效果,這邊設定延遲1秒
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            停止讀取動畫
            self.refresh.endRefreshing()
        
         let urlStr = "https://dcard.tw/_api/posts"
           if let url = URL(string: urlStr) {
               URLSession.shared.dataTask(with: url) { (data, response, error) in
                   let decoder = JSONDecoder()
                   if let data = data {
                    do {
                        let posts = try decoder.decode([Post].self, from: data)
                           self.posts = posts
                            DispatchQueue.main.async {
                              self.tableView.reloadData()
                          }
                        
                       } catch  {
                           print(error)
                       }
                       
                   }
                   
               }.resume()
           }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        // Configure the cell...
        let post = posts[indexPath.row]
        
        if post.school == nil {
            cell.schoolLabel.text = "匿名"
        } else {
            cell.schoolLabel.text = post.school
        }
        
        if post.likeCount != 0 {
            cell.likeCountImage.tintColor = UIColor.systemRed
        } else {
            cell.likeCountImage.tintColor = UIColor.opaqueSeparator
        }
        
        if post.gender == "M" {
            cell.genderImage.image = UIImage(named: "man")
            cell.genderImage.tintColor = UIColor.systemBlue
    
        } else if post.gender == "F" {
            cell.genderImage.image = UIImage(named: "woman")
            cell.genderImage.tintColor = UIColor.systemPink

        }
        cell.likeCountLabel.text = "\(post.likeCount)"
        cell.forumNameLabel.text = post.forumName
        cell.titleLabel.text = post.title
        cell.excerptLabel.text = post.excerpt
        cell.commentCountLabel.text = "\(post.commentCount)"
        if post.mediaMeta.count != 0 {
            let imageUrl = post.mediaMeta[0].url
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.postImage.isHidden = false
                        cell.postImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        } else {
            cell.postImage.isHidden = true
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = tableView.indexPathForSelectedRow?.row, let controller = segue.destination as? PostDetailViewController {
            let post = posts[row]
            controller.post = post
        }
        
    }
    

}
