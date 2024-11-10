import Foundation

struct DefaultNetworkProvider: NetworkProvider {
    private let config: NetworkConfig

    init(config: NetworkConfig) {
        self.config = config
    }

    func request<T>(endpoint: Endpoint) async throws -> T where T: Decodable {
        guard let request = config.createRequest(forEndpoint: endpoint) else {
            throw NetworkProviderError.general
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkProviderError.invalidServerResponse
        }
        switch httpResponse.statusCode {
        case 200...299:
            do {
                return try Decoder<T>().decode(from: data)
            } catch {
                throw NetworkProviderError.invalidResponseData(error: error)
            }
        case 401:
            throw NetworkProviderError.unauthorized
        case 404:
            throw NetworkProviderError.resourceNotFound
        default:
            throw NetworkProviderError.invalidResponseStatusCode(responseCode: httpResponse.statusCode)
        }
    }
}
