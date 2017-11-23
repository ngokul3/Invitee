//

//
//  Created by Demo on 8/2/16.
//  Copyright © 2016 Illuminated Bits LLC. All rights reserved.
//

import UIKit
import MapKit

typealias LocationNameBlock = (String?)-> Void
//typealias JSONDictionary = [String:Any]

protocol LocationDataSourceDelegate: class{
    
    func refreshData()
    func popNextController(location : String)
    func SearchBusiness()
}

protocol LocationSearchedDelegate: class{
    func loadBusinessForLocation( selectedLocation: String)
}


protocol  LocationSearchPresenter {
   weak var locationDelegate:LocationDataSourceDelegate?{get set}
    var viewController :  UIViewController{set get}
     func loadData()
}


class LocationSearchPresenterImpl: NSObject,  LocationSearchPresenter, CLLocationManagerDelegate {
    
    
    var viewController =  UIViewController()
    var searchCompleter = MKLocalSearchCompleter()
    
    var places = [MKLocalSearchCompletion]()
    
    weak var locationDelegate:LocationDataSourceDelegate?
    let locationManager = CLLocationManager()

    override init() {

        super.init()
        searchCompleter.delegate = self

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
    }
    
    func locationCount() -> Int {
        return places.count
    }
    
    func locationAt(index:IndexPath) -> MKLocalSearchCompletion{
        
        return places[index.row]
        
    }
    
}

extension LocationSearchPresenterImpl{

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch  status {
        case .authorizedAlways, .authorizedWhenInUse:

            manager.requestLocation()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {return}
        searchCompleter.region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 150, 150)
        
        getCurrentAddress(currentLocation: currentLocation, completion: { defaultLocation in
            
            guard let _ = defaultLocation?.description else {return }
            self.locationDelegate?.popNextController(location : defaultLocation!)
            
        })
    }

    func getCurrentAddress(currentLocation : CLLocation,completion:  @escaping LocationNameBlock)
    {
         let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            
            if let _ = error {
                
                completion(nil)
                
            } else {
                
                let placeArray = placemarks
                
                var placeMark: CLPlacemark!
                var locationName = ""
                
                placeMark = placeArray?[0]
                
                
                if placeMark.locality != nil {
                    locationName = placeMark.locality! + ", "
                }
                if placeMark.administrativeArea != nil {
                    locationName = locationName + placeMark.administrativeArea! + ", "
                }
                if placeMark.country != nil {
                    locationName = locationName + placeMark.country!
                }
                completion(locationName)
                
            }
        
        }
    }
}
extension LocationSearchPresenterImpl:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = locationCount()
        
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item =  locationAt(index: indexPath)
        
        cell.textLabel?.text = item.title
        
        cell.detailTextLabel?.text = item.subtitle
        
        return cell
    }
    
}

extension LocationSearchPresenterImpl:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let item = locationAt(index: indexPath)
         places.removeAll()
        locationDelegate?.popNextController(location : item.title)
       
    }
}


extension LocationSearchPresenterImpl:MKLocalSearchCompleterDelegate{
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        places = completer.results.filter({$0.subtitle.isEmpty == true})
          loadData()
        
    }
    
    func loadData()
    {
        locationDelegate?.refreshData()
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
    }
}


extension LocationSearchPresenterImpl:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
         locationDelegate?.SearchBusiness()
    }
    
}



