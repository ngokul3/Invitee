//
//  NotificationCell.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 10/9/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//
import UIKit

class NotificationCell : UITableViewCell{
    fileprivate var presenter : NotificationPresenter!
    
    var businesses: [Business]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
extension NotificationCell {
    func set(businesses: [Business]) {
        self.businesses = businesses
        //lblName.text = name
        
    }
    
    
}


extension NotificationCell {
    func configure(with presenter: NotificationPresenter) {
        
        self.set(businesses: presenter.businesses)
        
    }
}


extension NotificationCell {
    public static var cellId: String {
        return "NotificationCell"
    }
    
    public static var bundle: Bundle {
        return Bundle(for: NotificationCell.self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: NotificationCell.cellId, bundle: NotificationCell.bundle)
    }
    
    public static func register(with tableView: UITableView) {
        tableView.register(NotificationCell.nib, forCellReuseIdentifier: NotificationCell.cellId)
    }
    
    public static func loadFromNib(owner: Any?) -> NotificationCell {
        return bundle.loadNibNamed(NotificationCell.cellId, owner: owner, options: nil)?.first as! NotificationCell
    }
    
//    public static func dequeue(from tableView: UITableView, for indexPath: IndexPath, with business: BusinessCellPresenter) -> BusinessCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessCell.cellId, for: indexPath) as! BusinessCell
//        cell.configure(with: business)
//        return cell
//    }
}
    

