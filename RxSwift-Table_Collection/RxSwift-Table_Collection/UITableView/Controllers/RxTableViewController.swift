//
//  RxTableViewController.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/4.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

fileprivate let kCellID: String = "rxCell"

class RxTableViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var rxTableView: UITableView!
    
    fileprivate lazy var bag: DisposeBag = DisposeBag()
    fileprivate lazy var heroArr = [HeroModel]()
    fileprivate lazy var heroVM: HeroViewModel = HeroViewModel(searchText: self.self.searchText)
    
    
    var searchText: Observable<String> {
        // 输入后间隔0.5秒搜索,在主线程运行
        return searchBar.rx.text.orEmpty.throttle(0.5, scheduler: MainScheduler.instance)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "UItableView"
        
        // 1. 加载tableViewCell
        rxTableView.rowHeight = 80
        rxTableView.register(UINib(nibName: "RxTableViewCell", bundle: nil), forCellReuseIdentifier: kCellID)
        
        // 2. 给tableView绑定数据
        heroVM.heroVariable.asDriver().drive(rxTableView.rx.items(cellIdentifier: kCellID, cellType: RxTableViewCell.self)) { (_, hero, cell) in
            cell.heroModel = hero
            }.disposed(by: bag)
        
        // 3. 监听UITableView的点击
        rxTableView.rx.modelSelected(HeroModel.self).subscribe { (event: Event<HeroModel>) in
            print(event.element?.name ?? "")
        }.disposed(by: bag)
    }
}

extension RxTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
