//
//  TranslationLayer.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 9/29/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import Foundation
import Outlaw

protocol TranslationLayer{
    func createBusinessFromJsonData(_ data: Data)->[Business]
}
class TranslationLayerImpl: TranslationLayer{
 

    func createBusinessFromJsonData(_ data: Data) -> [Business] {
        
        print("converting json to DTOs")
        guard let json:[String: Any] = try? JSON.value(from: data) else {return [Business]()}
        guard let businesses: [Business] = try? json.value(for: "businesses")
            else
        {return [Business]()}
        
        return businesses
    }
}

