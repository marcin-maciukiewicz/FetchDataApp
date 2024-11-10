protocol WeatherRepository {
    func getLocations() async throws -> [WeatherModel.Location]
    func getForecast(locationId: String) async throws -> WeatherModel.Forecast
}
