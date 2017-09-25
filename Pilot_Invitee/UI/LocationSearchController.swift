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

    weak var businessDelegate: LocationSearchedDelegate?
    
    
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
        
        dataSource.locationDelegate = self
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        manager.delegate = dataSource

        dataSource.viewController = self
       
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
  //      let x = BusinessMasterController(nibName: nil, bundle: nil)
        
    //    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //    let newViewController = storyBoard.instantiateViewController(withIdentifier: "businessMasterController") as! BusinessMasterController
      //  self.present(newViewController, animated: true, completion: nil)
        
        
      //  self.navigationController?.pushViewController(x, animated: true)
        // businessDelegate?.loadBusinessForLocation( selectedLocation : location)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "locationToBusinessSegue") {
            
            let controller = segue.destination as! BusinessMasterController
            controller.locationSearched = "Springfield"
            //Configure controller attributes.
        }
    }
}
