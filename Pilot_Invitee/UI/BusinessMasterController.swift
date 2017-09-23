//
//  BusinessMasterControllerTableViewController.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 9/16/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import UIKit
import Toaster
import Foundation
import Alamofire
import CoreData
import Outlaw
import MapKit

typealias BusinessBlock = ([Business])->Void

class BusinessMasterController: UIViewController, UITableViewDataSource ,UITableViewDelegate {
   
    
    @IBOutlet weak var tableView: UITableView!

    var matchingItems: [MKMapItem] = []
    var data = [Business]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        searchController.searchBar.delegate = self as? UISearchBarDelegate
        
        
       // self.tableView.tableHeaderView = searchController.searchBar
        //self.tableView.reloadData()

        
//        tableView.tableHeaderView = searchController.searchBar
//
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.sizeToFit()
//        // Setup the Scope Bar
//        //searchController.searchBar.scopeButtonTitles = ["All", "Restaurant", "Other"]
//        searchController.searchBar.delegate = self as? UISearchBarDelegate
//
//
//        self.tableView.tableHeaderView = searchController.searchBar
//        self.tableView.reloadData()

        
        /*loadData{ [weak self] business in
            self?.data = business
            self?.DataReceived()
        }*/
        
        BusinessCell.register(with: tableView)
    }
    
    func DataReceived() {
        //Toast(text: "New Data from \(source)").show()
        tableView.reloadData()
    }

    
    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return data.count
       // return matchingItems.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let business = data[indexPath.row]

        let cell = BusinessCell.dequeue(from: tableView, for: indexPath, with: business)

        return cell

    }
    
   

   
    
}

/*extension BusinessMasterController : UINavigationController
{
    
}*/
extension BusinessMasterController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let request = MKLocalSearchRequest()
        let searchText = searchController.searchBar.text
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {response, _ in
            
            guard let response = response else {
                return
            }
            
            self.matchingItems = response.mapItems
            var test = self.matchingItems[0].placemark.name
            //self.tableView.reloadData()
            
            for item in response.mapItems {
                print("Name = \(item.name ?? "")")
                print("Phone = \(item.phoneNumber ?? "")")
            }
            
            self.loadData( location: searchText!,resultsLoaded: { business in
                self.data = business
                self.DataReceived()
            })
            
        })
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }

    
    
}



extension BusinessMasterController{
    func loadData(location: String, resultsLoaded: @escaping  BusinessBlock)
    {
        
        loadFromNetwork(location: location,finished: { data in
            let businesses = self.createBusinesssFromJsonData(data)
            
            resultsLoaded( businesses)
            
        })

    }
}

extension BusinessMasterController {
    
    func createBusinesssFromJsonData(_ data: Data) -> [Business] {
        print("converting json to DTOs")
        let json:[String: Any] = try! JSON.value(from: data)
        let businesses: [Business] = try! json.value(for: "businesses")
        return businesses
}
}

//MARK: - Network Methods
extension BusinessMasterController {
    
    
    func loadFromNetwork(location: String, finished: @escaping (Data) -> Void) {
        let MY_API_KEY = "Bearer qEjtERYCtGRtYmaELAxisLtdM2TWMsUbLG-wvs0b8KlxIfECiKGRrnY7AKOZwe6Zsz_DehvIAXJtt4jiIrKYjCgyf0Tx4CK_yX0u-6LpOc35By8TiyGlLdElXgqzWXYx"
        
        var locationURL : String
        locationURL = "https://api.yelp.com/v3/businesses/search?location=" + location
        //if let url = URL(string: "https://api.yelp.com/v3/businesses/search?location=Teaneck") {
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


