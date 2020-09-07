import UIKit

class PokemonsViewController: UITableViewController, FetchableImage {
    
    // MARK: - Variables
    
    private let pokemonApi = PokemonApi()
    
    private var isLoading = false
    private var lastLoadingError: Error?
    
    private var pokemons = [Pokemon]()
    private var pokemonImages = [Int: Data]()
    private var totalPokemonCount: Int?
    
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPokemonDetails" {
            guard let pokemonDetailsVC = segue.destination as? PokemonDetailsViewController,
                let pokemonCell = sender as? PokemonCell else {
                return
            }
            let pokemonIndex = tableView.indexPath(for: pokemonCell)!.row
            pokemonDetailsVC.pokemon = pokemons[pokemonIndex]
            pokemonDetailsVC.imageData = pokemonImages[pokemonIndex]
            pokemonDetailsVC.transitioningDelegate = self
            pokemonDetailsVC.modalPresentationStyle = .custom
            pokemonDetailsVC.originFrame = view.convert(pokemonCell.frame, to: nil)
        }
    }
    

    // MARK: - Table View Data Source & Table View Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(pokemons.count + 1, totalPokemonCount ?? 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row >= pokemons.count - 5) && (pokemons.count < totalPokemonCount ?? 1) && lastLoadingError == nil {
            // load more data when count of cells is less than/equals 5 to tableView bottom and only in case when it is needed
            loadMorePokemons()
        }
        
        if indexPath.row >= pokemons.count { // one row more for loading cell
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            loadingCell.isLoading = isLoading
            loadingCell.tryAgainButton.addTarget(self, action: #selector(tryLoadDataAgain), for: .touchUpInside)
            return loadingCell
        }
        
        if let pokemonCell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell {
            let pokemon = pokemons[indexPath.row]
            pokemonCell.setup(with: pokemon)
            if let imageData = pokemonImages[indexPath.row] {
                pokemonCell.setSprite(data: imageData)
            } else if let imageURL = pokemon.imageURL {
                fetchImage(from: imageURL) { imageData in
                    guard let data = imageData else {
                        return
                    }
                    DispatchQueue.main.async {
                        // cell is needed to be visible otherwise image will not be set
                        guard let pokemonCell = tableView.cellForRow(at: indexPath) as? PokemonCell else {
                            return
                        }
                        self.pokemonImages[indexPath.row] = data
                        pokemonCell.setSprite(data: data)
                    }
                }
            } else { // no image url
                pokemonCell.setNoSprite()
            }
            
            return pokemonCell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= pokemons.count { // row for loading cell
            return 52
        }
        
        return 132
    }
    
    // MARK: - Helper Functions
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: LoadingCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @objc private func tryLoadDataAgain() {
        loadMorePokemons()
        let loadingCellIndexPath = IndexPath(row: self.pokemons.count, section: 0)
        self.tableView.reloadRows(at: [loadingCellIndexPath], with: .none)
    }
    
    private func loadMorePokemons() {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        
        pokemonApi.fetchPokemons(offset: pokemons.count, limit: 20) { result in
            self.isLoading = false
            
            switch result {
            case .success(data: let (loadedPokemons, totalPokemonCount)):
                self.lastLoadingError = nil
                self.pokemons.append(contentsOf: loadedPokemons)
                self.totalPokemonCount = totalPokemonCount
                
                var loadedPokemonIndexPaths = [IndexPath]()
                for i in 1..<loadedPokemons.count {
                    let row = self.pokemons.count - i
                    loadedPokemonIndexPaths.append(IndexPath(row: row, section: 0))
                }
                if self.pokemons.count < totalPokemonCount {
                    loadedPokemonIndexPaths.append(IndexPath(row: self.pokemons.count, section: 0)) // for next loadingCell
                }
                let oldloadingCellIndexPath = IndexPath(row: self.pokemons.count - loadedPokemons.count, section: 0)
                
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: loadedPokemonIndexPaths, with: .bottom)
                self.tableView.reloadRows(at: [oldloadingCellIndexPath], with: .none)
                self.tableView.endUpdates()
            case .failure(error: let error):
                self.lastLoadingError = error
                let loadingCellIndexPath = IndexPath(row: self.pokemons.count, section: 0)
                self.tableView.reloadRows(at: [loadingCellIndexPath], with: .none)
            }
        }
    }
}

extension PokemonsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalPresentAnimatedTransitioning()
    }
}
