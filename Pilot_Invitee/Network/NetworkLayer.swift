import Foundation
import Alamofire

protocol NetworkLayer {
    func loadFromServer(finished: @escaping (Data) -> Void)
}

class NetworkLayerImpl: NetworkLayer {
    func loadFromServer(finished: @escaping (Data) -> Void) {
          let MY_API_KEY = "Bearer qEjtERYCtGRtYmaELAxisLtdM2TWMsUbLG-wvs0b8KlxIfECiKGRrnY7AKOZwe6Zsz_DehvIAXJtt4jiIrKYjCgyf0Tx4CK_yX0u-6LpOc35By8TiyGlLdElXgqzWXYx"
        
        if let url = URL(string: "https://api.yelp.com/v3/businesses/search?location=Teaneck") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            
            urlRequest.addValue(MY_API_KEY, forHTTPHeaderField: "Authorization")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            Alamofire.request(urlRequest)
                .responseJSON { response in
                    debugPrint(response)
            }
        }
        
        print("loading data from server")
        /*
        Alamofire.request("https://api.yelp.com/oauth2/token")
            .responseJSON
            { response in
                guard let data = response.data else { return }
                
                finished(data)
        }*/
    }
}
