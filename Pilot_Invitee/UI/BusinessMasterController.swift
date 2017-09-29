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


typealias BusinessBlock = ([Business])->Void

class BusinessMasterController: UIViewController, UITableViewDataSource ,UITableViewDelegate {
   
    
    @IBOutlet weak var tableView: UITableView!

  //  var matchingItems: [MKMapItem] = []
    //var data = [Business]()
    let searchController = UISearchController(searchResultsController: nil)
    
    let locationController = LocationSearchController()
    var locationSearched : String = ""
    var businessMasterPresenter : BusinessMasterPresenter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   //     locationController.businessDelegate = self
    //    searchController.searchResultsUpdater = self as! UISearchResultsUpdating
    //    self.navigationItem.searchController = searchController
      //  searchController.searchBar.delegate = self as? UISearchBarDelegate
        
        
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
        
        businessMasterPresenter = BusinessMasterPresenter()
        BusinessCell.register(with: tableView)
        
       businessMasterPresenter.loadData( location: locationSearched,resultsLoaded: { business in
        self.businessMasterPresenter.data = business
            self.DataReceived()
        })
 
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
        
       return businessMasterPresenter.data.count
       // return matchingItems.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let business = businessMasterPresenter.data[indexPath.row]

        let cell = BusinessCell.dequeue(from: tableView, for: indexPath, with: business)

        return cell

    }
    
   

   
    
}
/*

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

*/

extension BusinessMasterController{
    static func fromLocationStoryboard(with locationSearched: String)-> BusinessMasterController
    {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "businessMasterController") as! BusinessMasterController
        vc.locationSearched = locationSearched
        
        return vc
    }
}


