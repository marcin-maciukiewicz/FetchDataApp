import SwiftUI

extension ForecastDetailsView {
    class ViewModel: ObservableObject {
        private let locationId: String
        private let useCases: DependencyContainer.UseCases
        
        @Published var headline: String?
        @Published var forecasts: [WeatherModel.Forecast.Daily]
        @Published var errorMessage: String?
        @Published var isLoading: Bool
        
        init(locationId: String, useCases: DependencyContainer.UseCases) {
            self.locationId = locationId
            self.useCases = useCases
            self.isLoading = false
            self.headline = ""
            self.forecasts = []
        }
        
        func loadForecast() async {
                await set(isLoading: true)
                switch await useCases.getForecast.execute(locationId: locationId) {
                case let .success(forecast):
                    await show(forecast: forecast)
                case let .failure(error):
                    await show(error: error)
                }
                await set(isLoading: false)
        }
        
        @MainActor
        func show(forecast: WeatherModel.Forecast) {
            headline = forecast.headline
            forecasts = forecast.daily.sorted(by: { (lhs: WeatherModel.Forecast.Daily, rhs: WeatherModel.Forecast.Daily) in
                lhs.date < rhs.date
            })
        }
        
        @MainActor
        func show(error: Error) {
            errorMessage = "An error occurred"
        }
        
        @MainActor
        func set(isLoading flag: Bool) {
            isLoading = flag
        }
    }
}

struct ForecastDetailsView: View {
    @ObservedObject var model: ViewModel
    
    var body: some View {
        ScrollView {
            if let errorMessage = model.errorMessage {
                Text("\(errorMessage)")
                    .foregroundStyle(.red)
            }
            
            VStack {
                if let headline = model.headline {
                    Text(headline)
                }
                ForEach(model.forecasts, id: \.date) { data in
                    VStack {
                        Text(data.date, format: .dateTime.year().month().day())
                        if let headline = data.headline {
                            Text(headline)
                        }
                        Text("min temp: \(data.minimumTemperature)")
                        Text("max temp: \(data.maximumTemperature)")
                        if let additionalInfo = data.additionalInfo {
                            Text("\(additionalInfo)")
                        }
                        if let dayForecast = data.dayForecast {
                            Text("day: \(dayForecast)")
                        }
                        if let nighForecast = data.nighForecast {
                            Text("night: \(nighForecast)")
                        }
                    }
                }
                .redacted(reason: model.isLoading ? .placeholder : [])
            }
        }.task {
            await model.loadForecast()
        }.redacted(reason: model.isLoading ? .placeholder : [])
    }
}

#Preview("Data Loaded") {
    NavigationStack {
        ForecastDetailsView(model: ForecastDetailsView.ViewModel(locationId: "28143", useCases: DependencyContainer.mock().useCases))
    }
}
#Preview("Error") {
    let viewModel = ForecastDetailsView.ViewModel(locationId: "28143", useCases: DependencyContainer.mock().useCases)
    viewModel.show(error: WeatherServiceError.general)
    return ForecastDetailsView(model: viewModel)
}
