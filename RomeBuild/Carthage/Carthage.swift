import Foundation
import Regex


private let carthageArguments: Dictionary<String, Dictionary<String, Bool>> = [
    "archive": [
        "--output": true,
        "--project-directory": true,
        "--color": true
    ],
    "bootstrap": [
        "--no-checkout": false,
        "--no-build": false,
        "--verbose": false,
        "--configuration": true,
        "--platform": true,
        "--toolchain": true,
        "--derived-data": true,
        "--use-ssh": false,
        "--use-submodules": false,
        "--no-use-binaries": false,
        "--color": true,
        "--project-directory": true
    ],
    "build": [
        "--configuration": true,
        "--platform": true,
        "--toolchain": true,
        "--derived-data": true,
        "--no-skip-current": false,
        "--color": true,
        "--verbose": false,
        "--project-directory": true
    ],
    "checkout": [
        "--use-ssh": false,
        "--use-submodules": false,
        "--no-use-binaries": false,
        "--color": true,
        "--project-directory": true
    ],
    "fetch": ["--color": true],
    "outdated": [
        "--use-ssh": false,
        "--verbose": false,
        "--color": true,
        "--project-directory": true
    ],
    "update": [
        "--no-checkout": false,
        "--no-build": false,
        "--verbose": false,
        "--configuration": true,
        "--platform": true,
        "--toolchain": true,
        "--derived-data": true,
        "--use-ssh": false,
        "--use-submodules": false,
        "--no-use-binaries": false,
        "--color": true,
        "--project-directory": true
    ]
]

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

func filterAdditionalArgs(task: String, args: [String]) -> [String] {
    var additionalArgs = args
    let allowedArgs = carthageArguments[task]
    if let allowedArgs = allowedArgs {
        var index = additionalArgs.startIndex
        while index <= additionalArgs.endIndex {
            let arg = allowedArgs[additionalArgs[index]]
            if let arg = arg {
                if arg {
                    index += 1
                }
                index += 1
            } else {
                additionalArgs.removeAtIndex(index)
            }
        }
    }
    return additionalArgs
}

func getFrameworkPath(taskStatus: TaskStatus) -> String? {
    if let lastLineOfOutput = taskStatus.standardOutput?.last {
        return Regex("Created (.*framework.zip)$").match(lastLineOfOutput)?.captures[0]
    }
    return nil
}
