import Foundation
import Quick
import Nimble

@testable import FetchData

class SelectProviderViewModelSpec: AsyncSpec {
    override class func spec() {
        describe("SelectProviderViewModel") {
            @TestState var viewModel: SelectProviderView.ViewModel!
            
            beforeEach {
                viewModel = SelectProviderView.ViewModel()
            }
            
            describe("useCases") {
                context("for acuWeather provider") {
                    it("creates use cases") {
                        let useCases = viewModel.useCases(forProvider: .acuWeather)
                        expect(useCases).toNot(beNil())
                    }
                }
                
                context("for openMeteo provider") {
                    it("creates use cases") {
                        let useCases = viewModel.useCases(forProvider: .openMeteo)
                        expect(useCases).toNot(beNil())
                    }

                }
                
                context("for mock provider") {
                    it("creates use cases") {
                        let useCases = viewModel.useCases(forProvider: .mock)
                        expect(useCases).toNot(beNil())
                    }

                }
            }
        }
    }
}
