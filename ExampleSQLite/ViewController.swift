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

        if let mydb = db { //Try playing with the db
            let _ = mydb.createTable("people", columnsInfo: [
                "id integer primary key autoincrement",
                "name text",
                "height double"])
        }
    }


}

