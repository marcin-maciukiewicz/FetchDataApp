import Foundation

struct MockNetworkProvider: NetworkProvider {
    
    let urlMap: [String:String]
    
    func request<T>(endpoint: Endpoint) async throws -> T where T: Decodable {
        
        let mockResponseFile = urlMap
            .filter { (key: String, value: String) in
                endpoint.path.contains(key)
            }
            .map({ (key: String, value: String) in
                value
            })
            .first
        
        if let mockResponseFile {
            let url = Bundle.main.url(forResource: mockResponseFile, withExtension: nil)!
            let data = try Data(contentsOf: url)
            return try Decoder<T>().decode(from: data)
        } else {
            throw NetworkProviderError.resourceNotFound
        }
    }
}
