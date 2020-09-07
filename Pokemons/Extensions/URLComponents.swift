import Foundation

extension URLComponents {
    mutating func setQueryItems(_ items: [String: String]) {
        queryItems = items.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
