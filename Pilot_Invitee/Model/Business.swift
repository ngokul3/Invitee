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
   // var rating : String
}



extension Business: Deserializable {
    
    init(object: Outlaw.Extractable) throws {
    
        
         name = try object.value(for: "name")
       // rating = try object.value(for: "rating")
           }
    
   
}

extension Business: Serializable {
    func serialized() -> [String: Any] {
        return ["name": name]
        
    }
}


