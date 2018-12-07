//
//  TableViewController.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/6.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

fileprivate let kCellID: String = "cell"

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dataItem = ["UILabel的使用","UIbutton、UISwitch的使用","UITextField的使用","UITextView的使用","其他UI控件的使用","UIGesture的使用","UIDatePicker的使用","UIPickerView的使用","UICollectionView的使用"]
        let vcName = ["WTLabelVC","WTButtonVC","WTTextFieldVC","WTTextViewVC","WTOtherViewVC","WTGestureViewVC","WTPickerVC","WTPickerViewVC","WTCollectionViewVC"]
        let items = Observable.just([SectionModel(model: "", items: dataItem)])
        
        // 1. 导航编辑按钮
        var isEditing = false
        editButton.rx.tap.subscribe(onNext: {[weak self] in
            isEditing = !isEditing
            if isEditing {
                self?.editButton.title = "取消"
            } else {
                self?.editButton.title = "编辑"
            }
            self?.tableView.isEditing = isEditing
        }).disposed(by: disposeBag)
        
        // 2. 加载tableViewCell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellID)
        tableView.tableFooterView = UIView.init()
        
        // 3-1. 设置tableView代理
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // 4-1. 给tableViewCell绑定数据
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, tableView, indexPath, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: kCellID)!
            cell.textLabel?.text = element
            cell.selectionStyle = .none
            return cell
        })
        
        // 4-2. 点击代理
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.pushVC(vcName: vcName[indexPath.row], vcTitle: dataItem[indexPath.row])
        }).disposed(by: disposeBag)
        
        // 4-3. 删除代理
        dataSource.canEditRowAtIndexPath = {item, indexPath in
            if indexPath.row == 0 {
                return true
            }
            return false
        }

        tableView.rx.itemDeleted.subscribe(onNext: {indexPath in
            print("删除:\(indexPath)")
        }).disposed(by: disposeBag)

        // 4-4. 移动代理
        dataSource.canMoveRowAtIndexPath = {item, indexPath in
            if indexPath.row == 0 {
                return true
            }
            return false
        }

        tableView.rx.itemMoved.subscribe(onNext: { (sourceIndexPath, destinationIndexPath) in
            print("移动 source:\(sourceIndexPath) <---> destination:\(destinationIndexPath)")
        }).disposed(by: disposeBag)

        // 5. 给collectionView绑定数据
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension TableViewController {
    func pushVC(vcName: String, vcTitle: String) {
        print("vcName: \(vcName) vcTitle:\(vcTitle)")
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: vcName)
        vc.title = vcTitle
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
