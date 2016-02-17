//
//  Networking.swift
//  Testing
//
//  Created by alex oh on 2/16/16.
//  Copyright © 2016 Alex Oh. All rights reserved.
//

import Foundation
import Alamofire

final class Networking {
    
    // took out apikey for github
    
    class func getEventsNearby() {
        
        Alamofire.request(.GET, "http://api.jambase.com/events", parameters: ["zipCode": "95128", "page": "0", "api_key": ""]).responseCollection { (response: Response<[Event], NSError>) -> Void in
//            print(response.result.value)
            
            print(response.result.debugDescription)
        }
    }
    
}

final class Event: ResponseObjectSerializable, ResponseCollectionSerializable {
    
    let ticketUrl: String
    let venue: Venue
    var artists: [Artist]
    let date: String
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        self.ticketUrl = representation.valueForKeyPath("TicketUrl") as! String
        self.venue = Venue(response:response, representation: representation.valueForKeyPath("Venue")!)
        self.date = representation.valueForKeyPath("Date") as! String
        self.artists = []
        
        for artistRep in representation.valueForKeyPath("Artists") as! [AnyObject]{
            self.artists.append(Artist(response: response, representation: artistRep))
        }
    }
    
    class func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Event] {
        var events:[Event] = []
        for eventsRep in representation.valueForKeyPath("Events") as! [AnyObject] {
            events.append(Event(response: response, representation: eventsRep))
        }
        return events
    }
    
    func toDic() -> Dictionary<String,AnyObject> {
        return ["ticketURL": self.ticketUrl, "venue":self.venue, "artists":self.artists, "date":self.date]
    }
    
    
}

final class Artist: ResponseObjectSerializable {
    let name: String
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        self.name = representation.valueForKeyPath("Name") as! String
    }
}

final class Venue: ResponseObjectSerializable {
    let name: String
    let city: String
    let address: String
    let country: String
    let zipCode: String
    let state: String
    let stateCode: String
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        self.name = representation.valueForKeyPath("Name") as! String
        self.city = representation.valueForKeyPath("City") as! String
        self.country = representation.valueForKeyPath("Country") as! String
        self.zipCode = representation.valueForKeyPath("ZipCode") as! String
        self.state = representation.valueForKeyPath("State") as! String
        self.address = representation.valueForKeyPath("Address") as! String
        self.stateCode = representation.valueForKeyPath("StateCode") as! String
    }
}





public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}

extension Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: Response<T, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let
                    response = response,
                    responseObject = T(response: response, representation: value)
                {
                    return .Success(responseObject)
                } else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}






public protocol ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

extension Alamofire.Request {
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: Response<[T], NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let response = response {
                    return .Success(T.collection(response: response, representation: value))
                } else {
                    let failureReason = "Response collection could not be serialized due to nil response"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

