import Foundation
import Quick
import Nimble

@testable import FetchData

class AcuWeatherAPIModelSpec: QuickSpec {
    override class func spec() {
        describe("AcuWeatherAPIModel") {
            @TestState var decoder: JSONDecoder!
            @TestState var jsonData: Data!
            
            beforeEach {
                decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
            }
            
            describe("Location") {
                context("with valid json input") {
                    beforeEach {
                        let fileUrl = Bundle.testBundle.url(forResource: "topCities", withExtension: "json")
                        jsonData = try Data(contentsOf: fileUrl!)
                    }
                    
                    it("decodes correctly") {
                        let data = try decoder.decode([AcuWeatherAPIModel.Location].self, from: jsonData)
                        expect(data).toNot(beNil())
                        expect(data.count).to(equal(2))
                    }
                }
            }
            
            describe("Forecast") {
                context("with valid json input") {
                    beforeEach {
                        let fileUrl = Bundle.testBundle.url(forResource: "oneDayForecast", withExtension: "json")
                        jsonData = try Data(contentsOf: fileUrl!)
                    }

                    it("decodes correctly") {
                        let data = try decoder.decode(AcuWeatherAPIModel.Forecast.self, from: jsonData)
                        expect(data).toNot(beNil())
                        expect(data.headline.text).to(equal("Thunderstorms Wednesday evening"))
                    }
                }
            }
        }
    }
}
