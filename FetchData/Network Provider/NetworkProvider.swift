import Foundation

enum NetworkProviderError: Error {
    case general
    case invalidServerResponse
    case invalidResponseData(error: Error?)
    case invalidResponseStatusCode(responseCode: Int)
    case unauthorized
    case resourceNotFound
}

protocol NetworkProvider {
    func request<T>(endpoint: Endpoint) async throws -> T where T: Decodable
}
