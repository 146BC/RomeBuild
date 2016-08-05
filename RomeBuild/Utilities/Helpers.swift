import Foundation

struct Helpers {

    func uploadAsset(name: String, revision: String, filePath: String? = nil) {
        var path: String
        if let filePath = filePath {
            path = filePath
        } else {
            path = "\(Environment().currentDirectory()!)/\(name).framework.zip"
        }

        do
        {
            Rome().addAsset(name, revision: revision, path: path)
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch {
            print(error)
        }
        
    }

    func matchesForRegexInText(regex: String!, text: String!) -> [String]? {

        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matchesInString(text,
                                                options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substringWithRange($0.rangeAtIndex(1))}
        } catch {
            return nil
        }
    }

    
}