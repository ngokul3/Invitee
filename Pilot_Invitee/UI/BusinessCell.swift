//
//  BusinessCell.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 9/16/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

  //  @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    var business: Business!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BusinessCell {
    
    
    func set(name: String) {
        lblName.text = name
       // nameValueLabel.accessibilityValue = name
    }
    
   
}
    




extension BusinessCell {
    func configure(with business: Business) {
       
        self.set(name: business.name)
        
        }
    }
    
    




//MARK: - Helper Methods
extension BusinessCell {
    public static var cellId: String {
        return "BusinessCell"
    }
    
    public static var bundle: Bundle {
        return Bundle(for: BusinessCell.self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: BusinessCell.cellId, bundle: BusinessCell.bundle)
    }
    
    public static func register(with tableView: UITableView) {
        tableView.register(BusinessCell.nib, forCellReuseIdentifier: BusinessCell.cellId)
    }
    
    public static func loadFromNib(owner: Any?) -> BusinessCell {
        return bundle.loadNibNamed(BusinessCell.cellId, owner: owner, options: nil)?.first as! BusinessCell
    }
    
    public static func dequeue(from tableView: UITableView, for indexPath: IndexPath, with business: Business) -> BusinessCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessCell.cellId, for: indexPath) as! BusinessCell
        cell.configure(with: business)
        return cell
    }
}
