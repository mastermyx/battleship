//
//  RequestManager.swift
//  battleship
//
//  Created by Arthur Hatchiguian on 24/06/2018.
//  Copyright © 2018 Arthur Hatchiguian. All rights reserved.
//

import UIKit
import Alamofire
import Foundation


class RequestManager: NSObject {
    static let SERVER_URL = "https://www.fake.url/"
    
    static let JOIN_GAME = "\(SERVER_URL)/joinGame"
    
    static func requestFor(requestUrl : URLConvertible,
                           method: HTTPMethod = .get,
                           parameters: [String:Any]? = nil,
                           encoding: ParameterEncoding = URLEncoding.default,
                           headers: HTTPHeaders? = nil,
                           success: @escaping ([String:Any], HTTPURLResponse?) -> (),
                           failure: ((Error) -> ())? = nil) {
        
        //faking server answer after short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            success([:], nil)
        }
    }
    
    static func joinGame(id: String, success: (()->())? = nil, failure: ((Error?)->())? = nil) {
        RequestManager.requestFor(
            requestUrl: self.JOIN_GAME,
            method: .post,
            parameters: ["id":id],
            success: { (result, response) in
                if success != nil {
                    success!()
                }
        }) { (error) in
            if failure != nil {
                failure!(error)
            }
        }
    }
    
    
    
}
