//
//  Story.swift
//  ZhihuDaily
//
//  Created by kemchenj on 10/02/2018.
//  Copyright © 2018 kemchenj. All rights reserved.
//

import struct Foundation.URL

struct Story: Codable {

    let id: Int
    let type: Int
    let shareUrl: URL

    let title: String
    let css: URL
    let body: String

    let image: URL
    let imageSource: String
    let images: [URL]
}
