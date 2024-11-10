import Foundation

struct OpenMeteoAPIModel {
    struct Forecast {
        let daily: Daily

        struct Daily {
            let time: [Date]
            let weatherCode: [Float]
            let temperature2mMax: [Float]
            let temperature2mMin: [Float]
            let precipitationSum: [Float]
            let rainSum: [Float]
            let showersSum: [Float]
            let snowfallSum: [Float]
        }
    }
}
