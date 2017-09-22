import Foundation
import RomeKit
import Progress

struct Rome {
    
    func getLatestByRevison(name: String, revision: String) -> Asset? {
        
        var romeAsset: Asset?
        let dispatchGroup = DispatchGroup()
        let queue = DispatchQueue(label: "", attributes: .concurrent)
        
        dispatchGroup.enter()
        
        RomeKit.Assets.getLatestAssetByRevision(name: name.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!, revision: revision, queue: queue, completionHandler: { (asset, errors) in
            romeAsset = asset
            if romeAsset != nil {
                print("Found asset on Rome:", romeAsset!.id!)
            } else {
                print("Asset not found in Rome server, added to build list")
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.wait()
        
        return romeAsset
    }
    
    func addAsset(name: String, revision: String, path: String) {
        
        let dispatchGroup = DispatchGroup()
        let queue = DispatchQueue(label: "", attributes: .concurrent)
        
        dispatchGroup.enter()
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("File not found")
            return
        }

        var progressBar = ProgressBar(count:100)
        
        RomeKit.Assets.create(name: name, revision: revision, data: data, queue: queue, progress: { (totalBytesWritten, totalBytesExpectedToWrite) in
            
            let currentPercent = Int(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100)

            progressBar.setValue(currentPercent)
            
            }, completionHandler: { (asset, error) in

                progressBar.setValue(100)
                
                if let asset = asset {
                    print("Asset created on Rome server:", asset.id!)
                }
                
                dispatchGroup.leave()
        })
        
        dispatchGroup.wait()
    }
}
