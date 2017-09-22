import Foundation
import Regex

struct Cartfile {
    
    func exists() -> Bool {
        guard let filePath = cartfilePath() else {
            return false
        }
        
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    func load() -> [String:String] {
        var dependencies = [String:String]()
        
        if let filePath = cartfilePath(), let cartfileContents = try? String.init(contentsOfFile: filePath) {
            dependencies = parseFile(contents: cartfileContents)
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
            
            let matches = fvRegex.allMatches(in: line)
            if let framework = matches[0].captures.first!, let version = matches[1].captures.first! {
                if let frameworkName = framework.components(separatedBy: "/").last {
                    let cleanedFramework = frameworkName.replacingOccurrences(of: ".git", with: "")
                    dependencies[cleanedFramework] = version
                }
            }
        }
        
        return dependencies
    }
    
}
