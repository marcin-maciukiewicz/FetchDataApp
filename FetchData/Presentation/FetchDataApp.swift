import SwiftUI

@main
struct FetchDataApp: App {
    
    let container: DependencyContainer
    
    init() {
        container = .mock()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SelectProviderView(viewModel: SelectProviderView.ViewModel())
            }
        }
    }
}
