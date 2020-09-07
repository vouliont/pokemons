import Foundation

class PokemonApi: BaseApi {
    
    private let urlSession = URLSession(configuration: .default)
    
    func fetchPokemons(offset: Int = 0,
                       limit: Int,
                       completionHandler: ((Result<(pokemons: [Pokemon], totalPokemonCount: Int)>) -> Void)? = nil
    ) {
        let queryParams: [String: String] = [
            "offset": "\(offset)",
            "limit": "\(limit)"
        ]
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.setQueryItems(queryParams)
        let url = urlComponents.url!.appendingPathComponent("/pokemon/")
        
        urlSession.dataTask(with: url) { data, response, error in
            guard let data = data else {
                let responseError: Error = error ?? ApiError.networkingConnection
                DispatchQueue.main.async {
                    completionHandler?(.failure(error: responseError))
                }
                return
            }
            
            guard let pokemonListResponse = try? JSONDecoder().decode(PokemonListResponse.self, from: data) else {
                DispatchQueue.main.async {
                    completionHandler?(.failure(error: ApiError.parsingData))
                }
                return
            }
            print("pokemon list loaded")
            var loadingPokemonError: Error?
            var pokemons = [Pokemon?](repeating: nil, count: pokemonListResponse.pokemonUrls.count)
            
            let group = DispatchGroup()
            for index in 0..<pokemonListResponse.pokemonUrls.count {
                group.enter()
                let url = pokemonListResponse.pokemonUrls[index]
                self.fetchPokemonDetails(from: url) { result in
                    switch result {
                    case .success(data: let pokemon):
                        pokemons[index] = pokemon
                    case .failure(error: let error):
                        loadingPokemonError = error
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                if let error = loadingPokemonError {
                    completionHandler?(.failure(error: error))
                } else {
                    let result = (
                        pokemons: pokemons as! [Pokemon],
                        totalPokemonCount: pokemonListResponse.totalPokemonCount
                    )
                    completionHandler?(.success(data: result))
                }
            }
        }
        .resume()
    }
    
    private func fetchPokemonDetails(from urlString: String, completionHandler: ((Result<Pokemon>) -> Void)? = nil) {
        let detailsUrl = URL(string: urlString)!
        urlSession.dataTask(with: detailsUrl) { data, response, error in
            guard let data = data else {
                let responseError = error ?? ApiError.networkingConnection
                completionHandler?(.failure(error: responseError))
                return
            }
            
            if let pokemon = try? JSONDecoder().decode(Pokemon.self, from: data) {
                print("pokemon \(pokemon.id) \(pokemon.name) details loaded")
                completionHandler?(.success(data: pokemon))
            } else {
                completionHandler?(.failure(error: ApiError.parsingData))
            }
        }
        .resume()
    }
    
}
