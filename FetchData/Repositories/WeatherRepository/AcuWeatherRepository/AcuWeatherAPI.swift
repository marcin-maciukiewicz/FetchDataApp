import Foundation

struct AcuWeatherAPIEnpoints {
    static func top50Cities() -> Endpoint { Endpoint(path: "/locations/v1/topcities/50", method: .get) }
    static func tenDayForecast(locationKey: String) -> Endpoint { Endpoint(path: "/forecasts/v1/daily/1day/\(locationKey)", method: .get) }
}

struct AcuWeatherAPI {
    
    let networkProvider: NetworkProvider
    
    func topCities() async throws -> [AcuWeatherAPIModel.Location] {
        let endpoint = AcuWeatherAPIEnpoints.top50Cities()
        return try await networkProvider.request(endpoint: endpoint)
    }
    
    func fetchForecast(locationKey: String) async throws -> AcuWeatherAPIModel.Forecast {
        let endpoint = AcuWeatherAPIEnpoints.tenDayForecast(locationKey: locationKey)
        return try await networkProvider.request(endpoint: endpoint)
    }
}



