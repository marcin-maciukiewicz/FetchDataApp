struct AcuWeatherRepository: WeatherRepository {
    
    let api: AcuWeatherAPI
    
    func getLocations() async throws -> [WeatherModel.Location] {
        let result: [AcuWeatherAPIModel.Location]
        do {
            result = try await api.topCities()
        } catch {
            throw WeatherServiceError.wrapped(error: error)
        }
        
        return result.map({ (location: AcuWeatherAPIModel.Location) in
            WeatherModel.Location(id: location.key, locationName: location.englishName)
        })
    }
    
    func getForecast(locationId: String) async throws -> WeatherModel.Forecast {
        let forecast: AcuWeatherAPIModel.Forecast
        do {
            forecast = try await api.fetchForecast(locationKey: locationId)
        } catch {
            throw WeatherServiceError.wrapped(error: error)
        }
        
        let headline = forecast.headline.text
        let dailyForecasts = forecast.dailyForecasts.map { (daily: AcuWeatherAPIModel.Forecast.Daily) in
            let minimumTemperature = "\(daily.temperature.minimum.value)"
            let maximumTemperature = "\(daily.temperature.maximum.value)"
            let dayForecast = daily.forecastDay.iconPhrase
            let nighForecast = daily.forecastNight.iconPhrase
            let date = daily.date
            
            return WeatherModel.Forecast.Daily(date: date,
                                               headline: nil,
                                               minimumTemperature: minimumTemperature,
                                               maximumTemperature: maximumTemperature,
                                               dayForecast: dayForecast,
                                               nighForecast: nighForecast,
                                               additionalInfo: nil)
        }
        
        
        return WeatherModel.Forecast(headline: headline, daily: dailyForecasts)
    }
}
