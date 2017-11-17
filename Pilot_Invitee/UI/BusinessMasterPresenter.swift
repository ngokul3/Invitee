//
//  BusinessMasterPresenter.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 9/28/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import Foundation

import MapKit

typealias FinishedBlock = ()->Void

protocol BusinessMasterPresenter{
    var data : [Business]{get set}
    var location : String {get}
    func loadData(finished: @escaping FinishedBlock )
}
class BusinessMasterPresenterImpl: BusinessMasterPresenter{
    
    var matchingItems: [MKMapItem] = []
    var data = [Business]()
    var modelLayer : ModelLayer
    
    var location: String
    
    init(modelLayer: ModelLayer,location : String)
    {
        self.modelLayer = modelLayer
        self.location = location
    }
    
    func loadData(finished: @escaping FinishedBlock )
    {
        
        modelLayer.loadData(location: location,resultsLoaded: { businesses in
           self.data = businesses
            
            finished()
            
        })
        
    }
}











