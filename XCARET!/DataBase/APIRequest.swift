//
//  APIRequest.swift
//  XCARET!
//
//  Created by Angelica Can on 20/04/21.
//  Copyright © 2021 Angelica Can. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

class APIRequest {
    
    static let shared = APIRequest()
    
    func execute(url: String, token: String, params: AnyObject, completion: @escaping (_ completed: Bool, _ JSONResponse: JSON) -> ()){
        let jsonBody = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: jsonBody!, encoding: String.Encoding.utf8.rawValue)
        if let json = json {
            print(json)
        }
        
        //Configuramos el urlRequest
        let urlTrim = url.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let urlRequest = URL(string: urlTrim) else { return }
        var request = URLRequest(url: urlRequest)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonBody
        
        Alamofire.request(request)
            .validate(statusCode: 200..<600)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    
                    if response.result.value != nil {
                        let json = JSON(response.result.value!)
                        
                        completion(true, json)
                    }
                    else {
                        completion(false, JSON.null)
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(false, JSON.null)
                }
        }
    }
}
