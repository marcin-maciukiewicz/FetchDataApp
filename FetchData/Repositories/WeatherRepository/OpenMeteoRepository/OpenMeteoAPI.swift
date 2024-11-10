import Foundation
import OpenMeteoSdk

struct OpenMeteoAPI {
    
    struct Location {
        let name: String
        let latitude: Float
        let longitude: Float
    }

    static let predefinedLocations = [
        Location(name:"London", latitude: 51.25, longitude: 0.08),
        Location(name:"Warsaw", latitude: 52.12, longitude: 21.01),
        Location(name:"New York", latitude: 40.45, longitude: 73.58),
        Location(name:"Paris", latitude: 40.45, longitude: 73.58),
        Location(name:"Tokyo", latitude: 35.40, longitude: 139.45)
    ]
    
    var availableLocations: [Location]
    
    init(availableLocations: [Location] = OpenMeteoAPI.predefinedLocations) {
        self.availableLocations = availableLocations
    }
    
    func getLocations() -> [Location] {
        return availableLocations
    }
    
    func oneDayForecast(locationKey: String) async throws -> OpenMeteoAPIModel.Forecast {
        guard let location = availableLocations.first(where: { $0.name == locationKey }) else {
            throw OpenMeteoAPIError.locationNotFound
        }
        
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(location.latitude)&longitude=\(location.longitude)&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,rain_sum,showers_sum,snowfall_sum&format=flatbuffers")!

        let responses = try await WeatherApiResponse.fetch(url: url)

        // The query is about a single location only
        guard let response = responses.first else {
            throw OpenMeteoAPIError.locationNotFound
        }

        let utcOffsetSeconds = response.utcOffsetSeconds
        let daily = response.daily!

        /// Note: The order of weather variables in the URL query and the `at` indices below need to match!
        let data = OpenMeteoAPIModel.Forecast(
            daily: .init(
                time: daily.getDateTime(offset: utcOffsetSeconds),
                weatherCode: daily.variables(at: 0)!.values,
                temperature2mMax: daily.variables(at: 1)!.values,
                temperature2mMin: daily.variables(at: 2)!.values,
                precipitationSum: daily.variables(at: 3)!.values,
                rainSum: daily.variables(at: 4)!.values,
                showersSum: daily.variables(at: 5)!.values,
                snowfallSum: daily.variables(at: 6)!.values
            )
        )

        return data
    }
}
