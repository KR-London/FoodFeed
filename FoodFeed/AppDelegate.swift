//
//  AppDelegate.swift
//  FoodFeed
//

import UIKit
import CoreData

let storyLoading = true

//@available(iOS 13.0, *)
@UIApplicationMain



class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
       //let launchedBefore = true
        doIPlaceANewDatestamp()
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        day = ((UserDefaults.standard.object(forKey: "loginRecord") as? [ Date ] )?.count ?? 0 ) % 7 + 1
        
        
            //  clearAllCoreData()
//
//        let filePath = Bundle.main.resourcePath!
//            //        let data = try! String(contentsOfFile: filePath + "/storyline.txt",
//            //                               encoding: String.Encoding.utf8).data(using: .utf8)
//
//        let sourceData = "/Day" + String(day) + ".txt"
//
//        let data = try! String(contentsOfFile: filePath + sourceData,
//                               encoding: String.Encoding.utf8).data(using: .utf8)
//
//            //  let decoder = JSONDecoder()
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        if let parsedData = try! JSONSerialization.jsonObject(with: data!) as? [[String:Any]] {
//            var i = Int32(0)
//            for item in parsedData {
//                let newPost = PostData(context: context)
//
//
//                    // print(item)
//                for (category, value) in item{
//                    newPost.id = i as! Int32
//                        //  print(value)
//                    switch category{
//                        case "day": newPost.day = value as! Int32
//                                //case "id": newPost.id = value as! Int32
//                        case "bigtext": newPost.bigtext = value as? String
//                        case "caption": newPost.caption = value as? String
//                        case "user": newPost.user = value as? String
//                        case "type": newPost.type = value as? String
//                        case "gif":  newPost.gif = value as? String
//                        case "image": newPost.image = value as? String
//                        case "video":  newPost.video = value as? String
//                        case "hashtag": newPost.hashtag = value as? String
//                        case "votea": newPost.votea = value as? String
//                        case "voteb": newPost.voteb = value as? String
//                        case "votec": newPost.votec = value as? String
//                        default: break
//                    }
//
//                }
//                do{
//
//                    print(newPost)
//                    i = i + 1
//                    try  context.save()
//
//                } catch {
//                    print("Error saving context \(error)")
//                }
//            }
            
            
            
        
    if storyLoading == true{
            clearAllCoreData()
            
            let filePath = Bundle.main.resourcePath!
            //        let data = try! String(contentsOfFile: filePath + "/storyline.txt",
            //                               encoding: String.Encoding.utf8).data(using: .utf8)
            
            let sourceData = "/Day" + String(day ) + ".txt"
            
           let data = try! String(contentsOfFile: filePath + sourceData,
                                   encoding: String.Encoding.utf8).data(using: .utf8)
            
            //  let decoder = JSONDecoder()
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            if let parsedData = try! JSONSerialization.jsonObject(with: data!) as? [[String:Any]] {
                var i = Int32(0)
                for item in parsedData {
                    let newPost = PostData(context: context)
                    
                    
                    // print(item)
                    for (category, value) in item{
                        newPost.id = i as! Int32
                        //  print(value)
                        switch category{
                            case "day": newPost.day = value as! Int32
                            //case "id": newPost.id = value as! Int32
                            case "bigtext": newPost.bigtext = value as? String
                            case "caption": newPost.caption = value as? String
                            case "user": newPost.user = value as? String
                            case "type": newPost.type = value as? String
                            case "gif":  newPost.gif = value as? String
                            case "image": newPost.image = value as? String
                            case "video":  newPost.video = value as? String
                            case "hashtag": newPost.hashtag = value as? String
                            case "votea": newPost.votea = value as? String
                            case "voteb": newPost.voteb = value as? String
                            case "votec": newPost.votec = value as? String
                            default: break
                        }
                        
                    }
                    do{
                        
                        print(newPost)
                        i = i + 1
                        try  context.save()
                        
                    } catch {
                        print("Error saving context \(error)")
                    }
                }
     }
            
            UserDefaults.standard.set( ["Guy"],  forKey: "following")
            
            
            
        }
        
    
        if #available(iOS 13.0, *) {}
        else{
        if launchedBefore{
            self.window = UIWindow(frame: UIScreen.main.bounds)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let initialViewController = storyboard.instantiateViewController(withIdentifier: "Feed" ) as! FeedPageViewController
           // let initialViewController = storyboard.instantiateViewController(withIdentifier: "GifFun" )
            self.window?.rootViewController = initialViewController

            self.window?.makeKeyAndVisible()

        }
        else
        {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            self.window = UIWindow(frame: UIScreen.main.bounds)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let initialViewController = storyboard.instantiateViewController(withIdentifier: "profileSetter" ) as! profileCreatorViewController
            self.window?.rootViewController = initialViewController

            //   let nextViewController = storyboard.instantiateViewController(withIdentifier: "newDataInputViewController" )
            //self.window?.rootViewController!.push(nextViewController, animated: true, completion: nil)
            self.window?.makeKeyAndVisible()
//
//            if newTutorial{
//                self.window = UIWindow(frame: UIScreen.main.bounds)
//
//                let storyboard = UIStoryboard(name: "ExtraTutorial", bundle: nil)
//
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "p1" )
//                self.window?.rootViewController = initialViewController
//            }
//            else{
//                // UserDefaults.standard.set(true, forKey: "launchedBefore")
//                self.window = UIWindow(frame: UIScreen.main.bounds)
//
//                let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
//
//                //let initialViewController = storyboard.instantiateViewController(withIdentifier: "o1" )
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "o1" )
//
//                self.window?.rootViewController = initialViewController
//                self.window?.makeKeyAndVisible()
//            }

            }
        }
        
        return true
    }
    // Lock the orientation to Portrait mode
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    // TODO: Re-implement this - my initial prioroty is to get ioS 12 to work - and these 'ios 13 or higher' elements are a distraction
//    @available(iOS 13.0, *)
//    lazy var persistentContainer: NSPersistentCloudKitContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentCloudKitContainer(name: "FoodFeed")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    else
    
    lazy var persistentContainer: NSPersistentContainer = {
        /// The persisitent container for the application. This implementation creates and returns a container, having loaded the store for the application to it. This properoty is optional - since there are legitimte error conditons that could cause the creation of the store to fail,
        
        let container = NSPersistentContainer(name: "FoodFeed")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
                                        if let error = error as NSError?{
                                            // Replace this implementation with code to handle the error appropriately.
                                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                                            /*
                                             Typical reasons for an error here include:
                                             * The parent directory does not exist, cannot be created, or disallows writing.
                                             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                                             * The device is out of space.
                                             * The store could not be migrated to the current model version.
                                             Check the error message to determine what the actual problem was.
                                             */
                                            fatalError("Unresolved error \(error), \(error.userInfo)")

                                        }

        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // FIXME: Step through this to make sure it's still valid
    func doIPlaceANewDatestamp(){
        let now = Date()
        print(Date())
        var loginRecord = UserDefaults.standard.object(forKey: "loginRecord") as? [ Date ] ?? [ Date ]()
        
       
        
        print("login record")
        print(loginRecord)
        
        //loginRecord = [ Date ]()
        
        loginRecord = loginRecord + [now]
        UserDefaults.standard.set(loginRecord, forKey: "loginRecord")

        
        //        if let lastStamp = loginRecord.popLast()
        //        {
        //            if Calendar.current.isDateInToday(lastStamp)
        //            {
        //                loginRecord = loginRecord + [now]
        //                UserDefaults.standard.set(loginRecord, forKey: "loginRecord")
        //            }
        //        }
        
        
        
    }

}

