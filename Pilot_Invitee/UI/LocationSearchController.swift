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
    fileprivate var presenter : LocationSearchPresenter!
    fileprivate var businessMasterControllerMaker: DependencyRegistry.BusinessMasterControllerMaker!
    
    var searchController = UISearchController(searchResultsController: nil)
   
    weak var businessDelegate: LocationSearchedDelegate?
    
    
    func configure(with presenter: LocationSearchPresenter, businessMasterControllerMaker : @escaping DependencyRegistry.BusinessMasterControllerMaker)
    {
        self.presenter = presenter
        self.businessMasterControllerMaker = businessMasterControllerMaker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // presenter = LocationSearchPresenter()

        searchController.searchBar.delegate = self as? UISearchBarDelegate
        
        searchController =  UISearchController(searchResultsController:nil )
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchController.searchBar.delegate = presenter as? UISearchBarDelegate
        searchController.isActive = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        title = "Location Search"
        
        presenter.locationDelegate = self
        tableView.dataSource = presenter as? UITableViewDataSource
        tableView.delegate = presenter as? UITableViewDelegate
   
        presenter.viewController = self
       
    }
    
  
    func refreshData()
    {
        tableView.reloadData()
    }
   
    func popNextController(location : String, cell : UITableViewCell)
    {
        
        let businessMasterController = businessMasterControllerMaker(location)

        navigationController?.pushViewController(businessMasterController, animated: true)
  
    }
    
    
}
