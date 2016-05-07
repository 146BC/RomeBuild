import Foundation

func Carthage(args: [String]) -> Int32 {
    let task = NSTask()
    task.launchPath = "/usr/local/bin/carthage"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}