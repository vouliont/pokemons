import Foundation

struct PokemonAbility: Decodable {
    private var ability: NameAPISource
    var name: String { ability.name }
}
