import Foundation

struct PokemonMove: Decodable {
    private let move: NameAPISource
    var name: String { move.name }
}
