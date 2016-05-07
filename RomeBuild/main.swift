import CommandLine
import Foundation
import RomeKit
import Alamofire

let env = NSProcessInfo.processInfo().environment

if let baseUrl = env["ROME_ENDPOINT"], apiKey = env["ROME_KEY"] {
    let bootstrap = RomeKit.Bootstrap.init(baseUrl: baseUrl, apiKey: apiKey)
    bootstrap?.start()
} else {
    print("Environment variables ROME_ENDPOINT & ROME_KEY not set")
}

let cli = CommandLine()
let build = BoolOption(shortFlag: "b",
                           longFlag: "build",
                           required: false,
                           helpMessage: "Fetches builds from Rome server and builds the rest using Carthage")

let platform = MultiStringOption(shortFlag: "p",
                       longFlag: "platform",
                       required: false,
                       helpMessage: "Choose between: osx, ios, watchos, tvos")

let upload = BoolOption(shortFlag: "u",
                        longFlag: "upload",
                        required: false,
                        helpMessage: "Runs the archive command on every repository and uploads the specific version on Rome server")

let help = BoolOption(shortFlag: "h",
                      longFlag: "help",
                      helpMessage: "Gives a list of supported operations")

cli.setOptions(build, platform, upload, help)

do {
    try cli.parse()
    if (build.value) {
        BuildCommand().build(platform.value)
    } else if (upload.value) {
        // WIP
    } else {
        HelpCommand().printHelp()
    }
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}