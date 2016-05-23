import Foundation
import RomeKit

struct UploadSelfCommand {
    
    func upload(productName: String, revision: String, platforms: String?) {
        
        if !Cartfile().exists() {
            Carthage(["update", "--no-build", "--no-checkout"])
        } else {
            Carthage(["bootstrap", "--no-build"])
        }
        
        print("Building \(productName) for archive")
        
        var buildArchive = ["build", "--no-skip-current"]
        
        if let buildPlatforms = platforms {
            buildArchive.append("--platform")
            buildArchive.append(buildPlatforms)
        }
        
        Carthage(buildArchive)
        Carthage(["archive"])
        
        Helpers().uploadAsset(productName, revision: revision)
        print("Upload complete")
        
    }
    
}