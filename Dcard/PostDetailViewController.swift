//
//  PostDetailViewController.swift
//  Dcard
//
//  Created by 陳博軒 on 2020/2/5.
//  Copyright © 2020 Bozin. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var likeCountImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var forumNameLabel: UILabel!
    
    var post: Post!
    var postDetail: PostDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        loadData()
        title = post.title
        titleLabel.text = post.title
        commentCountLabel.text = "\(post.commentCount)"
        likeCountLabel.text = "\(post.likeCount)"
        forumNameLabel.text = post.forumName
        if post.likeCount != 0 {
            likeCountImageView.tintColor = UIColor.systemRed
        } else {
            likeCountImageView.tintColor = UIColor.opaqueSeparator
        }
       
    }
        
    func loadData() {
        if let url = URL(string: "https://dcard.tw/_api/posts/\(post.id)") {
            
            print(post.id)
             
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                let formatter = ISO8601DateFormatter()
//                解析T 跟 Z
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let data = try decoder.singleValueContainer().decode(String.self)
//                    回傳接到的時間否則回傳目前時間
                    return formatter.date(from: data) ?? Date()
                })
                if let data = data, let postDetail = try? decoder.decode(PostDetail.self, from: data) {
                    self.postDetail = postDetail
                   

                   let contentArray = postDetail.content.split(separator: "\n").map(String.init)
                  let mutableAttributedString = NSMutableAttributedString()
                  contentArray.forEach {row in
                      
                      if row.contains("http") {
                          mutableAttributedString.append(imageFrom: row, textView: self.contentTextView)
                      } else {
                          mutableAttributedString.append(string: row)
                      }
                  }
                  DispatchQueue.main.async {
                      self.contentTextView.attributedText = mutableAttributedString
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd hh:mm"
                    let timeText = formatter.string(from: postDetail.createdAt)
                    self.createdLabel.text = timeText
                  }

                }
            }.resume()
         }
    }
    
        // Do any additional setup after loading the view.
}

extension NSMutableAttributedString {
    func append(string: String) {
//        調整textView上字體大小
        self.append(NSAttributedString(string: string + "\n", attributes: [.font: UIFont.systemFont(ofSize: 16)]))
    }
    
    func append(imageFrom: String, textView: UITextView) {
        guard let url = URL(string: imageFrom) else { return }
             UIImage.image(from: url) { (image) in
            guard let image = image else { return }
               
//            設定螢幕寬度的0.8 長寬比不變
            let scaledImg = image.scaled(with: UIScreen.main.bounds.width / image.size.width * 0.8)
            let attachment = NSTextAttachment()
            attachment.image = scaledImg
            self.append(NSAttributedString(attachment: attachment))
            self.append(NSAttributedString(string: "\n"))
        }
        
    }
}

extension UIImage {
    static func image(from url: URL, handel: @escaping (UIImage?) -> ()) {
            
          guard let data = try? Data(contentsOf: url), let image =
              UIImage(data: data) else {
              handel(nil)
              return
            
          }
          handel(image)
      
    }
    
    func scaled(with scale: CGFloat) -> UIImage? {
        let size = CGSize(width: floor(self.size.width * scale), height: floor(self.size.height * scale))
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
