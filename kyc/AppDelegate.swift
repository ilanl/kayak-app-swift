import UIKit


let coreComponents = TyphoonBlockComponentFactory(assemblies: [CoreComponents()])
let fireLoadDataNotificationKey = "com.kyc.fireLoadDataNotificationKey"
let doneLoadDataNotificationKey = "com.kyc.doneLoadDataNotificationKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var lastSaved:NSDate?

    class var instance:AppDelegate{
        get{
            return UIApplication.sharedApplication().delegate as! AppDelegate
        }
    }
        
    //MARK: AppDelegate functions
    var window:UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let containerViewController = ContainerViewController()
        window!.rootViewController = containerViewController
        window!.makeKeyAndVisible()
        
        self.loadData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadData", name: fireLoadDataNotificationKey, object: nil)
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        return true
    }

    func loadData(){
        
        let forecastService = coreComponents.componentForKey("forecastServiceFactory") as! ForecastService
        
        forecastService.getWeather(7, onSuccess: { forecasts in
            
            let preferenceService = coreComponents.componentForKey("preferenceServiceFactory") as! PreferenceService
            
            preferenceService.getPreferences({ (boats, boatPrefs, dayPrefs, setting) -> Void in
                
                let bookingService = coreComponents.componentForKey("bookingServiceFactory") as! BookingService
                
                bookingService.getBookings(onSuccess: { bookings in
                    
                    self.lastSaved = nil
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(doneLoadDataNotificationKey, object: self)
                    
                }, onError: {error in
                    println(error)
                })
                
            }, onError: { error in
                println(error)
            })
            
        }, onError: { message in
            println(message)
        })
    }
    
    func application(application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("Got token data! \(deviceToken)")
    }
    
    func application(application: UIApplication,didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Couldn’t register: \(error)")
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as! an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
        self.persistData()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as! part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was! inactive. If the application was! previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        if (self.lastSaved != nil)
        {
            let secsFromLastSaved = NSDate().secondsFrom(self.lastSaved!)
            println("secs: \(secsFromLastSaved)")
            if (secsFromLastSaved >= 10){
                self.persistData()
            }
        }
        else if (self.lastSaved == nil){
            self.persistData()
        }
    }
    
    func persistData(){
        
        self.lastSaved = NSDate()
        
        let preferenceService = coreComponents.componentForKey("preferenceServiceFactory") as! PreferenceService
        
        preferenceService.savePreferences({ (boats, boatPrefs, dayPrefs, setting) -> Void in
            
            self.lastSaved = NSDate()
            println("preference saved")
            
            }, onError: { (message) -> Void in
                
                println("handle errors here")
        })
    }


}

