import UIKit
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    lazy var dataBaseStack = DataBaseStack(modelName: "ToDoList")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        dataBaseStack.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        dataBaseStack.saveContext()
    }
}

