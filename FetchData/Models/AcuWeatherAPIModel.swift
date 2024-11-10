import Foundation

struct AcuWeatherAPIModel {
    struct Location: Decodable {
        let key: String
        let englishName: String
        
        enum CodingKeys: String, CodingKey {
            case key = "Key"
            case englishName = "EnglishName"
        }
    }
    
    struct Forecast: Decodable {
        
        struct Headline: Decodable {
            let severity: Int
            let text: String
            
            enum CodingKeys: String, CodingKey {
                case severity = "Severity"
                case text = "Text"
            }
        }
        
        struct Daily: Decodable {
            
            struct TemperatureData: Decodable {
                let value: Int
                let unit: String
                
                enum CodingKeys: String, CodingKey {
                    case value = "Value"
                    case unit = "Unit"
                }
            }
            
            struct PartOfDay: Decodable {
                let iconPhrase: String
                let hasPrecipitation: Bool
                let precipitationType: String
                let precipitationIntensity: String
                
                enum CodingKeys: String, CodingKey {
                    case iconPhrase = "IconPhrase"
                    case hasPrecipitation = "HasPrecipitation"
                    case precipitationType = "PrecipitationType"
                    case precipitationIntensity = "PrecipitationIntensity"
                }
            }
            
            struct TemperatureRange: Decodable {
                
                let minimum: TemperatureData
                let maximum: TemperatureData
                
                enum CodingKeys: String, CodingKey {
                    case minimum = "Minimum"
                    case maximum = "Maximum"
                }
            }
            
            let date: Date
            let temperature: TemperatureRange
            let forecastDay: PartOfDay
            let forecastNight: PartOfDay
            
            enum CodingKeys: String, CodingKey {
                case date = "Date"
                case temperature = "Temperature"
                case forecastDay = "Day"
                case forecastNight = "Night"
            }
            
        }
        
        
        let headline: Headline
        let dailyForecasts: [Daily]
        
        enum CodingKeys: String, CodingKey {
            case headline = "Headline"
            case dailyForecasts = "DailyForecasts"
        }
    }
}
