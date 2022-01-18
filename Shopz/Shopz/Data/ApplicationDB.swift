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
        if openDB() {
            return createTable(tableName: "users", with: [
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
            ]) && createTable(tableName: "session", with: [
                "id": "text primary_key",
                "user_id": "integer",
                "firstname": "text",
                "lastname": "text",
                "about": "text",
                "email": "text",
                "ph": "text",
                "city": "text",
                "country": "text"
            ])
        }
        return false
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
        let email = email.lowercased()
        switch self.verifyUser(email: email, password: password) {
        case .success(_):
            userExists = true
        case .failure(let err):
            switch err {
            case .userNotFound:
                userExists = false
            default:
                userExists = true
            }
        }
        
        if userExists {
            Toast.shared.showToast(message: "User Exists")
            return false
        }
        print(Auth.hashPassword(password: password, salt: salt))
        guard initDB() else { return false }
        
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
        if sqlite3_step(statement) != SQLITE_DONE {
            Toast.shared.showToast(message: "Database Error!!")
            sqlite3_finalize(statement)
            closeDB()
            return false
        }
        closeDB()
        return true
    }
    
    func verifyUser(email: String, password: String) -> Result<User, UserFetchError> {
        var statement: OpaquePointer?
        let email = email.lowercased()
        
        guard initDB() else { return .failure(.dataNotFound) }
        
        if sqlite3_prepare(db, "select id ,firstname, lastname, email, ph, country, city, password, password_salt, about from users where email='\(email)'", -1, &statement, nil) != SQLITE_OK {
            print("Error \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
            return .failure(.dataNotFound)
        }
        
        if sqlite3_step(statement) == SQLITE_ROW {
            if Auth.verifyPassword(password: password, hashPassword: String(cString: sqlite3_column_text(statement, 7)), salt: String(cString: sqlite3_column_text(statement, 8))) {
                let user = User(
                    id: Int(sqlite3_column_int64(statement, 0)),
                    firstName: String(cString: sqlite3_column_text(statement, 1)),
                    lastName: String(cString: sqlite3_column_text(statement, 2)),
                    email: String(cString: sqlite3_column_text(statement, 3)),
                    ph: String(cString: sqlite3_column_text(statement, 4)),
                    country: String(cString: sqlite3_column_text(statement, 5)),
                    city: String(cString: sqlite3_column_text(statement, 6)),
                    about: String(cString: sqlite3_column_text(statement, 9))
                )
                sqlite3_finalize(statement)
                closeDB()
                return .success(user)
            } else {
                sqlite3_finalize(statement)
                closeDB()
                return .failure(.invalidPassword)
            }
        }
        sqlite3_finalize(statement)
        closeDB()
        return .failure(.userNotFound)
    }
    
    func getCurrentUser() {
        var statement: OpaquePointer?
        
        guard initDB() else { return }
        
        if sqlite3_prepare(db, "select user_id ,firstname, lastname, email, ph, country, city, about, id from session", -1, &statement, nil) != SQLITE_OK {
            print("Error \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
            return
        }
        
        if sqlite3_step(statement) == SQLITE_ROW {
            let user = User(
                id: Int(sqlite3_column_int64(statement, 0)),
                firstName: String(cString: sqlite3_column_text(statement, 1)),
                lastName: String(cString: sqlite3_column_text(statement, 2)),
                email: String(cString: sqlite3_column_text(statement, 3)),
                ph: String(cString: sqlite3_column_text(statement, 4)),
                country: String(cString: sqlite3_column_text(statement, 5)),
                city: String(cString: sqlite3_column_text(statement, 6)),
                about: String(cString: sqlite3_column_text(statement, 7))
            )
            Auth.auth = Auth(authToken: String(cString: sqlite3_column_text(statement, 8)), user: user)
        }
        sqlite3_finalize(statement)
        closeDB()
    }
    
    func createSession(user: User) -> String? {
        let authToken = UUID().uuidString
        
        var statement: OpaquePointer?
        
        guard initDB() else { return nil }
        
        sqlite3_prepare(db, "insert into session (firstname, lastname, email, ph, country, city, about, user_id, id) values (?, ?, ?, ?, ?, ?, ?, ?, ?)", -1, &statement, nil)
        sqlite3_bind_text(statement, 1, "\(user.firstName)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 2, "\(user.lastName)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 3, "\(user.email)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 4, "\(user.ph)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 5, "\(user.country)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 6, "\(user.city)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 7, "\(user.about)", -1, SQLITE_TRANSIENT)
        sqlite3_bind_int64(statement, 8, sqlite3_int64(user.id))
        sqlite3_bind_text(statement, 9, "\(authToken)", -1, SQLITE_TRANSIENT)
        if sqlite3_step(statement) != SQLITE_DONE {
            Toast.shared.showToast(message: "Unable to login!!")
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
            return nil
        }
        sqlite3_finalize(statement)
        closeDB()
        return authToken
    }
    
    func deleteSession(token: String) {
        if self.clearDB(tableName: "session") {
            Auth.auth = nil
            Toast.shared.showToast(message: "Logout successful", type: .success)
        } else {
            print("Error Occured")
        }
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
    
    func clearDB(tableName: String) -> Bool {
        guard initDB() else { return false }
        if sqlite3_exec(db, "drop table \(tableName)", nil, nil, nil) != SQLITE_OK {
            print("Error \(String(cString: sqlite3_errmsg(db)))")
            closeDB()
            return false
        }
        closeDB()
        return true
    }
    
    
    enum UserFetchError: Error {
        case invalidPassword, userNotFound, dataNotFound
    }
    
}

