//
//  ViewController.swift
//  ExampleSQLite
//
//  Created by Ian Shen on 6/21/22.
//

import UIKit

class ViewController: UIViewController {

    var db :SQLiteConnector? = nil

    let sqliteURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("db.sqlite") //Any name for db file. File created if dne
        } catch {
            fatalError("Error getting file URL from document directory.")
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let sqlitePath = sqliteURL.path
        print(sqlitePath)

        db = SQLiteConnector(path: sqlitePath)

        //Try playing with the db
        if let mydb = db {

            let tableName: String = "people"

            // test create
            let _ = mydb.createTable(tableName, columnsInfo: [
                "id integer primary key autoincrement",
                "name text",
                "height double"])

            // test insert
            let _ = mydb.insert(tableName, rowInfo: ["name":"'Stephen Curry'","height":"1.88"])

            // select
            let statement = mydb.fetch(tableName, cond: "1 == 1", order: nil)

            // This while loop reads the statement returned by the sqlite db line by line and exits when there are no more lines
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int(statement, 0)
                let name = String(cString: sqlite3_column_text(statement, 1))
                let height = sqlite3_column_double(statement, 2)
                print("\(id). \(name) height： \(height)")
            }

            // **IMPORTANT: release statement pointer when done
            sqlite3_finalize(statement)

            // update
            let _ = mydb.update(tableName, cond: "id = 1",
                rowInfo: ["name":"'LeBron James'","height":"2.06"])

            // delete
            let _ = mydb.delete(tableName, cond: "id = 2")

            // select
            let statement1 = mydb.fetch(tableName, cond: "1 == 1", order: nil)

            // This while loop reads the statement returned by the sqlite db line by line and exits when there are no more lines
            while sqlite3_step(statement1) == SQLITE_ROW {
                let id = sqlite3_column_int(statement1, 0)
                let name = String(cString: sqlite3_column_text(statement1, 1))
                let height = sqlite3_column_double(statement1, 2)
                print("\(id). \(name) height： \(height)")
            }

            sqlite3_finalize(statement1)
        }

    }


}

