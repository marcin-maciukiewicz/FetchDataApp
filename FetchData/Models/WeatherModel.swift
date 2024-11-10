import Foundation

struct WeatherModel {
    struct Location: Identifiable, Hashable {
        let id: String
        let locationName: String
    }
    
    struct Forecast {
        struct Daily {
            let date: Date
            let headline: String?
            let minimumTemperature: String
            let maximumTemperature: String
            let dayForecast: String?
            let nighForecast: String?
            let additionalInfo: String?
        }
        
        let headline: String?
        let daily: [Daily]
    }
}
