import Foundation

struct PokemonGame: Decodable {
    private let game: NameAPISource
    var name: String { game.name }
    
    private enum CodingKeys: String, CodingKey {
        case game = "version"
    }
}
