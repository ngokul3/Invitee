//
//  BusinessCell.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 9/16/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import UIKit
import SafariServices

typealias UpdateBusinessImageBlock = (UIImage)-> Void



class BusinessCell: UITableViewCell {

    var delegate : BusinessViewDelegate?
    var businessURL = String()
    @IBOutlet weak var imgRating: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgBusiness: UIImageView!
    
    @IBOutlet weak var displayAddress: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func businessInfoClick(_ sender: Any) {
         delegate?.businessInfoClicked(businessInfoURL: businessURL)
    }
   
}

extension BusinessCell {
    func setName(name: String) {
        lblName.text = name
    }
    
    func setBusinessURL(businessURL : String){
        self.businessURL = businessURL
    }
    
    func setRating(rating : Int)
    {
        imgRating.image = ratingImage(forRating: rating)
    }
    
    func setBusinessAddress(businessAddress : [String])
    {
        if(businessAddress.count > 0)
        {
            self.displayAddress.text = businessAddress[0]
        }
        
        if(businessAddress.count > 1)
        {
            self.displayAddress.text =  businessAddress[1].getTruncatedAddress(firstAddress: businessAddress[0], seperator: ", ")
        }
        /*
        if(businessAddress.count > 1)
        {
            let addressLine2 = businessAddress[1].components(separatedBy: ",")

            if(addressLine2.count > 0)
            {
                self.displayAddress.text = self.displayAddress.text! + ", " + addressLine2[0]
            }
        }
        
       */
        
    }
    func ratingImage(forRating rating: Int) -> UIImage? {
        let imageName = "\(rating)Stars"
        return UIImage(named: imageName)
    }
  
    func SetbusinessImage(forBusinessImage businessImageURL : String) {
        
        
         if let _ = URL(string: businessImageURL)
        {
            let businessImageURL = URL(string: businessImageURL)!
            let session = URLSession(configuration: .default)
            
            let downloadPicTask = session.dataTask(with: businessImageURL) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                        
                        if let imageData = data {
                            // Finally convert that Data into an image and do what you wish with it.
                            DispatchQueue.main.async(execute: {
                                
                                self.imgBusiness.image = UIImage(data: imageData)
                            })
                            
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    }else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            downloadPicTask.resume()
            
        }
        }
        
}
    
extension BusinessCell {
    func configure(with presenter: BusinessCellPresenter) {
       
        self.setName(name: presenter.name)
        self.setRating(rating: presenter.rating)
        self.SetbusinessImage(forBusinessImage: presenter.businessImageURL)
        self.setBusinessURL(businessURL: presenter.businessURL)
        self.setBusinessAddress(businessAddress: presenter.businessAddress)
        }
    
    }
    

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
    
    public static func dequeue(from tableView: UITableView, for indexPath: IndexPath, with business: BusinessCellPresenter, businessViewDelegate : BusinessMasterController) -> BusinessCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessCell.cellId, for: indexPath) as! BusinessCell
        cell.delegate = businessViewDelegate
        cell.configure(with: business)
        return cell
    }
    
   
}

extension String{
    
    func getTruncatedAddress(firstAddress : String, seperator : String) -> String
    {
        var shortBusinessAddress = firstAddress
        let addressLine = self.components(separatedBy: ",")
        if(addressLine.count > 0)
        {
           
            shortBusinessAddress =  shortBusinessAddress + seperator + addressLine[0]
        }
        
        return shortBusinessAddress
    }
    
}
