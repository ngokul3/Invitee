//
//  BusinessMasterPresenter.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 9/28/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import Foundation

//import CoreData

import MapKit

typealias FinishedBlock = ()->Void
class BusinessMasterPresenter{
    
    var matchingItems: [MKMapItem] = []
    var data = [Business]()
    var modelLayer = ModelLayer()
    
    func loadData(location: String, finished: @escaping FinishedBlock )
    {
        
        modelLayer.loadData(location: location,resultsLoaded: { businesses in
           self.data = businesses
            
            finished()
            
        })
        
    }
}











