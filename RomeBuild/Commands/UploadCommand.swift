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
            print("")
        }
        
        let dependenciesToUploadArray = Array(dependenciesToBuild.keys.map { $0 })
        
        if dependenciesToUploadArray.count > 0 {
            for dependency in dependenciesToUploadArray {
                let dependencyPath = "\(Environment().currentDirectory()!)/Carthage/Checkouts/\(dependency)"
                
                print("Checkout project dependency \(dependency)")
                Carthage(["checkout", dependency])
                
                print("Checkout inner dependencies for \(dependency)")
                Carthage(["checkout", "--project-directory", dependencyPath])
                
                print("Building \(dependency) for archive")
                Carthage(["build", "--no-skip-current", "--project-directory", dependencyPath])
                Carthage(["archive", "--output", Environment().currentDirectory()!], path: dependencyPath)
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