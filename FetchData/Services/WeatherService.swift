enum WeatherServiceError: Error {
    case wrapped(error: Error)
    case general
}

protocol WeatherService {
    func getLocations() async throws -> [WeatherModel.Location]
    func getForecast(locationId: String) async throws -> WeatherModel.Forecast
}

struct DefaultWeatherService: WeatherService {
    
    let respository: WeatherRepository
    let cache: CachingService
    
    func getLocations() async throws -> [WeatherModel.Location] {
        if let locations = cache.getLocations() {
            return locations
        } else {
            let result = try await respository.getLocations()
            cache.store(locations: result)
            return result
        }
    }
    
    func getForecast(locationId: String) async throws -> WeatherModel.Forecast {
        if let forecast = cache.getForecast(locationId: locationId) {
            return forecast
        } else {
            let result = try await respository.getForecast(locationId: locationId)
            cache.store(forecast: result, forLocationId: locationId)
            return result
        }
    }
    
    
}
