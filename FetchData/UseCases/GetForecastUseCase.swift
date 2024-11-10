protocol GetForecastUseCase {
    func execute(locationId: String) async -> Result<WeatherModel.Forecast, Error>
}

struct DefaultGetForecastUseCase: GetForecastUseCase {
    let service: WeatherService
    
    func execute(locationId: String) async -> Result<WeatherModel.Forecast, Error> {
        do {
            let result = try await service.getForecast(locationId: locationId)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
