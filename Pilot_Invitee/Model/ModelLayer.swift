//
//  ModelLayer.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 9/29/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import Foundation

typealias BusinessBlock = ([Business])->Void

protocol   ModelLayer{
    func loadData(location: String, term:String, resultsLoaded: @escaping  BusinessBlock)
    
}

class ModelLayerImpl: ModelLayer
{
    fileprivate var networkLayer : NetworkLayer
    fileprivate var translationLayer : TranslationLayer
    
    init(networkLayer: NetworkLayer,
         translationLayer: TranslationLayer)
    {
        self.networkLayer = networkLayer
         self.translationLayer = translationLayer
    }
    
    func loadData(location: String, term:String, resultsLoaded: @escaping  BusinessBlock)
    {
        
        networkLayer.loadFromNetwork(location: location, term: term, finished: { data in
            let businesses = self.translationLayer.createBusinessFromJsonData(data)
            
            resultsLoaded( businesses)
            
        })
        
    }
}
