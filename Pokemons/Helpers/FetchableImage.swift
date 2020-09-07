import Foundation

protocol FetchableImage {
    func fetchImage(from urlString: String, completionHandler: @escaping (_ imageData: Data?) -> Void)
    func imageName(for urlString: String) -> String?
}

extension FetchableImage {
    func fetchImage(from urlString: String, completionHandler: @escaping (_ imageData: Data?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let localImageName = self.imageName(for: urlString) else {
                completionHandler(nil)
                return
            }
            
            let localURL = FetchableImageHelper.cachesDirectoryURL.appendingPathComponent(localImageName)
            
            if FileManager.default.fileExists(atPath: localURL.path) {
                let imageData = FetchableImageHelper.loadLocalImage(from: localURL)
                completionHandler(imageData)
            } else {
                guard let url = URL(string: urlString) else {
                    completionHandler(nil)
                    return
                }
                FetchableImageHelper.downloadImage(from: url) { imageData in
                    completionHandler(imageData)
                }
            }
        }
    }
    
    func imageName(for urlString: String) -> String? {
        guard var base64String = urlString.data(using: .utf8)?.base64EncodedString() else {
            return nil
        }
        base64String = base64String.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        guard base64String.count <= 50 else {
            return String(base64String.dropFirst(base64String.count - 50))
        }
        return base64String
    }
}


fileprivate struct FetchableImageHelper {
    private static let urlSession = URLSession(configuration: .ephemeral)
    
    static let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    
    static func loadLocalImage(from url: URL) -> Data? {
        do {
            let imageData = try Data(contentsOf: url)
            return imageData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func downloadImage(from url: URL, completionHandler: @escaping (_ imageData: Data?) -> Void) {
        urlSession.dataTask(with: url) { data, response, error in
            completionHandler(data)
        }
        .resume()
    }
}
