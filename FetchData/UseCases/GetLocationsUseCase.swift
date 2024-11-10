protocol GetLocationsUseCase {
    func execute() async -> Result<[WeatherModel.Location], Error>
}

struct DefaultGetLocationsUseCase: GetLocationsUseCase {
    let service: WeatherService
    
    func execute() async -> Result<[WeatherModel.Location], Error> {
        do {
            let result = try await service.getLocations()
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
