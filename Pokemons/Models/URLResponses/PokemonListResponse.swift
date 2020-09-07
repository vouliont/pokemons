import Foundation

struct PokemonListResponse: Decodable {
    let totalPokemonCount: Int
    let pokemonUrls: [String]
    
    private enum CodingKeys: String, CodingKey {
        case totalPokemonCount = "count"
        case pokemonList = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalPokemonCount = try values.decode(Int.self, forKey: .totalPokemonCount)
        
        let pokemonList = try values.decode([PokemonBlueprint].self, forKey: .pokemonList)
        pokemonUrls = pokemonList.map { $0.url }
    }
}

fileprivate struct PokemonBlueprint: Decodable {
    let url: String
}
