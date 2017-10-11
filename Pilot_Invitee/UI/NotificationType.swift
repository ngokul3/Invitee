//
//  NotificationType.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 10/9/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import Foundation
import MessageUI
import UIKit


protocol NotificationType{
   // var businesses : [Business]?{get set}
    
    func sendNotification(businesses : [Business])
}


class MailNotification:  UIViewController, NotificationType, MFMailComposeViewControllerDelegate
{
   // var businesses: [Business]?
    
   
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func sendNotification(businesses : [Business]) {
        if !MFMailComposeViewController.canSendMail() {
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
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

class MessageNotification:  UIViewController, NotificationType, MFMessageComposeViewControllerDelegate
{
     var businesses: [Business]?
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendNotification(businesses : [Business]) {
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
            return
        }
        let msgComposer = MFMessageComposeViewController()
        msgComposer.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        msgComposer.recipients = ["6469428120"]
        msgComposer.body = "Hello from California!"
        
        // Present the view controller modally.
        self.present(msgComposer, animated: true, completion: nil)
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
}
