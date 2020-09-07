import Foundation

struct PokemonType: Decodable {
    let slot: Int
    private let type: NameAPISource
    var name: String { type.name }
}
