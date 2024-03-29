import Foundation
import UIKit
import CoreData

let SyncData = "com.breezback.kyc.syncData"
let NewBooking = "com.breezback.kyc.newBooking"
let FetchWeather = "com.breezback.kyc.fetchWeather"

private let ManagerSharedInstance = Manager()

class Manager:NSObject {

    class var sharedInstance: Manager {
        
        return ManagerSharedInstance
    }
    
    var user:User?
    
    var isAuthenticated: Bool{
        get{
            return user != nil
        }
    }
}




