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

class BusinessMasterController: UIViewController, UITableViewDataSource ,UITableViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate  {
   
    
   
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var locationSearched : String = ""
    private var businesses = [Business]()
    fileprivate var presenter : BusinessMasterPresenter!
    fileprivate var businessDetailMaker : DependencyRegistry.BusinessDetailControllerMaker!
    fileprivate var businessCellMaker : DependencyRegistry.BusinessCellMaker!
    fileprivate var businessNotificationMaker : DependencyRegistry.BusinessNotificationControllerMaker!
    
    func configure(with presenter: BusinessMasterPresenter,
                   businessDetailControllerMaker: @escaping DependencyRegistry.BusinessDetailControllerMaker,
                   businessCellMaker: @escaping DependencyRegistry.BusinessCellMaker,
                   businessNotificationMaker : @escaping DependencyRegistry.BusinessNotificationControllerMaker)
    {
        self.presenter = presenter
        self.businessDetailMaker = businessDetailControllerMaker
        self.businessCellMaker = businessCellMaker
        self.businessNotificationMaker = businessNotificationMaker
    }
    
    @IBAction func clickNotification(_ sender: Any) {
        
        var business1 = Business(name: "TExt")
        
        business1.name   = "test"
        
        businesses.append(business1)
       // let notificationController = businessNotificationMaker(businesses)
        //navigationController?.pushViewController(notificationController, animated: true)
        
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
            return
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        mailComposer.setToRecipients(["ngokul3@gmail.com"])
        mailComposer.setMessageBody("Hello from California!", isHTML: false)

        
        // Present the view controller modally.
        self.present(mailComposer, animated: true, completion: nil)
        
        
        
//        let msgComposer = MFMessageComposeViewController()
//        msgComposer.messageComposeDelegate = self
//
//        // Configure the fields of the interface.
//        msgComposer.recipients = ["6469428120"]
//        msgComposer.body = "Hello from California!"
//
//        // Present the view controller modally.
//        self.present(msgComposer, animated: true, completion: nil)
//
        
        
        
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith: MFMailComposeResult, error: Error?)
    {
         controller.dismiss(animated: true, completion: nil)
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func mailComposeControlleer(_ controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)
        
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



