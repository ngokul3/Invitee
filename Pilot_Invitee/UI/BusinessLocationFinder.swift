//
//  BusinessLocationFinder.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 11/19/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import UIKit

class BusinessLocationFinder: UIViewController,LocationDataSourceDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchController: UISearchBar!
    
    @IBOutlet weak var txtBusinessType: UITextField!
    
    fileprivate var presenter : LocationSearchPresenter!
    fileprivate var businessMasterControllerMaker: DependencyRegistry.BusinessMasterControllerMaker!
    
    func configure(with presenter: LocationSearchPresenter, businessMasterControllerMaker : @escaping DependencyRegistry.BusinessMasterControllerMaker)
    {
        self.presenter = presenter
        self.businessMasterControllerMaker = businessMasterControllerMaker
    }
     override func viewDidLoad() {
        super.viewDidLoad()
         
        searchController.delegate = presenter as? UISearchBarDelegate
        presenter.locationDelegate = self
        
        tableView.dataSource = presenter as? UITableViewDataSource
        tableView.delegate = presenter as? UITableViewDelegate
        
        txtBusinessType.borderStyle =  UITextBorderStyle.roundedRect
      
    }
    func refreshData()
    {
        tableView.reloadData()
    }
    
    func popNextController(location : String, cell : UITableViewCell)
    {
        
        let businessMasterController = businessMasterControllerMaker(location, txtBusinessType.text!)
        
        navigationController?.pushViewController(businessMasterController, animated: true)
        
    }
    

}
