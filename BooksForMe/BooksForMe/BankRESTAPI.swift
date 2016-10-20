//
//  BankRESTAPI.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 18/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import Foundation

enum MethodBankREST: String {
    case ProcessPayment = "/process_payment"
}

enum BankResult {
    case Success(String)
    case Failure(Error)
}

enum BankError: Error {
    case InvalidDataResponse    
}

struct BankRESTAPI {
    
    private static let baseURLString = "http://localhost:8080"
    
    static func bankRESTURL(method: MethodBankREST) -> URL {
        
        let methodURL = baseURLString + method.rawValue
        
        let components = URLComponents(string: methodURL)!
        
        return components.url!
    }
    
    static func createBodyPOST(parameters: [String: String]) -> Data {
        var body = String()
        for (key, value) in parameters {
            body += key + "=" + value + "&"
        }
        return body.data(using: .utf8)!
    }
    
    static func messageFromData(data: Data?, error: Error?) -> BankResult {
        if let data = data {
            if let responseText = String(data: data, encoding: .utf8) {
                return .Success(responseText)
            }
            else {
                return .Failure(BankError.InvalidDataResponse)
            }
        }
        else {
            return .Failure(error!)
        }
    }
}
