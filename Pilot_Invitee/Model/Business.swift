//
//  BusinessData.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 9/16/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import Foundation
import Outlaw

struct Business
{
    var name:String
    var rating: Int
    var image_url : String
    var businessURL : String
    var selected : Bool
   // var rating : String
}



extension Business: Deserializable {
    
    init(object: Outlaw.Extractable) throws {
    
        
         name = try object.value(for: "name")
         selected = false
         rating = try object.value(for: "rating")
         image_url = try object.value(for: "image_url")
         businessURL = ""//try object.value(for: "businessURL")
           }
    
   
}

extension Business: Serializable {
    func serialized() -> [String: Any] {
        return ["name": name]
        
    }
}


