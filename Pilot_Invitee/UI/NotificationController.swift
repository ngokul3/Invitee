//
//  NotificationController.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 10/7/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

protocol NotificationType{
    func sendNotification(businesses : [Business])
}

class NotificationController: UIViewController,MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate
{
    
    
    fileprivate var notificationTypeMaker : DependencyRegistry.NotificationTypeMaker!
    fileprivate var presenter : NotificationPresenter!
    
    var businesses = [Business]()
    
    func configure(with presenter: NotificationPresenter, notificationTypeMaker : @escaping DependencyRegistry.NotificationTypeMaker)
    {
        self.notificationTypeMaker = notificationTypeMaker
        self.presenter = presenter

       
    }
}

extension NotificationController{
    @IBAction func btnEmailClick(_ sender: Any) {
      //  self.sendMailNotification(businesses: self.presenter.businesses)
        
        self.sendMailNotification(businessesForMail: businesses)
      
    }
    
    @IBAction func btnMessageClick(_ sender: Any) {
        
        self.sendMSGNotification(businessesForMSG : businesses)
    }
    @IBAction func btnCloseClick(_ sender: Any) {
        
        self.dismiss(animated:true, completion: nil)
    }
    
    
    
}
extension NotificationController{
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
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith: MFMailComposeResult, error: Error?)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
