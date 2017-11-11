    //
//  TestingPopUpViewController.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 11/5/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import UIKit
import PopupDialog
import MessageUI

class NotificationPopUpViewController: UIViewController ,MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate{
    var businesses = [Business]()
    
    
    @IBOutlet weak var label: UILabel!
    
    // MARK: Actions
    
   
    @IBAction func showImageDialogTapped(_ sender: UIButton) {
        showImageDialog()
    }
    
    @IBAction func showStandardDialogTapped(_ sender: UIButton) {
       // showStandardDialog()
    }
    
    @IBAction func showCustomDialogTapped(_ sender: UIButton) {
        //showCustomDialog()
    }
    
       func showImageDialog(animated: Bool = true) {
        
        // Prepare the popup assets
        let title = "THIS IS THE DIALOG TITLE"
        let message = "This is the message section of the popup dialog default view"
        let image = UIImage(named: "Invite.png")
        
         let popup = PopupDialog(title: title, message: message, image: image)
        
        let buttonOne = CancelButton(title: "CANCEL") {
            self.label.text = "You canceled the Invite."
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
        let testB = Business(name: "tests", rating: 1, image_url: "", selected: true, url: "")
        businesses.append(testB)
        
        sendMailNotification(businessesForMail : businesses)
    }
    
    func messageClicked()
    {
        let testB = Business(name: "tests", rating: 1, image_url: "", selected: true, url: "")
        businesses.append(testB)
        
        sendMSGNotification(businessesForMSG : businesses)
        
    }
}
    
    extension NotificationPopUpViewController{
        func sendMSGNotification(businessesForMSG : [Business]){
            
            if !MFMessageComposeViewController.canSendText(){
                print("SMS services are not available")
                return
            }
            
            let msgComposer = MFMessageComposeViewController()
            msgComposer.messageComposeDelegate = self
            
            
            var businessInfo  = String()
            
            for business in businesses
            {
                businessInfo = businessInfo + "<br>" + business.name
            }
            
            msgComposer.body = businessInfo
            
            self.present(msgComposer, animated: true, completion: nil)
            
            
            
        }
        func sendMailNotification(businessesForMail : [Business]) {
            if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
                return
            }
            let mailComposer = MFMailComposeViewController()
            
            var businessInfo = String()
            
            for business in businesses
            {
                businessInfo = businessInfo + "<p> " + business.name + "</p> <br>"
                
            }
            
            mailComposer.setMessageBody(businessInfo, isHTML: true)
            
            mailComposer.mailComposeDelegate = self
            
            self.present(mailComposer, animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
            
        }
        
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            self.dismiss(animated: true, completion: nil)
        }
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith: MFMailComposeResult, error: Error?)
        {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    /*!
     Displays a custom view controller instead of the default view.
     Buttons can be still added, if needed
     */
//    func showCustomDialog(animated: Bool = true) {
//
//        // Create a custom view controller
//        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
//
//        // Create the dialog
//        let popup = PopupDialog(viewController: ratingVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
//
//        // Create first button
//        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
//            self.label.text = "You canceled the rating dialog"
//        }
//
//        // Create second button
//        let buttonTwo = DefaultButton(title: "RATE", height: 60) {
//            self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
//        }
//
//        // Add buttons to dialog
//        popup.addButtons([buttonOne, buttonTwo])
//
//        // Present dialog
//        present(popup, animated: animated, completion: nil)
//    }


