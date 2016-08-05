import Foundation

struct Helpers {

    func uploadAsset(name: String, revision: String, filePath: String? = nil) {
        var path: String
        if let filePath = filePath {
            path = filePath
        } else {
            path = "\(Environment().currentDirectory()!)/\(name).framework.zip"
        }

        do
        {
            Rome().addAsset(name, revision: revision, path: path)
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch {
            print(error)
        }
        
    }
}