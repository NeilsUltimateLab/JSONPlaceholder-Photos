//
//  Profile.swift
//  Demonstration
//
//  Created by Neil on 26/01/17.
//  Copyright © 2017 Neil's Ultimate Lab. All rights reserved.
//

import Foundation

/*

{
 "id": 1,
 "name": "Leanne Graham",
 "username": "Bret",
 "email": "Sincere@april.biz",
 "address": {
     "street": "Kulas Light",
     "suite": "Apt. 556",
     "city": "Gwenborough",
     "zipcode": "92998-3874",
     "geo": {
        "lat": "-37.3159",
        "lng": "81.1496"
     }
 },
 "phone": "1-770-736-8031 x56442",
 "website": "hildegard.org",
 "company": {
    "name": "Romaguera-Crona",
    "catchPhrase": "Multi-layered client-server neural-net",
    "bs": "harness real-time e-markets"
 }
}
 
*/

class Profile: NSObject {
    var id: String?
    var name: String?
    var username: String?
    var email: String?
    var phone: String?
    var website: String?
    
    var address: Address? = Address()
    var company: Company? = Company()
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "address" {
            self.address?.setValuesForKeys(value as! [String : Any])
        }
        else if key == "company" {
            self.company?.setValuesForKeys(value as! [String : Any])
        }else if key == "id" {
            if let id = value as? Int {
                self.id = "\(id)"
            }
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
}

class Address: NSObject {
    
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
    var geo: Geo? = Geo()

    var keys: [String] {
        get {
            return ["street","suite","city","zipcode"]
        }
    }
    
    var descriptiveAddress: [String : String] {
        get {
            if let street = street, let suite = suite, let city = city, let zipcode = zipcode {
                return ["street": street, "suite":suite, "city":city, "zipcode": zipcode]
            }
            return [:]
        }
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "geo" {
            self.geo?.setValuesForKeys(value as! [String: Any])
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
}

class Geo: NSObject {
    var lat: String?
    var lng: String?
}

class Company: NSObject {
    var name: String?
    var catchPhrase: String?
    var bs: String?
    
    let headerName = "Company"
    
    var keys: [String] {
        get {
            return ["Name","Phrase","BS"]
        }
    }
    
    var descritiveDetail: [String: String] {
        get {
            if let name = name, let catchPhrase = catchPhrase, let bs = bs {
                return ["Name": name, "Phrase": catchPhrase, "BS": bs]
            }
            return [:]
        }
    }
}










