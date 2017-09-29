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
    private var locationPresenter : LocationSearchPresenter!
    
    var searchController = UISearchController(searchResultsController: nil)
   // var matchingItems: [MKMapItem] = []
    
    //private let manager = CLLocationManager()
    
   // let dataSource = LocationDataSource()

    weak var businessDelegate: LocationSearchedDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationPresenter = LocationSearchPresenter()

        searchController.searchBar.delegate = self as? UISearchBarDelegate
        
        searchController =  UISearchController(searchResultsController:nil )
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchController.searchBar.delegate = locationPresenter
        searchController.isActive = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        title = "Location Search"
        
        locationPresenter.locationDelegate = self
        tableView.dataSource = locationPresenter
        tableView.delegate = locationPresenter
        
       // manager.delegate = dataSource

        locationPresenter.viewController = self
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData()
    {
        tableView.reloadData()
    }
   
    func popNextController(location : String, cell : UITableViewCell)
    {
        
        let businessMasterController = BusinessMasterController.fromLocationStoryboard(with : location)
        
        navigationController?.pushViewController(businessMasterController, animated: true)
  
    }
    
    
}
