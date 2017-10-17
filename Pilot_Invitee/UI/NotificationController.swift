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

class NotificationController: UIViewController,MFMailComposeViewControllerDelegate
{
    fileprivate var notificationTypeMaker : DependencyRegistry.NotificationTypeMaker!
    fileprivate var presenter : NotificationPresenter!
    
    func configure(with presenter: NotificationPresenter, notificationTypeMaker : @escaping DependencyRegistry.NotificationTypeMaker)
    {
        self.notificationTypeMaker = notificationTypeMaker
        self.presenter = presenter
       
    }
}

extension NotificationController{
    @IBAction func btnEmailClick(_ sender: Any) {
        self.sendMailNotification(businesses: self.presenter.businesses)
       // notificationTypeMaker(self.presenter.businesses, MailNotification())
        
        //dismiss(animated:true, completion: nil)
    }
    
    @IBAction func btnMessageClick(_ sender: Any) {
    }
    @IBAction func btnCloseClick(_ sender: Any) {
        
        self.dismiss(animated:true, completion: nil)
    }
    
    
    
}
extension NotificationController{
    
    func sendMailNotification(businesses : [Business]) {
        if !MFMailComposeViewController.canSendMail() {
            print("SMS services are not available")
            return
        }
        let mailComposer = MFMailComposeViewController()
        
        mailComposer.setToRecipients(["ngokul3@gmail.com"])
        mailComposer.setMessageBody("Hello from California!", isHTML: false)
        
       // let  topView = UIApplication.shared.keyWindow?.rootViewController
        
        //   print(topView?.contr)
        mailComposer.mailComposeDelegate = self
        
        self.present(mailComposer, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
