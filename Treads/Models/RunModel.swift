//
//  RunModel.swift
//  Treads
//
//  Created by Ben Gauger on 2/15/23.
//

import Foundation
import RealmSwift


class RunModel: Object {
    @objc dynamic public private(set) var id = ""
    @objc dynamic public private(set) var pace = 0
    @objc dynamic public private(set) var distance = 0.0
    @objc dynamic public private(set) var duration = 0
    @objc dynamic public private(set) var date = NSDate()
    public private(set) var locations = List<Location>()

    override class func indexedProperties() -> [String] {
        return ["pace", "date", "duration"]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.pace = pace
        self.distance = distance
        self.duration = duration
        self.locations = locations
    }
    
    static func addRunToRealm(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
        REALM_QUEUE.sync {
            let run = RunModel(pace: pace, distance: distance, duration: duration, locations: List<Location>())
            do {
                let realm = try Realm(configuration: RealmConfiguration.runDataConfig)
                try realm.write {
                    realm.add(run)
                    try realm.commitWrite()
                }
            }catch{
                debugPrint("Error adding run to realm.\(error.localizedDescription)")
            }
        }
    }
    
    static func getAllRuns() -> Results<RunModel>? {
        
        do{
            let realm = try Realm(configuration: RealmConfiguration.runDataConfig)
            var runs = realm.objects(RunModel.self)
            runs = runs.sorted(byKeyPath: "date", ascending: false)
            return runs
        }catch{
            return nil
        }
        
        
        
    }
    
    
    
    
    
    
}
