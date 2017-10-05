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


protocol  LocationSearchPresenter {
   weak var locationDelegate:LocationDataSourceDelegate?{get set}
    var viewController :  UIViewController{set get}
     func loadData()
}


class LocationSearchPresenterImpl: NSObject,  LocationSearchPresenter {
    
    private var search:MKLocalSearch? =  nil
    
    var viewController =  UIViewController()
    var searchCompleter = MKLocalSearchCompleter()
    
    var places = [MKLocalSearchCompletion]()
    
    weak var locationDelegate:LocationDataSourceDelegate?
    //weak var businessDelegate: LocationSearchedDelegate?
    //fileprivate var modelLayer : ModelLayer
    fileprivate var businessCellMaker : DependencyRegistry.BusinessCellMaker!
    
   
    
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

extension LocationSearchPresenterImpl:CLLocationManagerDelegate{
    
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
        
        let item = locationAt(index: indexPath)
        
        cell.textLabel?.text = item.title
        
        cell.detailTextLabel?.text = item.subtitle
        
        return cell
    }
    
}

extension LocationSearchPresenterImpl:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let item = locationAt(index: indexPath)
        let request = MKLocalSearchRequest()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        request.naturalLanguageQuery = item.subtitle
        
        
        
        locationDelegate?.popNextController(location : request.naturalLanguageQuery! ,cell : cell)
       
    }
}


extension LocationSearchPresenterImpl:MKLocalSearchCompleterDelegate{
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        places = completer.results
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
}

