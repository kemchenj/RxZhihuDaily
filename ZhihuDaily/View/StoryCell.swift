//
//  StoryCell.swift
//  ZhihuDaily
//
//  Created by kemchenj on 14/02/2018.
//  Copyright © 2018 kemchenj. All rights reserved.
//

import UIKit
import RxCocoa
import Kingfisher

final class StoryCell: UITableViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func configure(with story: Story) {
        bannerImageView.kf.setImage(with: story.images.first)
        titleLabel.text = story.title
    }
}
