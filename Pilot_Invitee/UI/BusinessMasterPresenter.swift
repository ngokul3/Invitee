//
//  BusinessMasterPresenter.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 9/28/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
import Outlaw
import MapKit

class BusinessMasterPresenter{
    
    var matchingItems: [MKMapItem] = []
    var data = [Business]()
}




extension BusinessMasterPresenter{
    func loadData(location: String, resultsLoaded: @escaping  BusinessBlock)
    {
        
        loadFromNetwork(location: location,finished: { data in
            let businesses = self.createBusinesssFromJsonData(data)
            
            resultsLoaded( businesses)
            
        })
        
    }
}

extension BusinessMasterPresenter {
    
    func createBusinesssFromJsonData(_ data: Data) -> [Business] {
        
        print("converting json to DTOs")
        let json:[String: Any] = try! JSON.value(from: data)
        guard let businesses: [Business] = try! json.value(for: "businesses")
            else
        {return [Business]()}
        
        return businesses
    }
}

//MARK: - Network Methods
extension BusinessMasterPresenter {
    
    
    func loadFromNetwork(location: String, finished: @escaping (Data) -> Void) {
        let MY_API_KEY = "Bearer qEjtERYCtGRtYmaELAxisLtdM2TWMsUbLG-wvs0b8KlxIfECiKGRrnY7AKOZwe6Zsz_DehvIAXJtt4jiIrKYjCgyf0Tx4CK_yX0u-6LpOc35By8TiyGlLdElXgqzWXYx"
        
        var locationURL : String
        locationURL = "https://api.yelp.com/v3/businesses/search?location=" + location
        
        locationURL = locationURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        if let url = URL(string: locationURL) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            
            urlRequest.addValue(MY_API_KEY, forHTTPHeaderField: "Authorization")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            Alamofire.request(urlRequest)
                .responseJSON { response in
                    debugPrint(response)
                    
                    guard let data = response.data else { return }
                    
                    finished(data)
                    /* guard (response.result.value as? [String: Any]) != nil else { return }
                     
                     
                     
                     guard let value = response.result.value as? [String: Any],
                     let rows = value["businesses"] as? [[String: Any]] else {
                     print("Malformed data received from fetchAllRooms service")
                     finished(rows)
                     // return
                     }*/
                    
                    /* let businesses = rows.flatMap({ (businessDict) -> Business? in
                     
                     let _ = businessDict
                     // return Business(name: businessDict., rating: <#String#>)
                     
                     return Business(name: businessDict["name"], rating: businessDict["rating"])
                     })
                     
                     */
                    
                    
                    
            }
        }
        
        print("loading data from server")
        
    }
    
}
/*
extension BusinessMasterPresenter
{
    func loadBusinessForLocation(  selectedLocation : String)
    {
        locationController.navigationController?.popViewController(animated: true)
        
        self.loadData( location: selectedLocation,resultsLoaded: { business in
            self.data = business
            self.DataReceived()
        })
    }
}
*/
