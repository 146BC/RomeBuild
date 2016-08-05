import Foundation

func Carthage(args: [String], path: String? = nil) -> TaskStatus {
    let task = NSTask()
    let standardOutputPipe = NSPipe()
    task.launchPath = "/usr/local/bin/carthage"
    if let path = path {
        task.currentDirectoryPath = path
    }
    task.arguments = args
    task.standardOutput = standardOutputPipe
    task.launch()
    task.waitUntilExit()

    let readHandle = standardOutputPipe.fileHandleForReading
    let data = readHandle.readDataToEndOfFile()
    if let standardOutput = String.init(data: data, encoding: NSUTF8StringEncoding) {
        let lines = standardOutput.characters.split { $0 == "\n" || $0 == "\r\n" }.map(String.init)
        return TaskStatus(status: task.terminationStatus, standardOutput: lines)
    } else {
        return TaskStatus(status: task.terminationStatus, standardOutput: nil)
    }
}

func getFrameworkPath(taskStatus: TaskStatus) -> String? {    
    if let lastLineOfOutput = taskStatus.standardOutput?.last {
        return Helpers().matchesForRegexInText("Created (.*framework.zip)$", text: lastLineOfOutput)?.first
    }
    return nil
}