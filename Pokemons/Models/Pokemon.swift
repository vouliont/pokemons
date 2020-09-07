import Foundation

class Pokemon: Decodable {
    let id: Int
    let name: String
    var baseExperience: Int?
    let height: Int
    let isDefault: Bool
    let weight: Int
    let abilities: [PokemonAbility]
    let forms: [PokemonForm]
    let games: [PokemonGame]
    let heldItems: [PokemonHeldItem]
    let moves: [PokemonMove]
    let species: PokemonSpecies
    let stats: [PokemonStat]
    let types: [PokemonType]
    var imageURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, height, weight, forms, species, stats, types
        case baseExperience = "base_experience"
        case isDefault = "is_default"
        case abilityContainers = "abilities"
        case gameContainers = "game_indices"
        case heldItemContainers = "held_items"
        case moveContainers = "moves"
        case sprites
    }
    
    private enum SpritesKeys: String, CodingKey {
        case other
        case frontDefault = "front_default"
    }
    private enum SpritesOtherKeys: String, CodingKey {
        case officialArtrowk = "official-artwork"
    }
    private enum OfficialArtworkSpriteKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        baseExperience = try? values.decode(Int.self, forKey: .baseExperience)
        height = try values.decode(Int.self, forKey: .height)
        isDefault = try values.decode(Bool.self, forKey: .isDefault)
        weight = try values.decode(Int.self, forKey: .weight)
        abilities = try values.decode([PokemonAbility].self, forKey: .abilityContainers)
        forms = try values.decode([PokemonForm].self, forKey: .forms)
        games = try values.decode([PokemonGame].self, forKey: .gameContainers)
        heldItems = try values.decode([PokemonHeldItem].self, forKey: .heldItemContainers)
        moves = try values.decode([PokemonMove].self, forKey: .moveContainers)
        species = try values.decode(PokemonSpecies.self, forKey: .species)
        stats = try values.decode([PokemonStat].self, forKey: .stats)
        types = try values.decode([PokemonType].self, forKey: .types)
        
        let spritesValues = try values.nestedContainer(keyedBy: SpritesKeys.self, forKey: .sprites)
        let spritesOtherValues = try spritesValues.nestedContainer(keyedBy: SpritesOtherKeys.self, forKey: .other)
        let officialArtworkValues = try spritesOtherValues.nestedContainer(keyedBy: OfficialArtworkSpriteKeys.self, forKey: .officialArtrowk)
        if let imageURL = try? officialArtworkValues.decode(String.self, forKey: .frontDefault) {
            self.imageURL = imageURL
        } else if let imageURL = try? spritesValues.decode(String.self, forKey: .frontDefault) {
            self.imageURL = imageURL
        }
    }
}

