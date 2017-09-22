import Foundation
import RomeKit

struct BuildCommand {
    
    func build(platforms: String?, additionalArguments: [String]) {
        
        if !Cartfile().exists() {
            Carthage(["update", "--no-build", "--no-checkout"]+filterAdditionalArgs(task: "update", args: additionalArguments))
        }
        
        var dependenciesToBuild = [String:String]()
        let dependencies = Cartfile().load()
        
        for (name, revision) in dependencies {
            print(name, revision)
            if let asset = Rome().getLatestByRevison(name: name, revision: revision) {
                self.downloadAndExtractAsset(asset: asset)
                print("Asset extracted to Carthage directory")
                print("")
            } else {
                dependenciesToBuild[name] = revision
            }
        }
        
        let dependenciesToBuildArray = Array(dependenciesToBuild.keys.map { $0 })
        
        if dependenciesToBuildArray.count > 0 {
            var checkoutCommand = ["checkout"]
            checkoutCommand.append(contentsOf: filterAdditionalArgs(task: "checkout", args: additionalArguments))
            checkoutCommand.append(contentsOf: dependenciesToBuildArray)
            Carthage(checkoutCommand)
            
            var buildCommand = ["build"]
            
            if let selectedPlatforms = platforms {
                buildCommand.append("--platform")
                buildCommand.append(selectedPlatforms)
            }
            buildCommand.append(contentsOf: filterAdditionalArgs(task: "build", args: additionalArguments))
            
            buildCommand.append(contentsOf: dependenciesToBuildArray)
            
            Carthage(buildCommand)
        }
        
        print("Build complete")
    }

    private func downloadAndExtractAsset(asset: Asset) {
        
        if let serverUrl = Environment().downloadServer() {
            let downloadUrl = "\(serverUrl)\(asset.name!)/\(asset.revision!)/\(asset.id!).\(asset.file_extension!)"
            print("Downloading asset from:", downloadUrl)
            do
            {
                let data = try Data(contentsOf: URL(string: downloadUrl)!)
                let filePath = "\(Environment().currentDirectory()!)/Carthage/tmp/"
                try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
                
                let zipFile = "\(filePath)\(asset.id!).zip"
                try data.write(to: URL(fileURLWithPath: zipFile), options: .atomicWrite)
                Unzip(zip: zipFile, destination: Environment().currentDirectory()!)
                try FileManager.default.removeItem(atPath: zipFile)
            } catch {
                print(error)
            }
        } else {
            print("Error fetching download server URL")
        }
        
    }

}
