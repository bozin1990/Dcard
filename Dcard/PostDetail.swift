//
//  PostDetail.swift
//  Dcard
//
//  Created by 陳博軒 on 2020/2/5.
//  Copyright © 2020 Bozin. All rights reserved.
//

import Foundation

struct PostDetail: Codable {
    let title: String
    let createdAt: Date
    let content: String
    var commentCount: Int
    var likeCount: Int
    var media: [Media]
}

struct Media: Codable {
    var url: URL
    
}
