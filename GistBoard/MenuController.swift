import Cocoa

class MenuController: NSObject {
    
    let menuItem = NSStatusBar.system().statusItem(withLength: -1)
    let gistManager = GistManager()
    
    override func awakeFromNib() {
        menuItem.toolTip = "Gist your clipboard"
        menuItem.action = #selector(menuPressed)
        let appearance = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
        let icon = NSImage(named: "GitHub\(appearance).png")
        icon?.isTemplate = true
        icon?.size = NSMakeSize(16, 16)
        menuItem.image = icon
        menuItem.target = self
    }
    
    func menuPressed(sender: AnyObject?) {
        let paste = NSPasteboard.general()
        if let contents = paste.string(forType: NSPasteboardTypeString) {
            gistManager.createGist(content: contents)
        }
    }
}
