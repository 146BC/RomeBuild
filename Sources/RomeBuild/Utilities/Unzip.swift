import Foundation

@discardableResult
func Unzip(zip: String, destination: String) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/unzip"
    task.currentDirectoryPath = Environment().currentDirectory()!
    task.arguments = ["-q", "-o", "-u", "-d", destination, zip]
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}
