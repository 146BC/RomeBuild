import Foundation
import RomeKit

struct BuildCommand {
    
    func build(platforms: [String]?) {
        
        if !Cartfile().exists() {
            Carthage(["update", "--no-build", "--no-checkout"])
        }
        
        var dependenciesToBuild = [String:String]()
        let dependencies = Cartfile().load()
        
        for (name, revision) in dependencies {
            print(name, revision)
            if !getLatestByRevison(name, revision: revision) {
                dependenciesToBuild[name] = revision
            }
        }
        
        let dependenciesToBuildArray = Array(dependenciesToBuild.keys.map { $0 })
        
        if dependenciesToBuildArray.count > 0 {
            var checkoutCommand = ["checkout"]
            checkoutCommand.appendContentsOf(dependenciesToBuildArray)
            Carthage(checkoutCommand)
            
            var buildCommand = ["build"]
            
            if let selectedPlatforms = platforms {
                buildCommand.append("--platform")
                buildCommand.appendContentsOf(selectedPlatforms)
            }
            
            buildCommand.appendContentsOf(dependenciesToBuildArray)
            
            Carthage(buildCommand)
        }
        
        print("Build complete")
        
    }
    
    private func getLatestByRevison(name: String, revision: String) -> Bool {
        
        var exists = false
        let dispatchGroup = dispatch_group_create()
        let queue = dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT)
        
        dispatch_group_enter(dispatchGroup)
        
        RomeKit.Assets.getLatestAssetByRevision(name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!, revision: revision, queue: queue, completionHandler: { (asset, errors) in
            if let asset = asset {
                exists = true
                print("Found asset on Rome:", asset.id!)
                self.downloadAndExtractAsset(asset)
                print("Asset extracted to Carthage directory")
            } else {
                exists = false
                print("Asset not found in rome, added to build list")
            }
            
            dispatch_group_leave(dispatchGroup)
        })
        
        dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER)
        
        return exists
    }
    
    
    private func downloadAndExtractAsset(asset: Asset) {
        
        if let serverUrl = Environment().downloadServer() {
            let downloadUrl = "\(serverUrl)\(asset.name!)/\(asset.revision!)/\(asset.id!).\(asset.file_extension!)"
            print("Downloading asset from:", downloadUrl)
            do
            {
                let data = try NSData(contentsOfURL: NSURL(string: downloadUrl)!, options: NSDataReadingOptions())
                let filePath = "\(Environment().currentDirectory()!)/Carthage/tmp/"
                try NSFileManager.defaultManager().createDirectoryAtPath(filePath, withIntermediateDirectories: true, attributes: nil)
                
                let zipFile = "\(filePath)\(asset.id!).zip"
                try data.writeToFile(zipFile, options: NSDataWritingOptions.DataWritingAtomic)
                Unzip(zipFile, destination: Environment().currentDirectory()!)
                try NSFileManager.defaultManager().removeItemAtPath(zipFile)
            } catch {
                print(error)
            }
        } else {
            print("Error fetching download server URL")
        }
        
    }

}