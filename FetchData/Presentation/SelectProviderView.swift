import SwiftUI

extension SelectProviderView {
    class ViewModel: ObservableObject {
        enum Provider: String {
            case acuWeather = "ACU Weather"
            case openMeteo = "OpenMeteo"
            case mock = "Mock"
        }
        
        let providers: [Provider] = [.acuWeather, .openMeteo, .mock]
        
        func useCases(forProvider provider: Provider) -> DependencyContainer.UseCases {
            switch provider {
            case .acuWeather:
                let config = AcuWeatherNetworkConfig()
                return DependencyContainer.acuWeather(config: config).useCases
            case .openMeteo:
                return DependencyContainer.openMeteo().useCases
            case .mock:
                return DependencyContainer.mock().useCases
            }
        }
    }
}

struct SelectProviderView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.providers, id: \.self) { provider in
                NavigationLink(value: provider) {
                    Text(provider.rawValue)
                }
            }
        }
        .navigationDestination(for: ViewModel.Provider.self) { provider in
            LocationsListView(model: LocationsListView.ViewModel(useCases: viewModel.useCases(forProvider: provider)))
        }
    }
}

#Preview {
    SelectProviderView(viewModel: SelectProviderView.ViewModel())
}
