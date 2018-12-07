//
//  ViewController.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/4.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "首页"
    }

    @IBAction func loginAction(_ sender: Any) {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    @IBAction func tableViewAction(_ sender: Any) {
        navigationController?.pushViewController(RxTableViewController(), animated: true)
    }
    
    @IBAction func collectionViewAction(_ sender: Any) {
        navigationController?.pushViewController(RxCollectionViewController(), animated: true)
    }
    
    @IBAction func rxSwiftTestAction(_ sender: Any) {
        
    }
}

