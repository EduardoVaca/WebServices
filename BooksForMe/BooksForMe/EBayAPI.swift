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

enum OfferResults {
    case Success([Offer])
    case Failure(Error)
}

enum OfferError: Error {
    case NoOffersFound
}

class EBayAPI: NSObject, XMLParserDelegate {
    
    private static let baseSandBoxURLString = "http://svcs.ebay.com/services/search/FindingService/v1"
    private static let appID = "YOUR KEY HERE"
    
    private var parser = XMLParser()
    private var currentElement = String()
    private var passOffer = false
    private var offers = [Offer]()
    private var currentOffer = [String: String]()
    
    enum Fields: String {
        case Offer = "item"
        case Name = "title"
        case Category = "categoryName"
        case Country = "country"
        case Price = "currentPrice"
    }

    
    static func getSOAPEnvelopeWithISBN(method: MethodEBay, isbn: String, results: Int) -> String {
        var envelope = "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns=\"http://www.ebay.com/marketplace/search/v1/services\"><soap:Header/>"
        envelope += "<soap:Body><findItemsByProductRequest><productId type=\"ISBN\">" + isbn + "</productId><paginationInput><entriesPerPage>" + String(results) + "</entriesPerPage></paginationInput></findItemsByProductRequest></soap:Body></soap:Envelope>"
        return envelope
    }
    
    static func getEbaySandBoxURL(method: MethodEBay) -> URL? {
        var url = baseSandBoxURLString + "?SECURITY-APPNAME=" + appID + "&OPERATION-NAME=" + method.rawValue
        // This for eBay to support SOAP
        url += "&MESSAGE-PROTOCOL=SOAP12"        
        return URL(string: url)
    }
    
    func offersFromXMLData(data: Data) -> OfferResults {
        self.parser = XMLParser(data: data)
        self.parser.delegate = self
        
        self.parser.parse()
        
        if offers.count > 0 {        
            return .Success(offers)
        }
        else {
            return .Failure(OfferError.NoOffersFound)
        }
        
    }
    
    static func offerFromDictionary(dictionary: [String: String]) -> Offer? {
        
        guard let name = dictionary[Fields.Name.rawValue],
            let country = dictionary[Fields.Country.rawValue],
            let category = dictionary[Fields.Category.rawValue],
            let priceStr = dictionary[Fields.Price.rawValue],
            let price = Float(priceStr) else {
                return nil
        }
        
        return Offer(name: name, category: category, country: country, price: price)
    }
    
    
    /*
     XML Parser functions
     Implementation depends on the data returned and the interested fields.
     */
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName;
        if currentElement == Fields.Offer.rawValue {
            passOffer = true
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if passOffer && elementName == Fields.Offer.rawValue {
            passOffer = false
            
            if let offer = EBayAPI.offerFromDictionary(dictionary: currentOffer) {
                offers.append(offer)
            }
            currentOffer.removeAll()
            currentElement = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if passOffer {
            switch currentElement {
            case Fields.Name.rawValue:
                if currentOffer[Fields.Name.rawValue] == nil {
                    currentOffer[Fields.Name.rawValue] = string
                }
            case Fields.Country.rawValue:
                if currentOffer[Fields.Country.rawValue] == nil {
                    currentOffer[Fields.Country.rawValue] = string
                }
            case Fields.Price.rawValue:
                if currentOffer[Fields.Price.rawValue] == nil {
                    currentOffer[Fields.Price.rawValue] = string
                }
            case Fields.Category.rawValue:
                if currentOffer[Fields.Category.rawValue] == nil {
                    currentOffer[Fields.Category.rawValue] = string
                }
            default: break
            }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }

    
}
