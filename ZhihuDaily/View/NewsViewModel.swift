//
//  StoryCellViewModel.swift
//  ZhihuDaily
//
//  Created by kemchenj on 14/02/2018.
//  Copyright © 2018 kemchenj. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias NewsSection = AnimatableSectionModel<String, Story>

var filename: String {
    return String(#file.split(separator: "/").last!)
}

struct NewsViewModel {

    let service: ZhihuService
    let coordinator: SceneCoordinator

    let bag = DisposeBag()

    init(zhihuService: ZhihuService, coordinator: SceneCoordinator) {
        self.service = zhihuService
        self.coordinator = coordinator

        let newsList = PublishSubject<[News]>()
        let isReloading = BehaviorRelay(value: false)

        loadMore
            .filter { !isReloading.value }
            .withLatestFrom(newsList)
            .filter { !$0.isEmpty }
            .debug(filename + " Load more", trimOutput: true)
            .flatMap { (newsList: [News]) -> Observable<[News]> in
                return zhihuService.rx
                    .stories(before: newsList.last!)
                    .map { newsList + [$0] }
            }
            .bind(to: newsList)
            .disposed(by: bag)

        reload
            .map { true }
            .debug(filename + " isReloading", trimOutput: true)
            .bind(to: isReloading)
            .disposed(by: bag)

        let reloadNews = reload
            .flatMap(zhihuService.rx.latestStories)
            .map { [$0] }
            .share(replay: 1, scope: .whileConnected)

        reloadNews
            .map { _ in false }
            .debug(filename + " isReloading", trimOutput: true)
            .bind(to: isReloading)
            .disposed(by: bag)

        reloadNews
            .bind(to: newsList)
            .disposed(by: bag)

        sectionItems = newsList
            .debug(filename + " News List", trimOutput: true)
            .asObservable()
            .map { $0.map {NewsSection(model: $0.date, items: $0.stories) } }
    }

    // input
    var reload = PublishSubject<Void>()
    var loadMore = PublishSubject<Void>()

    // output
    var sectionItems: Observable<[NewsSection]>
}
