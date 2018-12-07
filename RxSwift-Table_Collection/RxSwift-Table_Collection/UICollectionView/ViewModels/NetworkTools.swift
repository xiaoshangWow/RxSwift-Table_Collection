//
//  NetworkTools.swift
//  RxSwift-Table_Collection
//
//  Created by 许磊 on 2018/12/4.
//  Copyright © 2018 Jinhetech. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

// 网络请求
let junNetworkTool = MoyaProvider<JunNetworkTool>()
let bag = DisposeBag()

// 请求枚举类型
enum JunNetworkTool {
    
    case getNewList
    case getHomeList(page: Int)
}

extension JunNetworkTool: Moya.TargetType {
    
    var headers: [String : String]? {
        return nil
    }
    
    // 统一基本的url
    var baseURL: URL {
        return URL(string: "http://qf.56.com/home/v4/moreAnchor.ios")!
    }
    
    // path字段会追加至baseURL后面
    var path: String {
        return ""
    }
    
    // 请求的方式
    var method: Moya.Method {
        return .get
    }
    
    // 参数编码方式(这里使用URL的默认方式)
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    // 用于单元测试
    var sampleData: Data {
        return "getList".data(using: .utf8)!
    }
    
    // 将要被执行的任务(请求: request 下载: download 上传: upload)
    var task: Task {
        return .requestPlain
    }
    
    // 请求参数(会在请求时进行编码)
    var parameters: [String : Any] {
        switch self {
        case .getHomeList(let index):
            return ["index" : index]
        default:
            return ["index" : 1]
        }
    }
    
    // 是否执行Alamofire验证, 默认值为false
    var validationType: ValidationType {
        return .none
    }
}

// 请求返回状态
enum NetworkRequestState: Int {
    case success = 200
    case error
}
