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

class NotificationController: UIViewController
{
    fileprivate var notificationTypeMaker : DependencyRegistry.NotificationTypeMaker!
    fileprivate var presenter : NotificationPresenter!
    
    
   
    
    //fileprivate var notificationType : NotificationType
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    func configure(with presenter: NotificationPresenter, notificationTypeMaker : @escaping DependencyRegistry.NotificationTypeMaker)
    {
        self.notificationTypeMaker = notificationTypeMaker
        self.presenter = presenter
     //   self.notificationType = notificationType
       
    }
}

extension NotificationController{
    @IBAction func btnEmailClick(_ sender: Any) {
        //let x = [Business]()
        notificationTypeMaker(self.presenter.businesses, MailNotification())
        
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func btnMessageClick(_ sender: Any) {
    }
    @IBAction func btnCloseClick(_ sender: Any) {
        
        dismiss(animated:true, completion: nil)
    }
}
