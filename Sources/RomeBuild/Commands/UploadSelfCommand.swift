import Foundation
import RomeKit

struct UploadSelfCommand {
    
    func upload(productName: String, revision: String, platforms: String?, additionalArguments: [String]) {
        
        if !Cartfile().exists() {
            Carthage(["update", "--no-build"]+filterAdditionalArgs(task: "update", args: additionalArguments))
        } else {
            Carthage(["bootstrap", "--no-build"]+filterAdditionalArgs(task: "bootstrap", args: additionalArguments))
        }
        
        print("Building \(productName) for archive")
        
        var buildArchive = ["build", "--no-skip-current"]
        
        if let buildPlatforms = platforms {
            buildArchive.append("--platform")
            buildArchive.append(buildPlatforms)
        }
        buildArchive.append(contentsOf: filterAdditionalArgs(task: "build", args: additionalArguments))
        
        Carthage(buildArchive)
        let status = Carthage(["archive"]+filterAdditionalArgs(task: "archive", args: additionalArguments))
        
        Helpers().uploadAsset(name: productName, revision: revision, filePath: getFrameworkPath(taskStatus: status))
        print("Upload complete")
        
    }
    
}
