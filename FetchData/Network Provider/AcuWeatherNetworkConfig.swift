import Foundation

struct AcuWeatherNetworkConfig: NetworkConfig {
    let apiBase: String = "https://dataservice.accuweather.com"
    let apiKey: String = "SzcNhrGWYcdrtaIMAFBaZL8NZAQhzym1"
    
    func createRequest(forEndpoint endpoint: Endpoint) -> URLRequest? {
        guard var url = URL(string: "\(apiBase)\(endpoint.path)") else { return nil }
        url = url.appending(queryItems: [URLQueryItem(name: "apikey", value: apiKey)])
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        return request
    }
}
