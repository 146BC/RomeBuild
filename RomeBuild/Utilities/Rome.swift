import Foundation
import RomeKit
import Progress

struct Rome {
    
    func getLatestByRevison(name: String, revision: String) -> Asset? {
        
        var romeAsset: Asset?
        let dispatchGroup = dispatch_group_create()
        let queue = dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT)
        
        dispatch_group_enter(dispatchGroup)
        
        RomeKit.Assets.getLatestAssetByRevision(name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!, revision: revision, queue: queue, completionHandler: { (asset, errors) in
            romeAsset = asset
            if romeAsset != nil {
                print("Found asset on Rome:", romeAsset!.id!)
            } else {
                print("Asset not found in Rome server, added to build list")
            }
            
            dispatch_group_leave(dispatchGroup)
        })
        
        dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER)
        
        return romeAsset
    }
    
    func addAsset(name: String, revision: String, path: String) {
        
        let dispatchGroup = dispatch_group_create()
        let queue = dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT)
        
        dispatch_group_enter(dispatchGroup)
        
        guard let data = NSData(contentsOfFile: path) else {
            print("File not found")
            return
        }

        var progressBar = ProgressBar(count:100)
        var currentProgress = 0
        
        RomeKit.Assets.create(name, revision: revision, data: data, queue: queue, progress: { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
            
            let currentPercent = Int(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100)

            while currentProgress < currentPercent {
                progressBar.next()
                currentProgress += 1
            }

            //print(currentPercent, "%")
            
            }, completionHandler: { (asset, error) in

                for _ in currentProgress...100 {
                    progressBar.next()
                }
                
                if let asset = asset {
                    print("Asset created on Rome server:", asset.id!)
                }
                
                dispatch_group_leave(dispatchGroup)
                
        })
        
        dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER)
        
    }
    
}