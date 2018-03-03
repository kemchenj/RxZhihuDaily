//
//  ViewController.swift
//  ZhihuDaily
//
//  Created by kemchenj on 09/02/2018.
//  Copyright © 2018 kemchenj. All rights reserved.
//

import UIKit
import RxDataSources
import NSObject_Rx
import MJRefresh

class NewsVC: UIViewController, BindableType {

    @IBOutlet weak var tableView: UITableView!
    let refreshHeader = MJRefreshNormalHeader(frame: .zero)
    let refreshFooter = MJRefreshAutoFooter(frame: .zero)

    var viewModel: NewsViewModel!

    func bindViewModel() {
        let sectionItems = viewModel.sectionItems
            .share(replay: 1, scope: .whileConnected)

        sectionItems
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        refreshHeader.refreshingBlock = { [weak self] in
            self?.viewModel.reload.onNext(())
        }

        refreshFooter.refreshingBlock = { [weak self] in
            self?.viewModel.loadMore.onNext(())
        }

        sectionItems
            .subscribe(onNext: { [weak self] _ in
                self?.refreshHeader.endRefreshing()
                self?.refreshFooter.endRefreshing()
            })
            .disposed(by: rx.disposeBag)
    }

    var dataSource: RxTableViewSectionedAnimatedDataSource<NewsSection> {
        let s = RxTableViewSectionedAnimatedDataSource<NewsSection>.init(
            configureCell: { (dataSource, tableView, idx, story) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Story") as! StoryCell
                cell.configure(with: story)
                return cell
            },
            titleForHeaderInSection: { (dataSource, idx) in
                return dataSource.sectionModels[idx].model
            }
        )
        return s
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 90
        tableView.estimatedRowHeight = 90
        tableView.mj_header = refreshHeader
        tableView.mj_footer = refreshFooter
    }
}
