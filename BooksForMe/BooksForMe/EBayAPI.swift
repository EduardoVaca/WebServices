//
//  EBayAPI.swift
//  BooksForMe
//
//  Created by Eduardo Vaca on 18/10/16.
//  Copyright © 2016 Vaca. All rights reserved.
//

import Foundation

enum MethodEBay: String {
    case FindOffers = "findItemsByProduct"
}


struct EBayAPI {
    
    private static let baseSandBoxURLString = "http://svcs.ebay.com/services/search/FindingService/v1"
    private static let appID = "AaltoUni-ws-PRD-6e6e6803e-27f37b0f"
    
    
    static func getSOAPEnvelopeWithISBN(method: MethodEBay, isbn: String, results: Int) -> String {
        var envelope = "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns=\"http://www.ebay.com/marketplace/search/v1/services\"><soap:Header/>"
        envelope += "<soap:Body><findItemsByProductRequest><productId type=\"ISBN\">" + isbn + "</productId><paginationInput><entriesPerPage>" + String(results) + "</entriesPerPage></paginationInput></findItemsByProductRequest></soap:Body></soap:Envelope>"
        return envelope
    }
    
    static func getEbaySandBoxURL(method: MethodEBay) -> URL? {
        var url = baseSandBoxURLString + "?SECURITY-APPNAME=" + appID + "&OPERATION-NAME=" + method.rawValue
        // This for eBay to support SOAP
        url += "&MESSAGE-PROTOCOL=SOAP12"
        print("URL: \(url)")
        return URL(string: url)
    }
    
    
}
