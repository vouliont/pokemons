import UIKit

class LoadingCell: UITableViewCell {
    static let identifier = "loadingCell"
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var tryAgainButton: UIButton!
    
    var isLoading: Bool = false {
        didSet {
            tryAgainButton.isHidden = isLoading
            if isLoading {
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorView.stopAnimating()
            }
        }
    }
    
}
