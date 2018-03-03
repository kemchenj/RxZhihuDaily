//
//  BindableType.swift
//  ZhihuDaily
//
//  Created by kemchenj on 15/02/2018.
//  Copyright © 2018 kemchenj. All rights reserved.
//

import Foundation
import RxSwift

protocol BindableType {
    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }

    func bindViewModel()
}

extension BindableType where Self: UIViewController {

    mutating func bindViewModel(to model: ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
