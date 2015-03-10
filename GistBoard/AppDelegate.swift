import Cocoa
import SwiftHTTP

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBar = NSStatusBar.systemStatusBar()
    var statusBarItem : NSStatusItem = NSStatusItem()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusBarItem = statusBar.statusItemWithLength(-1)
        statusBarItem.toolTip = "Gist your clipboard"
        statusBarItem.action = Selector("menuPressed:")
        let appearance = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") ?? "Light"
        var icon = NSImage(named: "GitHub\(appearance).png")
        icon?.size = NSMakeSize(16, 16)
        statusBarItem.image = icon
    }
    
    @IBAction func menuPressed(sender: NSMenuItem) {
        let paste = NSPasteboard.generalPasteboard()
        let contents = paste.stringForType(NSPasteboardTypeString)
        gist(contents!)
    }
    
    func gist(content: String){
        let url = "https://api.github.com/gists"
        let params: Dictionary<String,AnyObject> = ["public": true, "files": ["gist.txt": ["content":content]]]
        var request = HTTPTask()
        request.requestSerializer = JSONRequestSerializer()
        request.POST(url, parameters: params, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                let json = JSON(data: data)
                if let url = json["html_url"].string {
                    self.paste(url)
                }
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
        })
    }
    
    func paste(content: String) {
        let paste = NSPasteboard.generalPasteboard()
        paste.clearContents()
        paste.setString(content, forType: NSPasteboardTypeString)
        
    }
}

