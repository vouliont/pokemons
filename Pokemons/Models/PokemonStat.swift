import Foundation

struct PokemonStat: Decodable {
    let baseStat: Int
    let effort: Int
    private let stat: NameAPISource
    var name: String { stat.name }
    
    private enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}
