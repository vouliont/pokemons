import UIKit

class PokemonDetailsViewController: UIViewController, FetchableImage {
    
    // MARK: - IBOutlets
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var pokemonImageView: UIImageView!
    @IBOutlet var pokemonNameLabel: UILabel!
    @IBOutlet var pokemonInfoContainer: UIStackView!
    
    @IBOutlet var baseExperienceContainer: UIStackView!
    @IBOutlet var baseExperienceLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var abilitiesLabel: UILabel!
    @IBOutlet var formsLabel: UILabel!
    @IBOutlet var gamesLabel: UILabel!
    @IBOutlet var heldItemsLabel: UILabel!
    @IBOutlet var movesLabel: UILabel!
    @IBOutlet var speciesLabel: UILabel!
    @IBOutlet var statsLabel: UILabel!
    @IBOutlet var typesLabel: UILabel!
    
    @IBOutlet var pokemonView: PokemonView!
    
    @IBOutlet var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageLeftConstraint: NSLayoutConstraint!
    @IBOutlet var imageMaxWidthConstraint: NSLayoutConstraint!

    
    // MARK: - Variables
    
    var pokemon: Pokemon!
    var imageData: Data? {
        didSet {
            guard let data = imageData else { return }
            image = UIImage(data: data)?.cgImage
        }
    }
    private var image: CGImage?
    var originFrame: CGRect!
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadPokemonImageIfNeeded()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func closeViewController(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    // MARK: - Helper Functions
    
    private func setupUI() {
        pokemonNameLabel.text = pokemon.name.capitalizedFirstLetter()
        
        if let baseExperience = pokemon.baseExperience {
            baseExperienceLabel.text = "\(baseExperience)"
        } else {
            baseExperienceContainer.isHidden = true
        }
        
        heightLabel.text = String(format: "%d dm", pokemon.height)
        weightLabel.text = String(format: "%d hm", pokemon.weight)
        
        let abilitiesString = pokemon.abilities.map { $0.name }.joined(separator: ", ")
        abilitiesLabel.text = abilitiesString.count > 0 ? abilitiesString : "No Abilities"
        
        let formsString = pokemon.forms.map { $0.name }.joined(separator: ", ")
        formsLabel.text = formsString.count > 0 ? formsString : "No Forms"
        
        let gamesString = pokemon.games.map { $0.name }.joined(separator: ", ")
        gamesLabel.text = gamesString.count > 0 ? gamesString : "No Games"
        
        let heldItemsString = pokemon.heldItems.map { $0.name }.joined(separator: ", ")
        heldItemsLabel.text = heldItemsString.count > 0 ? heldItemsString : "No Held Items"
        
        let movesString = pokemon.moves.map { $0.name }.joined(separator: ", ")
        movesLabel.text = movesString.count > 0 ? movesString : "No Moves"
        
        speciesLabel.text = pokemon.species.name
        
        let statsString = pokemon.stats.map { $0.name }.joined(separator: ", ")
        statsLabel.text = statsString.count > 0 ? statsString : "No Stats"
        
        let typesString = pokemon.types.map { $0.name }.joined(separator: ", ")
        typesLabel.text = typesString.count > 0 ? typesString : "No Types"
    }
    
    private func loadPokemonImageIfNeeded() {
        // in case when image has not been fetched and pokemonDetailsVC has been loaded
        guard let imageURL = pokemon.imageURL, image == nil else {
            return
        }
        fetchImage(from: imageURL) { imageData in
            guard let data = imageData else { return }
            DispatchQueue.main.async {
                self.pokemonImageView.image = UIImage(data: data)
            }
        }
    }
    
}


// MARK: - Animated Transitioning Delegate

extension PokemonDetailsViewController: AnimatedTransitioningDelegate {
    func prepareToTransition() {
        pokemonImageView.layer.opacity = 0
        closeButton.layer.opacity = 0
        pokemonNameLabel.layer.opacity = 0
        pokemonInfoContainer.layer.opacity = 0
        
        self.view.layer.cornerRadius = 5
        self.view.frame = originFrame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        pokemonView.setup(with: pokemon)
        if let data = imageData {
            pokemonView.setSprite(data: data)
        }

        self.view.insertSubview(pokemonView, belowSubview: closeButton)
        pokemonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pokemonView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            pokemonView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            pokemonView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
        self.view.layoutIfNeeded()
    }
    
    func performTransitioning() {
        closeButton.layer.opacity = 1
        
        pokemonView.imageTopConstraint.constant = imageTopConstraint.constant
        pokemonView.imageLeftConstraint.constant = finalImageLeftOffset()
        pokemonView.imageWidthConstraint.constant = finalImageWidth()
    }
    
    func performHalfTransitioning() {
        pokemonView.nameLabel.layer.opacity = 0
        pokemonView.abilitiesLabel.layer.opacity = 0
    }
    
    func performSecondHalfTransitioning() {
        pokemonNameLabel.layer.opacity = 1
        pokemonInfoContainer.layer.opacity = 1
    }
    
    func completionOfTransition() {
        if let cgImage = image {
            pokemonImageView.image = UIImage(cgImage: cgImage)
        }
        pokemonImageView.layer.opacity = 1
        pokemonView.removeFromSuperview()
    }
    
    private func finalImageWidth() -> CGFloat {
        let windowWidth = UIScreen.main.bounds.width
        let imageMaxWidth = imageMaxWidthConstraint.constant
        let imageLeft = imageLeftConstraint.constant
        
        return min(imageMaxWidth, windowWidth - 2 * imageLeft)
    }
    
    private func finalImageLeftOffset() -> CGFloat {
        let windowWidth = UIScreen.main.bounds.width
        let imageMaxWidth = imageMaxWidthConstraint.constant
        let imageLeft = imageLeftConstraint.constant
        
        return max(imageLeft, (windowWidth - imageMaxWidth) / 2)
    }
}
