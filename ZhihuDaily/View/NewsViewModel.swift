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
import Action

typealias NewsSection = AnimatableSectionModel<String, Story>

var filename: String {
    return String(#file.split(separator: "/").last!)
}

extension AnimatableSectionModel where Section == String, ItemType == Story {

    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"

        guard let date = dateFormatter.date(from: model) else { return "" }

        let cal = Calendar(identifier: .gregorian)
        let month = cal.component(.month, from: date)
        let day = cal.component(.day, from: date)
        let weekday = cal.component(.weekday, from: date)

        var weekdayInChinese: String {
            switch weekday {
            case 1: return "一"
            case 2: return "二"
            case 3: return "三"
            case 4: return "四"
            case 5: return "五"
            case 6: return "六"
            case 7: return "日"
            default: return ""
            }
        }

        return String(format: "%02d月\(day)日 星期\(weekdayInChinese)", month)

    }
}

struct NewsViewModel {

    private let service: ZhihuService
    private let coordinator: SceneCoordinator
    private let bag = DisposeBag()

    // input
    let reload: PublishSubject<Void>
    let loadMore = PublishSubject<Void>()

    // output
    let sectionItems: Observable<[NewsSection]>

    func didSelectStory(_ story: Story) -> Observable<Never> {
        let vm = StoryViewModel(story: story, coordinator: coordinator)

        return coordinator
            .transition(to: .story(vm), type: .push)
            .asObservable()
    }

    init(zhihuService: ZhihuService, coordinator: SceneCoordinator) {
        self.service = zhihuService
        self.coordinator = coordinator

        let newsList = PublishSubject<[News]>()
        let isReloading = BehaviorRelay(value: false)
        let reload = PublishSubject<Void>()

        self.reload = reload

        let initialLoading = zhihuService.rx
            .latestStories()
            .debug(filename + " Initial Loading", trimOutput: true)
            .map { [$0] }

        let after = newsList
            .debug(filename + " News List", trimOutput: true)
            .retry(2)
            .asObservable()

        let news = Observable.of(initialLoading, after).merge().share(replay: 1, scope: .whileConnected)

        sectionItems = news
            .map { $0.map { NewsSection(model: $0.date, items: $0.stories) } }

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

        reload
            .map { true }
            .debug(filename + " isReloading", trimOutput: true)
            .bind(to: isReloading)
            .disposed(by: bag)

        loadMore
            .filter { !isReloading.value }
            .withLatestFrom(news)
            .filter { !$0.isEmpty }
            .debug(filename + " Load More", trimOutput: true)
            .flatMap { (newsList: [News]) -> Observable<[News]> in
                return zhihuService.rx
                    .stories(before: newsList.last!)
                    .map { newsList + [$0] }
                    .takeUntil(reload)
            }
            .bind(to: newsList)
            .disposed(by: bag)
    }


}
