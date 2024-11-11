import Foundation

struct DependencyContainer {
    let useCases: UseCases
    
    private init(services: Services) {
        useCases = UseCases(getLocations: DefaultGetLocationsUseCase(service: services.weather),
                            getForecast: DefaultGetForecastUseCase(service: services.weather))
    }
    
    static func openMeteo() -> DependencyContainer {
        let service = createOpenMeteoService()
        return DependencyContainer(services: DependencyContainer.Services(weather: service))
    }
    
    static func acuWeather(config: NetworkConfig) -> DependencyContainer {
        let service = createAcuWeatherService(config: config)
        return DependencyContainer(services: DependencyContainer.Services(weather: service))
    }
    
    static func mock() -> DependencyContainer {
        let service = createMockService()
        return DependencyContainer(services: DependencyContainer.Services(weather: service))
    }
}

extension DependencyContainer {
    private static func createOpenMeteoService() -> WeatherService {
        let api = OpenMeteoAPI()
        let repository = OpenMeteoRepository(api: api)
        let cache = DefaultCachingService()
        return DefaultWeatherService(respository: repository, cache: cache)
    }
    
    private static func createAcuWeatherService(config: NetworkConfig) -> WeatherService {
        let apiExecutor = DefaultNetworkProvider(config: config)
        let api = AcuWeatherAPI(networkProvider: apiExecutor)
        let respository = AcuWeatherRepository(api: api)
        let cache = DefaultCachingService()
        return DefaultWeatherService(respository: respository, cache: cache)
    }
    
    private static func createMockService() -> WeatherService {
        let urlMap = [
            "/topcities/50": "topCities.json",
            "daily/1day/28143": "oneDayForecast.json",
            "daily/1day/113487": "manyDaysForecast.json"
        ]
        
        let apiExecutor = MockNetworkProvider(urlMap: urlMap)
        let api = AcuWeatherAPI(networkProvider: apiExecutor)
        let respository = AcuWeatherRepository(api: api)
        let cache = DefaultCachingService()
        return DefaultWeatherService(respository: respository, cache: cache)
    }
}
