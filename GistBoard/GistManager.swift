import SwiftHTTP
import SwiftyJSON

class GistManager {
    let url = "https://api.github.com/gists"

    func createGist(content: String) {
        var request = HTTPTask()
        let params: Dictionary<String,AnyObject> = ["public": true, "files": ["gist.txt": ["content":content]]]
        request.requestSerializer = JSONRequestSerializer()
        request.POST(url, parameters: params, completionHandler: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                let json = JSON(data: data)
                if let html_url = json["html_url"].string {
                    self.paste(html_url)
                }
            }
        })
    }
    
    func paste(content: String) {
        let paste = NSPasteboard.generalPasteboard()
        paste.clearContents()
        paste.setString(content, forType: NSPasteboardTypeString)
    }
}