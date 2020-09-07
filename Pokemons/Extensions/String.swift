import Foundation

extension String {
    mutating func capitalizeFirstLetter() {
        self = capitalizedFirstLetter()
    }
    
    func capitalizedFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
