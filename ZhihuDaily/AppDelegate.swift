//
//  AppDelegate.swift
//  ZhihuDaily
//
//  Created by kemchenj on 09/02/2018.
//  Copyright © 2018 kemchenj. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let service = ZhihuService()
        let sceneCoordinator = SceneCoordinator(window: window!)

        let newsVM = NewsViewModel(zhihuService: service, coordinator: sceneCoordinator)
        let firstScene = Scene.news(newsVM)
        sceneCoordinator.transition(to: firstScene, type: .root)

        return true
    }
}
