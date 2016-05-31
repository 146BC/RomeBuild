import Foundation

struct HelpCommand {
    
    func printHelp() {
        print("Commands:")
        print("")
        print("romebuild --build")
        print("Fetches dependencies from a Rome Server & builds the rest using `carthage build`")
        print("")
        print("romebuild --build --platform ios,osx")
        print("Fetches dependencies from a Rome Server & builds the rest using `carthage build --platform ios,osx`")
        print("")
        print("romebuild --upload")
        print("Builds dependencies that are not available on the Rome Server using `carthage build --no-skip-current` and `carthage archive` then uploads every dependency on Rome Server")
        print("")
        print("romebuild --upload --self ProductName Revision")
        print("Builds the current project using `carthage build --no-skip-current` and `carthage archive` then uploads the generated archive on Rome Server")
        print("")
        print("All commands use Cartfile.resolved as a reference, if the file is not present a new one will be generated.")
        print("Important: Environment variables ROME_ENDPOINT & ROME_KEY need to be set")
    }
    
}