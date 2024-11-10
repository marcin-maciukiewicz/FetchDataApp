struct OpenMeteoRepository: WeatherRepository {
    
    let api: OpenMeteoAPI
    
    func getLocations() async throws -> [WeatherModel.Location] {
        api.getLocations().map({ (location: OpenMeteoAPI.Location) in
            WeatherModel.Location(id: location.name, locationName: location.name)
        })
    }
    
    func getForecast(locationId: String) async throws -> WeatherModel.Forecast {
        let forecast: OpenMeteoAPIModel.Forecast
        do {
            forecast = try await api.oneDayForecast(locationKey: locationId)
        } catch {
            throw WeatherServiceError.wrapped(error: error)
        }
        
        var dailyForecasts = [WeatherModel.Forecast.Daily]()
        let dailyData = forecast.daily
        for (i, date) in dailyData.time.enumerated() {
            let minimumTemperature = "\(dailyData.temperature2mMin[i].roundToDecimal(1))"
            let maximumTemperature = "\(dailyData.temperature2mMax[i].roundToDecimal(1))"
            
            let weatherCode = dailyData.weatherCode[i]
            let weatherCodeDescription = weatherCodeDescription(weatherCode)
            
            var additionalInfoComponents = [String]()
            
            let precipitationSum = dailyData.precipitationSum[i]
            let rainSum = dailyData.rainSum[i]
            let showersSum = dailyData.showersSum[i]
            let snowfallSum = dailyData.snowfallSum[i]
            
            if !precipitationSum.isZero {
                additionalInfoComponents.append("Precipitation: \(precipitationSum.roundToDecimal(1))")
            }
            if !rainSum.isZero {
                additionalInfoComponents.append("Rain: \(rainSum.roundToDecimal(1))")
            }
            if !showersSum.isZero {
                additionalInfoComponents.append("Showers: \(showersSum.roundToDecimal(1))")
            }
            if !snowfallSum.isZero {
                additionalInfoComponents.append("Snow: \(snowfallSum.roundToDecimal(1))")
            }
            
            let additionalInfo = additionalInfoComponents.joined(separator: "; ")
            
            let element = WeatherModel.Forecast.Daily(date: date,
                                                      headline: weatherCodeDescription,
                                                      minimumTemperature: minimumTemperature,
                                                      maximumTemperature: maximumTemperature,
                                                      dayForecast: nil,
                                                      nighForecast: nil,
                                                      additionalInfo: (additionalInfo.isEmpty ? nil : additionalInfo))
            dailyForecasts.append(element)
        }
        
        return WeatherModel.Forecast(headline: nil, daily: dailyForecasts)
    }
}

func weatherCodeDescription(_ code: Float) -> String? {
    
    switch code.rounded() {
    case 0:
        return "Clear sky"
    case 1,2,3:
        return "Mainly clear, partly cloudy, and overcast"
    case 45, 48:
        return "Fog and depositing rime fog"
    case 51, 53, 55:
        return "Drizzle: Light, moderate, and dense intensity"
    case 56, 57:
        return "Freezing Drizzle: Light and dense intensity"
    case 61, 63, 65:
        return "Rain: Slight, moderate and heavy intensity"
    case 66, 67:
        return "Freezing Rain: Light and heavy intensity"
    case 71, 73, 75:
        return "Snow fall: Slight, moderate, and heavy intensity"
    case 77:
        return "Snow grains"
    case 80, 81, 82:
        return "Rain showers: Slight, moderate, and violent"
    case 85, 86:
        return "Snow showers slight and heavy"
    case 95:
        return "Thunderstorm: Slight or moderate"
    case 96, 99:
        return "Thunderstorm with slight and heavy hail"
    default:
        return nil
    }
}
