import Foundation

struct Decoder<T> where T: Decodable {
    
    let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func decode(from data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}
