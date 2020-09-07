import UIKit

class PokemonCell: UITableViewCell {
    static let identifier = "pokemonCell"
    
    @IBOutlet var pokemonView: PokemonView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedBackgroundView = UIView()
    }
    
    func setup(with pokemon: Pokemon) {
        pokemonView.setup(with: pokemon)
    }
    
    func setSprite(data: Data) {
        pokemonView.setSprite(data: data)
    }
    
    func setNoSprite() {
        pokemonView.setNoSprite()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        pokemonView.setHighlighted(highlighted)
    }
}
