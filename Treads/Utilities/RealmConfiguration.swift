//
//  RealmConfiguration.swift
//  Treads
//
//  Created by Ben Gauger on 2/16/23.
//

import Foundation
import RealmSwift


class RealmConfiguration {
    
    static var runDataConfig: Realm.Configuration {
        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIG)
        let config = Realm.Configuration(
        fileURL: realmPath,
        schemaVersion: 0) { migration, oldSchemaVersion in
            if (oldSchemaVersion < 0) {
                
            }
        }
        return config
    }
    
    
    
}

