import Foundation

protocol CachingService {
    func getLocations() -> [WeatherModel.Location]?
    func store(locations: [WeatherModel.Location])
    func getForecast(locationId: String) -> WeatherModel.Forecast?
    func store(forecast: WeatherModel.Forecast, forLocationId: String)
}

struct DefaultCachingService: CachingService {

    private let cache: Cache = Cache<String, [WeatherModel.Location]>()
    private let cacheForecast: Cache = Cache<String, WeatherModel.Forecast>()
    
    func getLocations() -> [WeatherModel.Location]? {
        cache["location"]
    }
    
    func store(locations: [WeatherModel.Location]) {
        cache["location"] = locations
    }
    
    func getForecast(locationId: String) -> WeatherModel.Forecast? {
        cacheForecast[locationId]
    }
    
    func store(forecast: WeatherModel.Forecast, forLocationId locationId: String) {
        cacheForecast[locationId] = forecast
    }
}


private final class Cache<Key: Hashable, Value> {
    private let wrapped = NSCache<WrappedKey, Entry>()

    func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(value: value)
        wrapped.setObject(entry, forKey: WrappedKey(key))
    }

    func value(forKey key: Key) -> Value? {
        let entry = wrapped.object(forKey: WrappedKey(key))
        return entry?.value
    }

    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
}

private extension Cache {
    final class WrappedKey: NSObject {
        let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }

            return value.key == key
        }
    }
}

private extension Cache {
    final class Entry {
        let value: Value

        init(value: Value) {
            self.value = value
        }
    }
}

extension Cache {
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }

            insert(value, forKey: key)
        }
    }
}
