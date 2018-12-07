//
//  RxCollectionViewController.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/5.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

fileprivate let kCollecCellID = "collecCell"

class RxCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate lazy var bag = DisposeBag()
    fileprivate lazy var anchorVM = AnchorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CollectionViewController"
        
        // 0. 加载collectionViewCell
        collectionView.register(UINib(nibName: "RxCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kCollecCellID)
        
        // 1. 设置代理
        let dataSource = RxCollectionViewSectionedReloadDataSource<AnchorSection>(configureCell: {(dataSource, collectionView, indexPath, item) -> RxCollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollecCellID, for: indexPath) as! RxCollectionViewCell
            cell.anchorModel = item
            return cell
        })
        
        // 2. 初始化请求
        let vmInput = AnchorViewModel.JunInput(category: .getNewList)
        let vmOutput = anchorVM.transform(input: vmInput)
        
        // 3. 添加刷新
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            vmOutput.requestCommod.onNext(true)
        })
        collectionView.mj_header.beginRefreshing()
        
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            vmOutput.requestCommod.onNext(false)
        })
        
        // 4. 给collectionView绑定数据
        // 4-1. 通过dataSource和section的model数组绑定数据(demo的用法, 推荐)
        vmOutput.sections.asDriver()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        // 4-2. 通过所有的数据源数组直接绑定cell, 无需考虑section和row
//        anchorVM.anchorArr.asDriver().drive(collectionView.rx.items(cellIdentifier: kCollecCellID, cellType: RxCollectionViewCell.self)) { (item, anchor, cell) in
//            cell.anchorModel = anchor
//            }.disposed(by: bag)
        
        // 5. 设置刷新状态
        vmOutput.refreshStatus.asObservable()
            .subscribe(onNext: { (status) in
                switch status {
                case .begingHeaderRefresh:
                    self.collectionView.mj_header.beginRefreshing()
                case .endHeaderRefresh:
                    self.collectionView.mj_header.endRefreshing()
                case .begingFooterRefresh:
                    self.collectionView.mj_footer.beginRefreshing()
                case .endFooterRefresh:
                    self.collectionView.mj_footer.endRefreshing()
                case .noMoreData:
                    self.collectionView.mj_footer.endRefreshingWithNoMoreData()
                default:
                    break
                }
            }).disposed(by: bag)
        
        // 6. 监听collectionView的点击
        collectionView.rx.modelSelected(AnchorModel.self)
            .subscribe(onNext: { (model) in
                print(model.name)
            }).disposed(by: bag)
        
    }
}
