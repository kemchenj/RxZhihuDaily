//
//  News.swift
//  ZhihuDaily
//
//  Created by kemchenj on 10/02/2018.
//  Copyright © 2018 kemchenj. All rights reserved.
//

import RxDataSources

struct News: Codable {

    let date: String
    let stories: [Story]
}

extension News: IdentifiableType {
    
    var identity: String {
        return date
    }
}

extension News: Equatable {

    var hashValue: Int {
        return date.hashValue
    }

    static func ==(lhs: News, rhs: News) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
