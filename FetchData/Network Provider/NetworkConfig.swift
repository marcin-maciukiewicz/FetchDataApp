import Foundation

protocol NetworkConfig {
    func createRequest(forEndpoint endpoint: Endpoint) -> URLRequest?
}
