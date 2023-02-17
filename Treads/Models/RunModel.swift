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
    
//    override class func primaryKey() -> String {
//        return "id"
//    }

    override class func indexedProperties() -> [String] {
        return ["pace", "date", "duration"]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.pace = pace
        self.distance = distance
        self.duration = duration
    }
    
    static func addRunToRealm(pace: Int, distance: Double, duration: Int) {
        REALM_QUEUE.sync {
            let run = RunModel(pace: pace, distance: distance, duration: duration)
            do {
                let realm = try Realm()
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
            let realm = try Realm()
            var runs = realm.objects(RunModel.self)
            runs = runs.sorted(byKeyPath: "date", ascending: false)
            return runs
        }catch{
            return nil
        }
        
        
        
    }
    
    
    
    
    
    
}
