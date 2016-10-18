//
//  EBayAPI.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 18/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import Foundation

enum MethodEBay: String {
    case FindOffers = "FindItemsByProductRequest"
}


struct EBayAPI {
    
    private static let baseSandBoxURLString = "http://svcs.sandbox.ebay.com/services/search/FindingService/v1"
    private static let appID = "AaltoUni-ws-SBX-3e6eb0ea5-11d466dd"
    
    
    static func getSOAPEnvelopeWithISBN(method: MethodEBay, isbn: String) -> String {
        var envelope = "<?xml version=\"1.0\"?><soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns=\"" + baseSandBoxURLString + "\">"
        envelope += "<soap:Header><X-EBAY-SOA-SECURITY-APPNAME>" + appID + "</X-EBAY-SOA-SECURITY-APPNAME>"
        envelope += "<X-EBAY-SOA-MESSAGE-PROTOCOL>SOAP12</X-EBAY-SOA-MESSAGE-PROTOCOL>"
        envelope += "<X-EBAY-SOA-OPERATION-NAME>FindItemsByProductRequest</X-EBAY-SOA-OPERATION-NAME>"
        envelope += "</soap:Header>"
        envelope += "<soap:Body><FindItemsByProductRequest><productId type=\"ISBN\">" + isbn + "</productId></FindItemsByProductRequest></soap:Body></soap:Envelope>"
        return envelope
    }
    
    static func getEbaySandBoxURL() -> URL? {
        return URL(string: baseSandBoxURLString)
    }
        
    
}
