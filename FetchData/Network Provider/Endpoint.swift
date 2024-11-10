enum HTTPMethodType: String {
    case get = "GET"
}

struct Endpoint {
    let path: String
    let method: HTTPMethodType
}
