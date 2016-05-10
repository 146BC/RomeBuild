import Foundation
import RomeKit

struct UploadCommand {
    
    func upload() {
        
        if !Cartfile().exists() {
            Carthage(["update", "--no-build", "--no-checkout"])
        } else {
            Carthage(["bootstrap", "--no-build"])
        }
        
        var dependenciesToBuild = [String:String]()
        let dependencies = Cartfile().load()
        
        for (name, revision) in dependencies {
            print(name, revision)
            if Rome().getLatestByRevison(name, revision: revision) == nil {
                dependenciesToBuild[name] = revision
            }
        }
        
        let dependenciesToUploadArray = Array(dependenciesToBuild.keys.map { $0 })
        
        if dependenciesToUploadArray.count > 0 {
            for dependency in dependenciesToUploadArray {
                Carthage(["build", dependency, "--no-skip-current"])
                Carthage(["archive", dependency])
                uploadAsset(dependency, revision: dependenciesToBuild[dependency]!)
            }
        }
        
        print("Upload complete")
        
    }
    
    private func uploadAsset(name: String, revision: String) {
        
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