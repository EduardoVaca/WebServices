//
//  ExternalBankRESTAPI.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 20/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import Foundation

/*
    Struct in charge of interating with an external API developed by another student from the Web Services class
 */

enum MethodExternalBank: String {
    case CardPayment = "/api/v1/transactions"
}

struct ExternalBankRESTAPI {
    
    private static let baseURLString = "http://demo.seco.tkk.fi/ws/6/t755300bank"
    
    static func externalBankURL(method: MethodExternalBank) -> URL {
        let url = baseURLString + method.rawValue
        return URL(string: url)!
    }
    
    static func createJSONBody(amount: Float, owner: String, cardNumber: String, expireYear: String, expireMonth: String, csvString: String) -> String? {
        
        let valueInCents = Int(amount * 100)
        guard let year = Int(expireYear),
            let month = Int(expireMonth),
            let csv = String(csvString) else {
            return nil
        }
        
        let json = "{\"amountInCents\":" + String(valueInCents) + ",\"card\": {\"owner\":" + owner + ",\"number\":" + cardNumber + ",\"validYear\":" + String(year) + ",\"validMonth\":" + String(month) + ",\"csv\":" + csv + "},\"targetIBAN\": \"123456789\",\"transactionMessage\": \"BooksForMe\"}"
        
        return json
    }
    
    
}
