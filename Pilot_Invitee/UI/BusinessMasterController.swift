//
//  BusinessMasterControllerTableViewController.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 9/16/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import UIKit
import Foundation


class BusinessMasterController: UIViewController, UITableViewDataSource ,UITableViewDelegate {
   
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var locationSearched : String = ""
    fileprivate var presenter : BusinessMasterPresenter!
    fileprivate var businessDetailMaker : DependencyRegistry.BusinessDetailControllerMaker!
    fileprivate var businessCellMaker : DependencyRegistry.BusinessCellMaker!
    
    func configure(with presenter: BusinessMasterPresenter, businessCellMaker : @escaping DependencyRegistry.BusinessCellMaker,
                   businessDetailControllerMaker: @escaping DependencyRegistry.BusinessDetailControllerMaker)
    {
        self.presenter = presenter
        self.businessDetailMaker = businessDetailControllerMaker
        self.businessCellMaker = businessCellMaker
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     //    searchController.searchResultsUpdater = self as! UISearchResultsUpdating
    //    self.navigationItem.searchController = searchController
      //  searchController.searchBar.delegate = self as? UISearchBarDelegate
       // self.tableView.tableHeaderView = searchController.searchBar
        //self.tableView.reloadData()
//        tableView.tableHeaderView = searchController.searchBar

        BusinessCell.register(with: tableView)
   
        self.presenter.loadData( finished: {
            self.DataReceived()
        })
    }
    
    func DataReceived() {
        tableView.reloadData()
    }
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return self.presenter.data.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let business = self.presenter.data[indexPath.row]

       // let cell = BusinessCell.dequeue(from: tableView, for: indexPath, with: business)
        let cell = businessCellMaker(tableView, indexPath, business)
        return cell

    }
}

extension BusinessMasterController{
    static func fromLocationStoryboard(with locationSearched: String)-> BusinessMasterController
    {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "businessMasterController") as! BusinessMasterController
        vc.locationSearched = locationSearched
        
        return vc
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



