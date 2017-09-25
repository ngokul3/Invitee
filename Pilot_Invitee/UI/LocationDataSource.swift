//

//
//  Created by Demo on 8/2/16.
//  Copyright © 2016 Illuminated Bits LLC. All rights reserved.
//

import UIKit
import MapKit

protocol LocationDataSourceDelegate: class{
    
    func refreshData()
    func popNextController(location : String, cell : UITableViewCell)
    
}

protocol LocationSearchedDelegate: class{
    func loadBusinessForLocation( selectedLocation: String)
}




class LocationDataSource:NSObject{
    
    private var search:MKLocalSearch? =  nil
    
    
    var searchCompleter = MKLocalSearchCompleter()
    
    var places = [MKLocalSearchCompletion]()
    
    weak var locationDelegate:LocationDataSourceDelegate?
    //weak var businessDelegate: LocationSearchedDelegate?
    var viewController =  UIViewController()
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        
    }
    
    func locationCount() -> Int {
        return places.count
    }
    
    func locationAt(index:IndexPath) -> MKLocalSearchCompletion{
        
        return places[index.row]
        
    }
    
    
    
    
    
}

extension LocationDataSource:CLLocationManagerDelegate{
    
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
        
        guard let location = locations.first else {return}
        
        searchCompleter.region = MKCoordinateRegionMakeWithDistance(location.coordinate, 150, 150)
        
        
    }
    
}
extension LocationDataSource:UITableViewDataSource{
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = locationCount()
        
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        let item = locationAt(index: indexPath)
        
        cell.textLabel?.text = item.title
        
        cell.detailTextLabel?.text = item.subtitle
        
        return cell
    }
    
}

extension LocationDataSource:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = locationAt(index: indexPath)
        
        
        let request = MKLocalSearchRequest()
        
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        request.naturalLanguageQuery = item.subtitle
        
        
        
        locationDelegate?.popNextController(location : request.naturalLanguageQuery! ,cell : cell)
        // businessDelegate?.loadBusinessForLocation(locationController: self.viewController, selectedLocation : item.subtitle)
        /*let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            guard let response = response else {return}
            guard let item = response.mapItems.first else {return}
            
            item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }*/
    }
}


extension LocationDataSource:MKLocalSearchCompleterDelegate{
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        places = completer.results
        
        locationDelegate?.refreshData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
        
    }
}


extension LocationDataSource:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
        
    }
}

