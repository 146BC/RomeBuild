import Foundation
import RomeKit

struct UploadCommand {
    
    func upload(platforms: String?, additionalArguments: [String]) {
        
        if !Cartfile().exists() {
            Carthage(["update", "--no-build", "--no-checkout"] + additionalArguments)
        } else {
            Carthage(["bootstrap", "--no-build", "--no-checkout"] + additionalArguments)
        }
        
        var dependenciesToBuild = [String:String]()
        let dependencies = Cartfile().load()
        
        for (name, revision) in dependencies {
            print("")
            print(name, revision)
            if Rome().getLatestByRevison(name, revision: revision) == nil {
                dependenciesToBuild[name] = revision
            }
        }
        
        let dependenciesToUploadArray = Array(dependenciesToBuild.keys.map { $0 })
        
        if dependenciesToUploadArray.count > 0 {
            for dependency in dependenciesToUploadArray {
                let dependencyPath = "\(Environment().currentDirectory()!)/Carthage/Checkouts/\(dependency)"
                
                print("Checkout project dependency \(dependency)")
                Carthage(["checkout", dependency, "--no-use-binaries"] + additionalArguments)
                
                print("Checkout inner dependencies for \(dependency)")
                Carthage(["bootstrap", "--no-build", "--project-directory", dependencyPath] + additionalArguments)
                
                print("Building \(dependency) for archive")
                
                var buildArchive = ["build", "--no-skip-current", "--project-directory", dependencyPath]
                
                if let buildPlatforms = platforms {
                    buildArchive.append("--platform")
                    buildArchive.append(buildPlatforms)
                }
                
                buildArchive.appendContentsOf(additionalArguments)
                
                Carthage(buildArchive)
                let status = Carthage(["archive", "--output", Environment().currentDirectory()!]+additionalArguments, path: dependencyPath)
                Helpers().uploadAsset(dependency, revision: dependenciesToBuild[dependency]!, filePath: getFrameworkPath(status))
            }
        }
        
        print("Upload complete")
        
    }
    
}
