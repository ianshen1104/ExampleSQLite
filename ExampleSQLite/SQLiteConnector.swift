//
//  SQLiteConnect.swift
//  ExampleSQLite
//
//  Created by Ian Shen on 6/21/22.
//

//  Credit to: https://github.com/itisjoe/swiftgo_files/tree/master/database/sqlite/ExSQLite/ExSQLite

import Foundation
import SQLite3

class SQLiteConnector {

    var db: OpaquePointer? = nil

    let sqlitePath: String

    // failable init
    init?(path: String) {
        sqlitePath = path
        db = self.openDatabase(sqlitePath)

        if db == nil {
            return nil
        }
    }

    // connect to database
    func openDatabase(_ path: String) -> OpaquePointer? {
        var dbConnect : OpaquePointer? = nil
        if sqlite3_open(path, &dbConnect) == SQLITE_OK {
            print("Successfully opened database \(path)")
            return dbConnect!
        } else {
            print("Failed to open database.")
            return nil
        }
    }

    func createTable(_ tableName: String, columnsInfo: [String]) -> Bool {
        let sql = "create table if not exists \(tableName) "
                + "(\(columnsInfo.joined(separator: ",")))"

        if sqlite3_exec(self.db, sql.cString(using: String.Encoding.utf8), nil, nil, nil) == SQLITE_OK{
            return true
        }
        return false
    }

    func insert(_ tableName: String, rowInfo: [String:String]) -> Bool {

        var statement : OpaquePointer? = nil //Pointer used to retrieve statement sent back by sqlite

        let sql = "insert into \(tableName) "
                + "(\(rowInfo.keys.joined(separator: ","))) "
                + "values (\(rowInfo.values.joined(separator: ",")))"

        // 3rd input is maximum number of Bytes that can be read by db. set to -1 if unlimited
        if sqlite3_prepare_v2(self.db, sql.cString(using: String.Encoding.utf8), -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                return true
            }
            sqlite3_finalize(statement) //Must call finalize to release reference to &statement to avoid memory leakage
        }

        return false
    }

    func fetch(_ tableName: String, cond: String?, order: String?) -> OpaquePointer {
        var statement: OpaquePointer? = nil
        var sql = "select * from \(tableName)"
        if let condition = cond {
            sql += " where \(condition)"
        }

        if let orderBy = order {
            sql += " order by \(orderBy)"
        }

        sqlite3_prepare_v2(
            self.db, sql.cString(using: String.Encoding.utf8), -1, &statement, nil)

        return statement!
    }

    func update(_ tableName: String, cond: String?, rowInfo: [String:String]) -> Bool {
            var statement: OpaquePointer? = nil
            var sql = "update \(tableName) set "

            // row info
            var info: [String] = []
            for (k, v) in rowInfo {
                info.append("\(k) = \(v)")
            }
            sql += info.joined(separator: ",")

            // condition
            if let condition = cond {
                sql += " where \(condition)"
            }

            if sqlite3_prepare_v2(self.db, sql.cString(using: String.Encoding.utf8), -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_DONE {
                    return true
                }
                sqlite3_finalize(statement)
            }

            return false

        }

    func delete(_ tableName: String, cond: String?) -> Bool {
        var statement: OpaquePointer? = nil
        var sql = "delete from \(tableName)"

        // condition
        if let condition = cond {
            sql += " where \(condition)"
        }

        if sqlite3_prepare_v2(self.db, sql.cString(using: String.Encoding.utf8), -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                return true
            }
            sqlite3_finalize(statement)
        }

        return false
    }
}
