import SwiftUI

extension LocationsListView {
    class ViewModel: ObservableObject {
        
        @Published var locations: [WeatherModel.Location]
        @Published var isLoading: Bool
        @Published var errorMessage: String?
        @Published var searchText = ""
        
        var filteredLocations: [WeatherModel.Location] {
            guard !searchText.isEmpty else { return locations}
            return locations.filter { $0.locationName.lowercased().contains(searchText.lowercased()) }
        }
        
        fileprivate let useCases: DependencyContainer.UseCases
        
        init(useCases: DependencyContainer.UseCases) {
            self.useCases = useCases
            self.locations = (0...10).map { WeatherModel.Location(id: "\($0)", locationName: "Lore Ipsum") }
            self.isLoading = true
            self.errorMessage = nil
        }
        
        func loadLocations() async {
            await set(isLoading: true)
            
            switch await useCases.getLocations.execute() {
            case let .success(locations):
                await show(locations: locations)
            case let .failure(error):
                await show(error: error)
            }
            
            await set(isLoading: false)
        }
        
        @MainActor
        func show(locations: [WeatherModel.Location]) {
            self.locations = locations.sorted(by: { (lhs: WeatherModel.Location, rhs: WeatherModel.Location) in
                lhs.locationName < rhs.locationName
            })
        }
        
        @MainActor
        func show(error: Error) {
            errorMessage = "An error occurred"
            locations = []
        }
        
        @MainActor
        func set(isLoading flag: Bool) {
            isLoading = flag
        }
    }
}

struct LocationInfoView: View {
    let name: String
    
    var body: some View {
        VStack {
            Text(name)
        }
    }
}

struct LocationsListView: View {
    @ObservedObject var model: ViewModel
    
    var body: some View {
        VStack {
            if let errorMessage = model.errorMessage {
                Text("\(errorMessage)")
                    .foregroundStyle(.red)
            }
            
            List {
                ForEach(model.filteredLocations) { city in
                    NavigationLink(value: city) {
                        LocationInfoView(name: city.locationName)
                            .redacted(reason: model.isLoading ? .placeholder : [])
                    }
                    .listRowSeparator(.hidden, edges: .all)
                }
            }
            .navigationDestination(for: WeatherModel.Location.self) { city in
                VStack {
                    ForecastDetailsView(model: ForecastDetailsView.ViewModel(locationId: city.id, useCases: model.useCases))
                        .navigationTitle(city.locationName)
                        .navigationBarTitle(city.locationName, displayMode: .inline)
                }
            }
            .listStyle(.plain)
            .searchable(text: $model.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Location name")
            .textInputAutocapitalization(.never)
        }
        .navigationBarTitle("Locations", displayMode: .large)
        .task {
            await model.loadLocations()
        }
        .padding()
    }
}

#Preview("Data Loaded") {
    NavigationStack {
        LocationsListView(model: LocationsListView.ViewModel(useCases: DependencyContainer.mock().useCases))
    }
}

#Preview("Error") {
    let viewModel = LocationsListView.ViewModel(useCases: DependencyContainer.mock().useCases)
    viewModel.show(error: WeatherServiceError.general)
    return LocationsListView(model: viewModel)
}

#Preview("Search Results") {
    let viewModel = LocationsListView.ViewModel(useCases: DependencyContainer.mock().useCases)
    viewModel.searchText = "D"
    return LocationsListView(model: viewModel)
}
