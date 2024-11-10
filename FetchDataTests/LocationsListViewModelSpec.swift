import Foundation
import Quick
import Nimble

@testable import FetchData

class LocationsListViewModelSpec: AsyncSpec {
    override class func spec() {
        describe("LocationsListViewModel") {
            @TestState var viewModel: LocationsListView.ViewModel!
            @TestState var getLocationsUseCase: MockGetLocationsUseCase!
            
            beforeEach {
                getLocationsUseCase = MockGetLocationsUseCase()
                let useCases = DependencyContainer.UseCases(getLocations: getLocationsUseCase,
                                                            getForecast: MockGetForecastUseCase())
                viewModel = LocationsListView.ViewModel(useCases: useCases)
            }
            
            describe("loadLocations") {
                context("when used") {
                    beforeEach {
                        getLocationsUseCase.result = .failure(MockError.testError)
                        await viewModel.loadLocations()
                    }
                    
                    it("calls use case") {
                        expect(getLocationsUseCase.wasCalled).to(beTrue())
                    }
                }
                
                context("when use case returns successful") {
                    beforeEach {
                        let data = (0..<3).map { WeatherModel.Location(id: "id\($0)", locationName: "Name-\($0)") }
                        getLocationsUseCase.result = .success(data)
                        await viewModel.loadLocations()
                    }
                    it("doesn't show error") {
                        expect(viewModel.errorMessage).to(beNil())
                    }
                    it("stored 3 locations") {
                        expect(viewModel.locations.count).to(equal(3))
                    }
                    it("doesn't show loading state") {
                        expect(viewModel.isLoading).to(equal(false))
                    }
                    it("doesn't filter locations") {
                        expect(viewModel.filteredLocations.count).to(equal(3))
                    }
                }
                
                context("when use case failed with error") {
                    beforeEach {
                        getLocationsUseCase.result = .failure(MockError.testError)
                        await viewModel.loadLocations()
                    }
                    
                    it("shows error message") {
                        expect(viewModel.errorMessage).to(equal("An error occurred"))
                    }
                    it("doesn't show loading state") {
                        expect(viewModel.isLoading).to(equal(false))
                    }
                }
                
                context("when search") {
                    beforeEach {
                        let data = (0..<3).map { WeatherModel.Location(id: "id\($0)", locationName: "Name-\($0)") }
                        getLocationsUseCase.result = .success(data)
                        await viewModel.loadLocations()
                        viewModel.searchText = "0"
                    }
                    it("presents 1 location") {
                        expect(viewModel.filteredLocations.count).to(equal(1))
                    }
                    it("presents expected location") {
                        expect(viewModel.filteredLocations.first?.locationName).to(equal("Name-0"))
                    }
                }
            }
        }
    }
}
