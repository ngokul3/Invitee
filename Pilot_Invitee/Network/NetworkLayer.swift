import Foundation
import Alamofire

protocol NetworkLayer{
    func loadFromNetwork(location : String, finished: @escaping (Data) -> Void)
}


class NetworkLayerImpl:NetworkLayer{
    
      
    func loadFromNetwork(location: String, finished: @escaping (Data) -> Void) {
        let MY_API_KEY = "Bearer qEjtERYCtGRtYmaELAxisLtdM2TWMsUbLG-wvs0b8KlxIfECiKGRrnY7AKOZwe6Zsz_DehvIAXJtt4jiIrKYjCgyf0Tx4CK_yX0u-6LpOc35By8TiyGlLdElXgqzWXYx"
        
        var locationURL : String
        locationURL = "https://api.yelp.com/v3/businesses/search?location=" + location
        
        locationURL = locationURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        if let url = URL(string: locationURL) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            
            urlRequest.addValue(MY_API_KEY, forHTTPHeaderField: "Authorization")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            Alamofire.request(urlRequest)
                .responseJSON { response in
                    debugPrint(response)
                    
                    guard let data = response.data else { return }
                    
                    finished(data)
                    
            }
        }
        
        print("loading data from server")
        
    }
    
}
