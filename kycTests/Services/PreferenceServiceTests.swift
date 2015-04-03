import Foundation
import XCTest
import kyc

public class PreferenceServiceTests : XCTestCase {
    
    var target : PreferenceService!
    
    var boatsRepository = BoatsRepositoryDummy()
    var boatPrefsRepository = BoatPrefsRepositoryDummy()
    var dayPrefsRepository = DayPrefsRepositoryDummy()
    var userRepository=UserRepository()
    var settingRepository=SettingRepository()
    
    public override func setUp() {
        
        self.target = PreferenceService(boatsRepo: self.boatsRepository, boatPrefRepo: self.boatPrefsRepository, dayPrefsRepo: self.dayPrefsRepository, userRepo: self.userRepository, settingRepo: self.settingRepository)
    }
    
    public func test_preference_service_live() {
        
        let expectation = expectationWithDescription("expecting data")
        
        self.target.getPreferences({ (boats, boatPrefs, dayPrefs, user) -> Void in
            println(boats)
            
            expectation.fulfill()
            //
        }, onError: { (message) -> Void in
            //
        })
        
        waitForExpectationsWithTimeout(5.0, handler:nil)
    }
    
    public class BoatsRepositoryDummy: BoatsRepository{
        public var inMemoryRepository = [BoatDao]()
        
        override public func save(boats: [BoatDao]) -> Bool {
            self.inMemoryRepository = boats
            println("saving boats somewhere")
            return true
        }
    }
    
    public class BoatPrefsRepositoryDummy: BoatPrefsRepository{
        public var inMemoryRepository = [BoatPrefDao]()
        
        override public func save(boatPrefs: [BoatPrefDao]) -> Bool {
            self.inMemoryRepository = boatPrefs
            println("saving boats somewhere")
            return true
        }
    }
    
    public class DayPrefsRepositoryDummy: DayPrefsRepository{
        public var inMemoryRepository = [DayPrefDao]()
        
        override public func save(dayPrefs: [DayPrefDao]) -> Bool {
            self.inMemoryRepository = dayPrefs
            println("saving boats somewhere")
            return true
        }
    }
    
    public class UserRepositoryDummy: UserRepository{
        public var inMemoryRepository = UserDao(name:"dd",pwd:"sss")
        
        override public func save(user: UserDao) -> Bool {
            self.inMemoryRepository = user
            println("saving user somewhere")
            return true
        }
    }
    
    public class SettingRepositoryDummy: SettingRepository{
//        public var inMemoryRepository: SettingDao
//        
//        override public func save(setting: SettingDao) -> Bool {
//            self.inMemoryRepository = setting
//            println("saving settings somewhere")
//            return true
//        }
    }
}


