import Foundation

func Carthage(args: [String], path: String? = nil) -> Int32 {
    let task = NSTask()
    task.launchPath = "/usr/local/bin/carthage"
    if let path = path {
        task.currentDirectoryPath = path
    }
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}