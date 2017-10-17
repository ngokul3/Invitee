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


protocol NotificationType1{
   // var businesses : [Business]?{get set}
    
    func sendNotification(businesses : [Business])
}


class MailNotification:  UIViewController, NotificationType1, MFMailComposeViewControllerDelegate
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
         // Configure the fields of the interface.
        mailComposer.setToRecipients(["ngokul3@gmail.com"])
        mailComposer.setMessageBody("Hello from California!", isHTML: false)
        
        let  topView = UIApplication.shared.keyWindow?.rootViewController
        
    //   print(topView?.contr)
        mailComposer.mailComposeDelegate = self
        
        topView!.present(mailComposer, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

class MessageNotification:  UIViewController, NotificationType1, MFMessageComposeViewControllerDelegate
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
