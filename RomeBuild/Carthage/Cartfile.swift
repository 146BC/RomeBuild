import Foundation
import Regex

struct Cartfile {
    
    func exists() -> Bool {
        guard let filePath = cartfilePath() else {
            return false
        }
        
        return NSFileManager.defaultManager().fileExistsAtPath(filePath)
    }
    
    func load() -> [String:String] {
        var dependencies = [String:String]()
        
        if let filePath = cartfilePath(), cartfileContents = try? String.init(contentsOfFile: filePath) {
            dependencies = parseFile(cartfileContents)
        }
        
        return dependencies
    }
    
    private func cartfilePath() -> String? {
        guard let currentDirectory = Environment().currentDirectory() else {
            return nil
        }
        
        return currentDirectory + "/Cartfile.resolved"
    }
    
    private func parseFile(contents: String) -> [String:String] {
        var dependencies = [String:String]()
        
        contents.enumerateLines { (line, stop) in
            
            let fvRegex = Regex("\"\\s*(.*?)\\s*\"")
            
            let matches = fvRegex.allMatches(line)
            if let framework = matches[0].captures.first!, version = matches[1].captures.first! {
                if let frameworkName = framework.componentsSeparatedByString("/").last {
                    let cleanedFramework = frameworkName.stringByReplacingOccurrencesOfString(".git", withString: "")
                    dependencies[cleanedFramework] = version
                }
            }
                
        }
        
        return dependencies
    }
    
}