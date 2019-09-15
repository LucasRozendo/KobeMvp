//
//  RestClient.swift
//  TestKobe
//
//  Created by Lucas Rozendo on 14/09/19.
//  Copyright © 2019 Lucas Rozendo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RestClient {
    
    let apiKey: String = "c5850ed73901b8d268d0898a8a9d8bff"
    
    public class func execTaskSend(urlString: String,param: Parameters, method: HTTPMethod, taskCallback: @escaping (Bool,
        String?) -> ()) {
        let sendURL: String = "https://api.themoviedb.org"
        
        let url: String = sendURL+urlString
        
        Alamofire.request(url, method: method, parameters: param).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if let jsonStr = json.rawString() {
                    taskCallback(true, jsonStr)
                }
                
            case .failure(let error):
                taskCallback(false, nil)
                
            }
        }
        
    }
    
}


