import Foundation

struct Helpers {

    func uploadAsset(name: String, revision: String) {
        
        do
        {
            let filePath = "\(Environment().currentDirectory()!)/\(name).framework.zip"
            Rome().addAsset(name, revision: revision, path: filePath)
            try NSFileManager.defaultManager().removeItemAtPath(filePath)
        } catch {
            print(error)
        }
        
    }
    
}