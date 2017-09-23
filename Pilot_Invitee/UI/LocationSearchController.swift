//
//  LocationSearchController.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 9/23/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import UIKit
import CoreLocation

class LocationSearchController: UIViewController, LocationDataSourceDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController = UISearchController(searchResultsController: nil)
   // var matchingItems: [MKMapItem] = []
    
    private let manager = CLLocationManager()
    
    let dataSource = LocationDataSource()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchBar.delegate = self as? UISearchBarDelegate
        
        searchController =  UISearchController(searchResultsController:nil )
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchController.searchBar.delegate = dataSource
        searchController.isActive = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        title = "Location Search"
        
        dataSource.delegate = self
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        manager.delegate = dataSource

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData()
    {
        tableView.reloadData()
    }
   

}
