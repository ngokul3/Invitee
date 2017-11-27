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
    @IBOutlet weak var searchController: UISearchBar! {
        didSet {
            searchController.change(textFont: UIFont.systemFont(ofSize: 14.0))
        }
    }
    
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var txtBusinessType: UITextField!
    
    @IBOutlet weak var btnSearch: UIBarButtonItem!
    fileprivate var presenter : LocationSearchPresenter!
    fileprivate var businessMasterControllerMaker: DependencyRegistry.BusinessMasterControllerMaker!
//    let locationManager = CLLocationManager()

    
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
     //   self.searchController.setScopeBarButtonTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 11.0)!], for: .normal)
        
      //  let textFieldInsideUISearchBarLabel = searchController!.value(forKey: "Placeholder") as? UILabel
        //textFieldInsideUISearchBarLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 11.0)!
        
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
            searchController.becomeFirstResponder()
    
        }
    func popNextController(location : String)
    {
        searchController.text = location
        refreshData()
    }
   
    func SearchBusiness()
    {
        guard let txtLocation = searchController.text, txtLocation.trim() != ""   else
        
        {
            let alert = UIAlertController(title: "Location Required", message: "Enter the location that you are interested", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                //NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let businessMasterController = businessMasterControllerMaker(searchController.text!, txtBusinessType.text!)
        
        
        navigationController?.pushViewController(businessMasterController, animated: true)
    }
}

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

extension UISearchBar {
    
    func change(textFont : UIFont?) {
        
        for view : UIView in (self.subviews[0]).subviews {
            
            if let textField = view as? UITextField {
                textField.font = textFont
                //textField.textColor = UIColor(named: "HelveticaNeue-Medium")
            }
        }
    } }
