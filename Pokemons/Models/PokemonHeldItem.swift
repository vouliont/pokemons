import Foundation

struct PokemonHeldItem: Decodable {
    private let item: NameAPISource
    var name: String { item.name }
}
