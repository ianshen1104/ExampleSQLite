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

    func createTable(_ tableName :String, columnsInfo :[String]) -> Bool {
        let sql = "create table if not exists \(tableName) "
                + "(\(columnsInfo.joined(separator: ",")))"

        if sqlite3_exec(self.db, sql.cString(using: String.Encoding.utf8), nil, nil, nil) == SQLITE_OK{
            return true
        }
        return false
    }

}
