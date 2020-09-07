import Foundation

class BaseApi {
    let baseURL = "https://pokeapi.co/api/v2/"
    
    enum Result<T> {
        case success(data: T)
        case failure(error: Error)
    }
    
    enum ApiError: Error {
        case networkingConnection
        case parsingData
    }
}
