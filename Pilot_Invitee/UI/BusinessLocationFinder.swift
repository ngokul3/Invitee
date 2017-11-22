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
    
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var txtBusinessType: UITextField!
    
    @IBOutlet weak var btnSearch: UIBarButtonItem!
    fileprivate var presenter : LocationSearchPresenter!
    fileprivate var businessMasterControllerMaker: DependencyRegistry.BusinessMasterControllerMaker!
    
    func configure(with presenter: LocationSearchPresenter, businessMasterControllerMaker : @escaping DependencyRegistry.BusinessMasterControllerMaker)
    {
        self.presenter = presenter
        self.businessMasterControllerMaker = businessMasterControllerMaker
    }
    @IBAction func btnSearchClick(_ sender: Any) {
        SearchBusiness()
    }
    @IBAction func btnCancelClick(_ sender: Any) {
        txtBusinessType.endEditing(true)
        searchController.endEditing(true)
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
    
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            txtBusinessType.becomeFirstResponder()
    
        }
    func popNextController(location : String)
    {
        searchController.text = location
        refreshData()
    }
   
    func SearchBusiness()
    {
        let businessMasterController = businessMasterControllerMaker(searchController.text!, txtBusinessType.text!)
        navigationController?.pushViewController(businessMasterController, animated: true)
    }
}
