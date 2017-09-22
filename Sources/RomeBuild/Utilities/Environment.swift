import Foundation

struct Environment {
    
    let env = ProcessInfo.processInfo.environment
    
    func currentDirectory() -> String? {
        return env["PWD"]
    }
    
    func downloadServer() -> String? {
        return env["ROME_DOWNLOAD"] ?? env["ROME_ENDPOINT"]
    }
}
