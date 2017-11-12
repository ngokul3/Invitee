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
import PopupDialog


protocol BusinessViewDelegate {
    func businessInfoClicked(businessInfoURL : String)
}

class BusinessMasterController: UIViewController, UITableViewDataSource ,UITableViewDelegate, SFSafariViewControllerDelegate , MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, BusinessViewDelegate {
   
    @IBOutlet weak var tableView: UITableView!

    
    @IBAction func clickNotification(_ sender: Any) {
        
        showImageDialog()
      //  sendMailNotification(businessesForMail: businesses)
    }
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var locationSearched : String = ""
    fileprivate var businesses = [Business]()
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
    func showImageDialog(animated: Bool = true) {
        
        // Prepare the popup assets
        let title = "THIS IS THE DIALOG TITLE"
        let message = "This is the message section of the popup dialog default view"
        let image = UIImage(named: "Invite.png")
        
        let popup = PopupDialog(title: title, message: message, image: image)
        
        let buttonOne = CancelButton(title: "CANCEL") {
            //self.label.text = "You canceled the Invite."
        }
        
        buttonOne.addTarget(self, action:#selector(self.cancelClicked), for: .touchUpInside)
        
        let buttonTwo = DefaultButton(title: "Send a Mail") {
            //   self.label.text = "Email"
        }
        
        buttonTwo.addTarget(self, action:#selector(self.mailClicked), for: .touchUpInside)
        
        let buttonThree = DefaultButton(title: "Send a Message") {
            //    self.label.text = "Message)"
        }
        
        buttonThree.addTarget(self, action:#selector(self.messageClicked), for: .touchUpInside)
        
        popup.addButtons([buttonOne, buttonTwo, buttonThree])
        
        self.present(popup, animated: animated, completion: nil)
    }
    
    
    func cancelClicked()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailClicked()
    {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        let mailComposer = MFMailComposeViewController()
        
        var businessInfo = String()
        
        businessInfo = ConvertToHTMLTable(businessSelected: businesses.filter({$0.selected == true}))
        
        mailComposer.setMessageBody(businessInfo, isHTML: true)
        
        mailComposer.mailComposeDelegate = self
        
        self.present(mailComposer, animated: true, completion: nil)
    }
    
    func messageClicked()
    {
        if !MFMessageComposeViewController.canSendText(){
            print("SMS services are not available")
            return
        }
        
        let msgComposer = MFMessageComposeViewController()
        msgComposer.messageComposeDelegate = self
        
        
        var businessInfo  = String()
        
        businessInfo = ConvertToHTMLTable(businessSelected: businesses.filter({$0.selected == true}))
        
//        
//        for business in businesses.filter({$0.selected == true})
//        {
//            businessInfo = businessInfo + "<br>" + business.name
//        }
        
        msgComposer.body = businessInfo
        
        self.present(msgComposer, animated: true, completion: nil)
        
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith: MFMailComposeResult, error: Error?)
    {
        self.dismiss(animated: true, completion: nil)
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
extension BusinessMasterController{
    func ConvertToHTMLTable(businessSelected : [Business]) -> String
    {
        var itemCount = 1
        var innerHTML = String()
        let htmlHeader = """
                <!DOCTYPE>
                <HTML>
                    <head>
                    </head>
                    <body>
                        <table>
                        

            """
        let htmlFooter = """
                       
                        </table>
                    </body>
                </HTML>
            """
        
        for business in businessSelected {
            innerHTML += "<tr>"
            innerHTML += "<td> " + String(itemCount) + "</td>"
            //innerHTML += "<td>" + "<img src = " + business.image_url + "height=100 width=100 >"
            innerHTML +=  "<td><a href=" + business.url + ">" +  business.name + "</a>  </td>"
            
            innerHTML += "</tr>"
            itemCount = itemCount + 1
        }
        
        let html  = htmlHeader + innerHTML + htmlFooter
        return html
        
    }
}




