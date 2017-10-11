//
//  NotificationPresenter.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 10/7/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import Foundation

protocol NotificationPresenter{
    var businesses : [Business]{get set}
    func BusinessToBeNotified(businesses: [Business])
    func Notify()
}


class NotificationPresenterImpl : NotificationPresenter{
    
    var businesses : [Business]
    //var notificationType : NotificationType
    
    init(businesses: [Business]){
        self.businesses = businesses
       // self.notificationType = notificationType
        //self.notificationType.businesses = self.businesses
    }
    func BusinessToBeNotified(businesses: [Business]) {
        self.businesses = businesses
    }
    
    
    
    func Notify() {
        
       
        
       // self.notificationType.sendNotification()
        
    }
    
}
