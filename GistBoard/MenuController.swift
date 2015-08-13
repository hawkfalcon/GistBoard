import Cocoa

class MenuController: NSObject {
    
    let menuItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let gistManager = GistManager()
    
    override func awakeFromNib() {
        menuItem.toolTip = "Gist your clipboard"
        menuItem.action = Selector("menuPressed:")
        let appearance = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") ?? "Light"
        var icon = NSImage(named: "GitHub\(appearance).png")
        icon?.setTemplate(true)
        icon?.size = NSMakeSize(16, 16)
        menuItem.image = icon
        menuItem.target = self
    }
    
    func menuPressed(sender: AnyObject?) {
        let paste = NSPasteboard.generalPasteboard()
        if let contents = paste.stringForType(NSPasteboardTypeString) {
            gistManager.createGist(contents)
        }
    }
}
