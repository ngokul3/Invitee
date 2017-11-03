//
//  BusinessCellPresenter.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 10/1/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import Foundation
protocol BusinessCellPresenter{
    var name: String {get}
    var rating : Int {get}
}


class BusinessCellPresenterImpl : BusinessCellPresenter{
    
    var business : Business
    
    init(business : Business)
    {
        self.business = business
    }
    
    var name: String{
        return business.name
    }
    
    var rating : Int{
        return business.rating
    }
    
}
