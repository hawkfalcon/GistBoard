import SwiftHTTP
import SwiftyJSON

class GistManager {
    let url = "https://api.github.com/gists"

    func createGist(content: String) {
        let params: Dictionary<String,AnyObject> = ["public": true, "files": ["gist.txt": ["content":content]]]
        do {
            let opt = try HTTP.POST(url, parameters: params, headers: nil, requestSerializer: JSONParameterSerializer())
            opt.start { response in
                let json = JSON(data: response.data)
                if let html_url = json["html_url"].string {
                    self.paste(html_url)
                }
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    func paste(content: String) {
        let paste = NSPasteboard.generalPasteboard()
        paste.clearContents()
        paste.setString(content, forType: NSPasteboardTypeString)
    }
}