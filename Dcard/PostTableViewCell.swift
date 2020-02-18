//
//  PostTableViewCell.swift
//  Dcard
//
//  Created by 陳博軒 on 2020/2/3.
//  Copyright © 2020 Bozin. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var likeCountImage: UIImageView!
    @IBOutlet weak var excerptLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var forumNameLabel: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
