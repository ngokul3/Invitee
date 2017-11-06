//
//  BusinessMasterControllerTableViewController.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 9/16/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import SafariServices


protocol BusinessViewDelegate {
    func businessInfoClicked(businessInfoURL : String)
}
class BusinessMasterController: UIViewController, UITableViewDataSource ,UITableViewDelegate, SFSafariViewControllerDelegate , BusinessViewDelegate {
   
    
   
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var locationSearched : String = ""
    private var businesses = [Business]()
    fileprivate var presenter : BusinessMasterPresenter!
  //  fileprivate var businessDetailMaker : DependencyRegistry.BusinessDetailControllerMaker!
    fileprivate var businessCellMaker : DependencyRegistry.BusinessCellMaker!
    fileprivate var businessNotificationMaker : DependencyRegistry.BusinessNotificationControllerMaker!
    
    
    fileprivate var businessNotificationControllerMaker : DependencyRegistry.BusinessNotificationControllerMaker!
    
    func configure(with presenter: BusinessMasterPresenter,
                //   businessDetailControllerMaker: @escaping DependencyRegistry.BusinessDetailControllerMaker,
                   businessCellMaker: @escaping DependencyRegistry.BusinessCellMaker,
                   businessNotificationMaker : @escaping DependencyRegistry.BusinessNotificationControllerMaker,
                   businessNotificationControllerMaker : @escaping DependencyRegistry.BusinessNotificationControllerMaker)
    {
        self.presenter = presenter
     //   self.businessDetailMaker = businessDetailControllerMaker
        self.businessCellMaker = businessCellMaker
        self.businessNotificationMaker = businessNotificationMaker
        self.businessNotificationControllerMaker = businessNotificationControllerMaker
    }
    
    func businessInfoClicked(businessInfoURL : String)
    {
        let urlString = businessInfoURL
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //    let viewController = segue.destination as! NotificationController
//        viewController.businesses  = businesses.filter({$0.selected == true})
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setToolbarHidden(false, animated: true)
       // self.navigationController?.it
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
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark)
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            businesses[indexPath.row].selected = false
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            businesses[indexPath.row].selected = true
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark)
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            businesses[indexPath.row].selected = false
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            businesses[indexPath.row].selected = true
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let business = self.presenter.data[indexPath.row]

        businesses.append(business)
        let cell = businessCellMaker(tableView, indexPath, business, self)
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
extension BusinessMasterController{
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        self.navigationController?.setToolbarHidden(true, animated: animated)
        
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



