//
//  ModelLayer.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 9/29/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import Foundation

typealias BusinessBlock = ([Business])->Void


class ModelLayer
{
    fileprivate var networkLayer = NetworkLayer()
    fileprivate var translationLayer = TranslationLayer()
    
    
    func loadData(location: String, resultsLoaded: @escaping  BusinessBlock)
    {
        
        networkLayer.loadFromNetwork(location: location,finished: { data in
            let businesses = self.translationLayer.createBusinesssFromJsonData(data)
            
            resultsLoaded( businesses)
            
        })
        
    }
}
