import Foundation
import Quick
import Nimble

@testable import FetchData

class ForecastDetailsViewModelSpec: AsyncSpec {
    override class func spec() {
        describe("ForecastDetailsViewModel") {
            @TestState var viewModel: ForecastDetailsView.ViewModel!
            @TestState var getForecastUseCase: MockGetForecastUseCase!
            
            beforeEach {
                getForecastUseCase = MockGetForecastUseCase()
                let useCases = DependencyContainer.UseCases(getLocations: MockGetLocationsUseCase(result: .failure(MockError.testError)),
                                                            getForecast: getForecastUseCase)
                viewModel = ForecastDetailsView.ViewModel(locationId: "TestLocationId", useCases: useCases)
            }
            
            describe("loadForecast") {
                context("when used") {
                    beforeEach {
                        getForecastUseCase.result = .failure(MockError.testError)
                        await viewModel.loadForecast()
                    }
                    
                    it("calls use case with correct locationId") {
                        expect(getForecastUseCase.wasCalledWithLocationId).to(equal("TestLocationId"))
                    }
                }
                context("when use case returns successful") {
                    beforeEach {
                        let dailyData = (0..<3).map { WeatherModel.Forecast.Daily(date: Date().addingTimeInterval(-TimeInterval($0)*3600),
                                                                                  headline: "daily headline",
                                                                                  minimumTemperature: "10.0",
                                                                                  maximumTemperature: "12.0",
                                                                                  dayForecast: nil,
                                                                                  nighForecast: nil,
                                                                                  additionalInfo: nil) }
                        let data = WeatherModel.Forecast(headline: "Summary Headline", daily: dailyData)
                        getForecastUseCase.result = .success(data)
                        await viewModel.loadForecast()
                    }
                    
                    it("doesn't show error") {
                        expect(viewModel.errorMessage).to(beNil())
                    }
                    it("presents headline") {
                        expect(viewModel.headline).to(equal("Summary Headline"))
                    }
                    it("presents 3 forecasts") {
                        expect(viewModel.forecasts.count).to(equal(3))
                    }
                    it("presents forecasts in ascending order by date") {
                        let f = viewModel.forecasts
                        expect(f[0].date < f[1].date).to(beTrue())
                        expect(f[1].date < f[2].date).to(beTrue())
                    }
                    it("doesn't show loading state") {
                        expect(viewModel.isLoading).to(equal(false))
                    }
                }
                
                context("when use case failed with error") {
                    beforeEach {
                        getForecastUseCase.result = .failure(MockError.testError)
                        await viewModel.loadForecast()
                    }
                    
                    it("shows error message") {
                        expect(viewModel.errorMessage).to(equal("An error occurred"))
                    }
                    it("doesn't show loading state") {
                        expect(viewModel.isLoading).to(equal(false))
                    }
                }
            }
        }
    }
}
