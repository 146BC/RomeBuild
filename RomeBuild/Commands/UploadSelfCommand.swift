import Foundation
import RomeKit

struct UploadSelfCommand {
    
    func upload(productName: String, revision: String, platforms: String?, additionalArguments: [String]) {
        
        if !Cartfile().exists() {
            Carthage(["update", "--no-build"] + additionalArguments)
        } else {
            Carthage(["bootstrap", "--no-build"] + additionalArguments)
        }
        
        print("Building \(productName) for archive")
        
        var buildArchive = ["build", "--no-skip-current"]
        
        if let buildPlatforms = platforms {
            buildArchive.append("--platform")
            buildArchive.append(buildPlatforms)
        }
        buildArchive.appendContentsOf(additionalArguments)
        
        Carthage(buildArchive)
        let status = Carthage(["archive"])
        
        Helpers().uploadAsset(productName, revision: revision, filePath: getFrameworkPath(status))
        print("Upload complete")
        
    }
    
}
