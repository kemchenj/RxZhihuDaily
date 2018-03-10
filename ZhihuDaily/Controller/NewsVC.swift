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

        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)

        sectionItems
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        tableView.rx.modelSelected(Story.self)
            .flatMap(viewModel.didSelectStory)
            .asObservable()
            .

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] idx in
                self?.tableView.deselectRow(at: idx, animated: true)
            })
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

    let dataSource: RxTableViewSectionedReloadDataSource<NewsSection> = .init(
        configureCell: { (dataSource, tableView, idx, story) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Story") as! StoryCell
            cell.configure(with: story)
            return cell
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 90
        tableView.estimatedRowHeight = 90
        tableView.mj_header = refreshHeader
        tableView.mj_footer = refreshFooter
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 56/255, green: 179/255, blue: 245/255, alpha: 1)

        tableView.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
    }
}

extension NewsVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else { return nil }

        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! NewsHeaderView

        let title = dataSource.sectionModels[section].date

        headerView.label.text = title

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
