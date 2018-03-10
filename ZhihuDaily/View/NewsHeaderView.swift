//
//  NewsHeaderView.swift
//  ZhihuDaily
//
//  Created by kemchenj on 04/03/2018.
//  Copyright © 2018 kemchenj. All rights reserved.
//

import UIKit

class NewsHeaderView: UITableViewHeaderFooterView {

    let label = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor(red: 56/255, green: 179/255, blue: 245/255, alpha: 1)

        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        label.frame = bounds
    }
}
