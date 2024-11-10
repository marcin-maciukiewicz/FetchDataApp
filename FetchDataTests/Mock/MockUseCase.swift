@testable import FetchData

class MockGetLocationsUseCase: GetLocationsUseCase {
    
    var result: Result<[FetchData.WeatherModel.Location], any Error>
    private(set) var wasCalled: Bool
    
    init(result: Result<[FetchData.WeatherModel.Location], any Error> = .failure(MockError.testError)) {
        self.result = result
        self.wasCalled = false
    }
    
    func execute() async -> Result<[FetchData.WeatherModel.Location], any Error> {
        wasCalled = true
        return result
    }
}

class MockGetForecastUseCase: GetForecastUseCase {
    
    var result: Result<FetchData.WeatherModel.Forecast, any Error>
    private(set) var wasCalledWithLocationId: String?
    
    init(result: Result<FetchData.WeatherModel.Forecast, any Error> = .failure(MockError.testError)) {
        self.result = result
        self.wasCalledWithLocationId = nil
    }
    
    func execute(locationId: String) async -> Result<FetchData.WeatherModel.Forecast, any Error> {
        wasCalledWithLocationId = locationId
        return result
    }
}
