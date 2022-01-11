//
//  User.swift
//  Shopz
//
//  Created by Rajkumar S on 31/12/21.
//

import Foundation
import SQLite3
import CryptoKit

internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

class ApplicationDB {
    
    var name: String
    var db: OpaquePointer?
    var statement: OpaquePointer?
    
    static let shared: ApplicationDB = ApplicationDB(name: "Shopz")
    
    init(name: String) {
        self.name = name
    }
    
    func openDB() -> Bool {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("\(name).sqlite")
        guard sqlite3_open(fileURL.path, &db) == SQLITE_OK else {
            print("error opening database")
            sqlite3_close(db)
            db = nil
            return false
        }
        return true
    }
    
    func closeDB() {
        sqlite3_close(db)
    }
    
    func initDB() -> Bool {
        return openDB() && createTable(tableName: "users", with: [
            "id": "integer primary key autoincrement",
            "firstname": "text",
            "lastname": "text",
            "password": "text",
            "password_salt": "text",
            "about": "text",
            "email": "text",
            "ph": "text",
            "city": "text",
            "country": "text"
        ]) && createTable(tableName: "cart_items", with: [
            "id":"integer primary key",
            "product_id": "integer",
        ])
    }
    
    func createTable(tableName: String, with queryComponents : [String: String]) -> Bool {
        let valuesString = queryComponents.map({ key, value in return "\(key) \(value)" }).joined(separator: ",")
        if sqlite3_exec(db, "create table if not exists \(tableName) (\(valuesString))", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
            return false
        }
        return true
    }
    
    func addUser(firstName: String, lastName: String, email: String, ph: String, country: String, city: String, password: String, about: String = "") -> Bool {
        
        var statement: OpaquePointer?
        let salt = Auth.saltGen()
        var userExists = false
        switch self.verifyUser(email: email, password: password) {
        case .success(_):
            userExists = true
        case .failure(let err):
            switch err {
            case .userNotFound:
                userExists = true
            default:
                userExists = false
            }
        }
        
        if userExists {
            return false
        }
        print(Auth.hashPassword(password: password, salt: salt))
        
        sqlite3_prepare(db, "insert into users (firstname, lastname, email, ph, country, city, password, password_salt, about) values (?, ?, ?, ?, ?, ?, ?, ?, ?)", -1, &statement, nil)
        sqlite3_bind_text(statement, 1, "\(firstName)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 2, "\(lastName)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 3, "\(email)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 4, "\(ph)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 5, "\(country)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 6, "\(city)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 7, "\(Auth.hashPassword(password: password, salt: salt))", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 8, "\(salt)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 9, "\(about)", -1, SQLITE_TRANSIENT)
        sqlite3_step(statement)
        
        return true
    }
    
    func verifyUser(email: String, password: String) -> Result<User, UserFetchError> {
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, "select id ,firstname, lastname, email, ph, country, city, password, password_salt, about from users where email='\(email)'", -1, &statement, nil) != SQLITE_OK {
            print("Error \(String(cString: sqlite3_errmsg(db)))")
            return .failure(.dataNotFound)
        }
        
        if sqlite3_step(statement) == SQLITE_ROW {
            if Auth.verifyPassword(password: password, hashPassword: String(cString: sqlite3_column_text(statement, 7)), salt: String(cString: sqlite3_column_text(statement, 8))) {
                return .success(
                    User(
                        id: Int(sqlite3_column_int64(statement, 0)),
                        firstName: String(cString: sqlite3_column_text(statement, 1)),
                        lastName: String(cString: sqlite3_column_text(statement, 2)),
                        email: String(cString: sqlite3_column_text(statement, 3)),
                        ph: String(cString: sqlite3_column_text(statement, 4)),
                        country: String(cString: sqlite3_column_text(statement, 5)),
                        about: String(cString: sqlite3_column_text(statement, 9))
                ))
            } else {
                return .failure(.invalidPassword)
            }
        }
        
        return .failure(.userNotFound)
        
        
        
    }
    
    func readUsers() {
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, "select id, firstname, lastname, email, ph, country, city, password, password_salt, about from users", -1, &statement, nil) != SQLITE_OK {
            print("Error \(String(cString: sqlite3_errmsg(db)))")
            return
        }
        
        var id: Int = -1
        var password: String = ""
        var about: String = ""
        var firstName: String = ""
        var lastName: String = ""
        var country: String = ""
        var city: String = ""
        var ph: String = ""
        var email: String = ""
        var salt: String = ""
        
        print("\(String(cString: sqlite3_column_name(statement, 0))) \t \(String(cString: sqlite3_column_name(statement, 1))) \t \(String(cString: sqlite3_column_name(statement, 2))) \t \(String(cString: sqlite3_column_name(statement, 3))) \t \(String(cString: sqlite3_column_name(statement, 4))) \t \(String(cString: sqlite3_column_name(statement, 5))) \t \(String(cString: sqlite3_column_name(statement, 6))) \t \(String(cString: sqlite3_column_name(statement, 7))) \t \(String(cString: sqlite3_column_name(statement, 8))) \t \(String(cString: sqlite3_column_name(statement, 9)))")
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let userId = sqlite3_column_int64(statement, 0)
            id = Int(userId)

            if let cString = sqlite3_column_text(statement, 1) {
                firstName = String(cString: cString)
            }

            if let cString = sqlite3_column_text(statement, 2) {
                lastName = String(cString: cString)
            }

            if let cString = sqlite3_column_text(statement, 3) {
                email = String(cString: cString)
            }
            
            if let cString = sqlite3_column_text(statement, 4) {
                ph = String(cString: cString)
            }
            
            if let cString = sqlite3_column_text(statement, 5) {
                country = String(cString: cString)
            }
            
            if let cString = sqlite3_column_text(statement, 6) {
                city = String(cString: cString)
            }
            
            if let cString = sqlite3_column_text(statement, 7) {
                password = String(cString: cString)
            }
            
            if let cString = sqlite3_column_text(statement, 8) {
                salt = String(cString: cString)
            }
            
            if let cStrign = sqlite3_column_text(statement, 9) {
                about = String(cString: cStrign)
            }

            print("\(id) \t \(firstName) \t \(lastName) \t \(email) \t \(ph) \t \(country) \t \(city) \t \(password) \t \(salt) \t \(about)")

        }

    }
    
    func clearDB(tableName: String) {
        if sqlite3_exec(db, "drop table \(tableName)", nil, nil, nil) != SQLITE_OK {
            print("Error \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    
    
    enum UserFetchError: Error {
        case invalidPassword, userNotFound, dataNotFound
    }
    
}

//        if ApplicationDB.shared.initDB() {
//            if ApplicationDB.shared.addUser(firstName: "John", lastName: "Doe", email: "test@xyz.com", ph: "+919789019982", country: "India", city: "Chennai", password: "Passwd", about: "TEST") {
//                print("user Created")
//            } else {
//                print("User Exists")
//            }
//            ApplicationDB.shared.readUsers()
//            switch ApplicationDB.shared.verifyUser(email: "test@xyz.com", password: "Passwd") {
//            case .success(let user):
//                print("user found: \(user.firstName)")
//            case .failure(let err):
//                switch err {
//                case .invalidPassword:
//                    print("Password Invalid")
//                case .userNotFound:
//                    print("User Not Found")
//                case .dataNotFound:
//                    print("Unable to read data try again later")
//                }
//            }
//        }

 
