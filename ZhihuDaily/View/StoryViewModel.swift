//
//  StoryViewModel.swift
//  ZhihuDaily
//
//  Created by kemchenj on 15/02/2018.
//  Copyright © 2018 kemchenj. All rights reserved.
//

import Foundation

struct StoryViewModel {

    let coordinator: SceneCoordinator

    init(story: Story, coordinator: SceneCoordinator) {
        self.coordinator = coordinator
    }
}
