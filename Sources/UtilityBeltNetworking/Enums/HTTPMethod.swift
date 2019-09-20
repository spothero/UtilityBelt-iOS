/// HTTP Methods are a set of request methods to indicate the desired action to be performed for a given resource.
///
/// Sources:
/// - [Mozilla - HTTP Methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods)
public enum HTTPMethod: String, Equatable, Hashable {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}
