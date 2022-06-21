//
//  SQLiteConnect.swift
//  ExampleSQLite
//
//  Created by Ian Shen on 6/21/22.
//

import Foundation
import SQLite3

class SQLiteConnect {

    var db : OpaquePointer? = nil

    let sqlitePath : String

    // failable init
    init?(path :String) {
        sqlitePath = path
        db = self.openDatabase(sqlitePath)

        if db == nil {
            return nil
        }
    }

    // connect to database
    func openDatabase(_ path :String) -> OpaquePointer? {
        var dbConnect : OpaquePointer? = nil
        if sqlite3_open(path, &dbConnect) == SQLITE_OK {
            print("Successfully opened database \(path)")
            return dbConnect!
        } else {
            print("Failed to open database.")
            return nil
        }
    }

}
