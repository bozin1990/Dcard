//
//  Post.swift
//  Dcard
//
//  Created by 陳博軒 on 2020/2/3.
//  Copyright © 2020 Bozin. All rights reserved.
//

import Foundation


struct Post: Codable {
    let id: Int
    let title: String
    let excerpt: String
    let commentCount: Int
    let likeCount: Int
    let forumName: String
    let gender: String
    var school: String?
    var mediaMeta: [MediaMeta]
    

}

struct MediaMeta: Codable {
    var url: URL
    
    
    
}
