//
//  BusinessCell.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 9/16/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import UIKit

typealias UpdateBusinessImageBlock = (UIImage)-> Void


class BusinessCell: UITableViewCell {

    fileprivate var presenter : BusinessCellPresenter!
    
    @IBOutlet weak var imgRating: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgBusiness: UIImageView!
    
    var business: Business!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnInfoClick(_ sender: Any) {
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BusinessCell {
    func setName(name: String) {
        lblName.text = name
       
    }
    
    func setRating(rating : Int)
    {
        imgRating.image = ratingImage(forRating: rating)
    }
    
    func ratingImage(forRating rating: Int) -> UIImage? {
        let imageName = "\(rating)Stars"
        return UIImage(named: imageName)
    }
  
    func SetbusinessImage(forBusinessImage businessImageURL : String) {
        let businessImageURL = URL(string: businessImageURL)!
        //var businessImage : UIImage?
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: businessImageURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
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
        
     //    imgBusiness.image = businessImage
        
        
    }
    
    
    
    
}
    
extension BusinessCell {
    func configure(with presenter: BusinessCellPresenter) {
       
        self.setName(name: presenter.name)
        self.setRating(rating: presenter.rating)
        self.SetbusinessImage(forBusinessImage: presenter.businessImageURL)
        
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
    
    public static func dequeue(from tableView: UITableView, for indexPath: IndexPath, with business: BusinessCellPresenter) -> BusinessCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessCell.cellId, for: indexPath) as! BusinessCell
        cell.configure(with: business)
        return cell
    }
}
