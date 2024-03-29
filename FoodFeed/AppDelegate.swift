//
//  AppDelegate.swift
//  FoodFeed
//

import UIKit
import CoreData

let storyLoading = true
var day = Int()

//@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?
    
 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
            // MARK: Toggle here if you want to test the onboarding without manually resetting
        //let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
      //  let launchedBefore = true
    
      
        day = (((UserDefaults.standard.object(forKey: "loginRecord") as? [ Date ] )?.count ?? 1)  % 7 )
        
//        if day == 0 {
//            day = 1
//        }
        
        doIPlaceANewDatestamp()
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
     // let day = 1
      //    day = 5
        UserDefaults.standard.set(day, forKey: "Day")
   
    if storyLoading == true{
            clearAllCoreData()
            
            let filePath = Bundle.main.resourcePath!
   
            let sourceData = "/Day" + String(day ) + ".txt"
            
           let data = try! String(contentsOfFile: filePath + sourceData,
                                   encoding: String.Encoding.utf8).data(using: .utf8)

            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            if let parsedData = try JSONSerialization.jsonObject(with: data!) as? [[String:Any]] {
                var i = Int32(0)
                for item in parsedData {
                    let newPost = PostData(context: context)
                    for (category, value) in item{
                        newPost.id = i 
                        switch category{
                            case "day": newPost.day = value as! Int32
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
                   // do{
                        i = i + 1
                        try  context.save()
                        
//                    } catch {
//                        print("Error saving context \(error)")
//                    }
                }
     }
        }
        catch{
                print("Error saving context \(error)")
        }
            
            UserDefaults.standard.set( ["Guy"],  forKey: "following")
            
            
            
        }
        
    
        if #available(iOS 13.0, *) {}
        else{
        if launchedBefore{
            self.window = UIWindow(frame: UIScreen.main.bounds)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let initialViewController = storyboard.instantiateViewController(withIdentifier: "Feed" ) as! FeedPageViewController
            self.window?.rootViewController = initialViewController
            self.window?.isUserInteractionEnabled = true
            self.window?.makeKeyAndVisible()

        }
        else
        {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            self.window = UIWindow(frame: UIScreen.main.bounds)

            //let storyboard = UIStoryboard(name: "Main", bundle: nil)

            //let initialViewController = storyboard.instantiateViewController(withIdentifier: "profileSetter" ) as! profileCreatorViewController
            self.window?.rootViewController = profileCreatorViewController(frame: UIScreen.main.bounds)
            self.window?.isUserInteractionEnabled = true
            self.window?.makeKeyAndVisible()

            }
        }
        
        DispatchQueue.main.async {
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documents.appendingPathComponent("userSetProfilePic.jpeg")
            
            
            if let name = UserDefaults.standard.object(forKey: "userName")
            {
                var pic = UIImage()
                
                if let data = try? Data(contentsOf: url){
                    pic = UIImage(data: data)!
                }
                
                let personality0 = UserDefaults.standard.object(forKey: "userPersonality0") as? String ?? "Sweet"
                let personality1 = UserDefaults.standard.object(forKey: "userPersonality1") as? String ?? "Lovely"
                let personality2 = UserDefaults.standard.object(forKey: "userPersonality2") as? String ?? "Adorable"
                
                
                let human = User(name: name as! String ,
                                 profilePic: pic, personalQualities: [
                                    personality0 ,
                                    personality1,
                                    personality2])
                botUser.human = human
            }
        }
        
        return true
    }
    
    

 //   window = UIWindow(frame: windowScene.coordinateSpace.bounds)
///    window?.windowScene = windowScene
 //   self.window?.rootViewController = profileCreatorViewController(frame: windowScene.coordinateSpace.bounds)
    
    
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
        var loginRecord = UserDefaults.standard.object(forKey: "loginRecord") as? [ Date ] ?? [ Date ]()
        
        loginRecord = loginRecord + [now]
        UserDefaults.standard.set(loginRecord, forKey: "loginRecord")
    }

}

