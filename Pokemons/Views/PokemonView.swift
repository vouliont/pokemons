import UIKit

@IBDesignable
class PokemonView: UIView {
    @IBOutlet private var containerView: UIView!
    
    @IBOutlet var noSpriteLabel: UILabel!
    @IBOutlet var spriteImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var abilitiesLabel: UILabel!
    
    @IBOutlet var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageLeftConstraint: NSLayoutConstraint!
    @IBOutlet var imageWidthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        
        self.addSubview(containerView)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
    }
    
    func setup(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalizedFirstLetter()
        
        if pokemon.abilities.count > 0 {
            let abilitiesString = pokemon.abilities
                .map({ $0.name })
                .joined(separator: ", ")
            abilitiesLabel.text = "Abilities: \(abilitiesString)"
        } else {
            abilitiesLabel.text = "Abilities: No Abilities"
        }
        
        spriteImageView.image = nil
        noSpriteLabel.isHidden = true
    }
    
    func setSprite(data: Data) {
        spriteImageView.image = UIImage(data: data)
    }
    
    func setNoSprite() {
        noSpriteLabel.isHidden = false
    }
    
    func setHighlighted(_ highlighted: Bool) {
        if highlighted {
            containerView.backgroundColor = .systemGray3
        } else {
            containerView.backgroundColor = .tertiarySystemGroupedBackground
        }
    }
}
