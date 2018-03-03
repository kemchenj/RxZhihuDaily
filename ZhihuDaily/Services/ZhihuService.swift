//
//  ZhihuService.swift
//  ZhihuDaily
//
//  Created by kemchenj on 10/02/2018.
//  Copyright © 2018 kemchenj. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ZhihuServiceType {

    var baseUrl: URL { get }
}

protocol RxZhihuServiceType {

    func latestStories() -> Observable<News>
    func stories(before date: String) -> Observable<News>
    func storyDetail(id: Int) -> Observable<Story>
}

class ZhihuService: ZhihuServiceType, ReactiveCompatible {

    let baseUrl = URL(string: "https://news-at.zhihu.com/api")!
}

extension Reactive: RxZhihuServiceType where Base: ZhihuServiceType {

    private func request<T: Codable>(endpoint: String) -> Observable<T> {
        return Observable.just(endpoint)
            .map { self.base.baseUrl.appendingPathComponent($0) }
            .map { URLRequest(url: $0) }
            .flatMap { URLSession.shared.rx.data(request: $0) }
            .map { data in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            }
    }

    func latestStories() -> Observable<News> {
        return request(endpoint: "/4/news/latest")
    }

    func stories(before date: String) -> Observable<News> {
        return request(endpoint: "/4/news/before/\(date)")
    }

    func stories(before news: News) -> Observable<News> {
        return stories(before: news.date)
    }

    func storyDetail(id: Int) -> Observable<Story> {
        return request(endpoint: "/4/news/\(id)")
    }
}
