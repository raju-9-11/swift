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
            ]) && createTable(tableName: "session", with: [
                "id": "text primary key",
                "user_id": "integer",
                "firstname": "text",
                "lastname": "text",
                "about": "text",
                "email": "text",
                "ph": "text",
                "city": "text",
                "country": "text"
            ]) && createTable(tableName: "cart_items", with: [
                "item_id":"integer primary key autoincrement",
                "cart_id": "integer",
                "product_id": "integer",
            ])  && createTable(tableName: "order_history", with: [
                "item_id": "integer primary key autoincrement",
                "purchase_date": "date",
                "user_id": "integer",
                "product_id": "integer",
                "delivery_date": "date"
            ]) && createTable(tableName: "shopping_lists", with: [
                "list_id": "integer primary key autoincrement",
                "user_id": "integer",
                "name": "text",
            ]) && createTable(tableName: "shopping_list_items", with: [
                "item_id":"integer primary key autoincrement",
                "list_id": "integer",
                "product_id": "integer",
            ]) && createTable(tableName: "address_items", with: [
                "address_id": "integer primary key autoincrement",
                "user_id": "integer",
                "address_line_1": "text",
                "address_line_2": "text",
                "pincode": "text",
                "country": "text",
                "city": "text",
            ]) && createTable(tableName: "payment_cards", with: [
                "card_id": "integer primary key autoincrement",
                "card_number": "text",
                "user_id": "integer",
                "expiry_date": "date",
                "name": "text"
            ]) && createTable(tableName: "review_items", with: [
                "review_id": "integer primary key autoincrement",
                "user_id": "Int",
                "product_id": "Int",
                "review": "text",
                "rating": "Int"
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
    
    func addColumn(tableName: String, columnName: String, columnType: String) -> Bool {
        if sqlite3_exec(db, "alter table \(tableName) add \(columnName) \(columnType)", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            return false
        }
        return true
    }
    
    // MARK: - User and session functions
    
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
    
    func getUserName(userID: Int) -> String {
        var statement: OpaquePointer?
        var name = "Unknown"
        guard initDB() else { return name }
        
        if sqlite3_prepare(db, "select id ,firstname, lastname, email, ph, country, city, password, password_salt, about from users where id='\(userID)'", -1, &statement, nil) != SQLITE_OK {
            print("Error \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
            return name
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
                about: String(cString: sqlite3_column_text(statement, 9))
            )
            name = user.firstName + " " + user.lastName
        }
        sqlite3_finalize(statement)
        closeDB()
        return name
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
    
    // MARK: - Cart functions
    
    func getCart() -> [CartItem] {
        
        guard let auth = Auth.auth else { return [] }
        var cartItems: [CartItem] = []
        var statement: OpaquePointer?
        guard initDB() else { return [] }
        
        if sqlite3_prepare(db, "select item_id, product_id from cart_items where cart_id=\(auth.user.id) ", -1, &statement, nil) != SQLITE_OK {
            print("Error \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
            return []
        }
        
        while(sqlite3_step(statement) == SQLITE_ROW) {
            let itemId = Int(sqlite3_column_int(statement, 0))
            let productId = sqlite3_column_int(statement, 1)
            if let prod = StorageDB.getProduct(with: Int(productId)) {
                cartItems.append(CartItem(product: prod, itemId: itemId))
            }
        }
        
        
        sqlite3_finalize(statement)
        closeDB()
        return cartItems
    }
    
    func getCartCount() -> Int? {
        guard let auth = Auth.auth else { return nil }
        var count: Int? = 0
        var statement: OpaquePointer?
        guard initDB() else { return nil }
        
        if sqlite3_prepare(db, "select count(*) from cart_items where cart_id=\(auth.user.id)", -1, &statement, nil) != SQLITE_OK {
            print("Error \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
            return nil
        }
        
        if sqlite3_step(statement) == SQLITE_ROW {
            count = Int(sqlite3_column_int(statement, 0))
        }
        
        sqlite3_finalize(statement)
        closeDB()
        return count
        
    }
    
    func addToCart(item: Product) {
        
        guard let auth = Auth.auth else { return }
        guard initDB() else { return }
        
        if sqlite3_exec(db, "insert into cart_items (cart_id, product_id) values (\(auth.user.id), \(item.product_id))", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            Toast.shared.showToast(message: "Unable to add to Cart", type: .error)
            closeDB()
            return
        }
        NotificationCenter.default.post(name: .cartUpdate, object: nil)
        Toast.shared.showToast(message: "Added to Cart", type: .success)
        closeDB()
    }
    
    func removeFromCart(item: CartItem) {
        
        guard Auth.auth != nil else { return }
        guard initDB() else { return }
        if sqlite3_exec(db, "delete from cart_items where item_id=\(item.itemId) ", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            closeDB()
            Toast.shared.showToast(message: "Unable to delete", type: .error)
            return
        }
        Toast.shared.showToast(message: "Deleted item \(item.product.product_name)", type: .success)
        closeDB()
        
    }
    
    func clearCart() {
        guard let auth = Auth.auth else { return }
        guard initDB() else { return }
        
        if sqlite3_exec(db, "delete from cart_items where cart_id=\(auth.user.id)", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            Toast.shared.showToast(message: "Unable to clear cart")
            closeDB()
            return
        }
        closeDB()
    }
    
    
    // MARK: - Shopping List Functions
    
    func addToShoppingList(item: Product, list: ShoppingList) {
        
        guard let _ = Auth.auth else { return }
        guard initDB() else { return }
        
        if sqlite3_exec(db, "insert into shopping_list_items (list_id, product_id) values (\(list.id), \(item.product_id))", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            closeDB()
            Toast.shared.showToast(message: "Unable to add to \(list.name)")
            return
        }
        Toast.shared.showToast(message: "Add to \(list.name)")
    }
    
    func clearShoppingList(list: ShoppingList) {
        guard Auth.auth != nil else { return }
        guard initDB() else { return }
        print(list.name)
        
        if sqlite3_exec(db, "delete from shopping_list_items where list_id=\(list.id) ", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
        }
        closeDB()
    }
    
    func removeFromShoppingList(list: ShoppingList, item: CartItem) {
        
        guard Auth.auth != nil else { return }
        guard initDB() else { return }
        if sqlite3_exec(db, "delete from shopping_list_items where item_id=\(item.itemId) ", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            closeDB()
            Toast.shared.showToast(message: "Unable to delete", type: .error)
            return
        }
        Toast.shared.showToast(message: "Deleted item \(item.product.product_name)", type: .success)
        closeDB()
        
    }
    
    func renameShoppingList(list: ShoppingList, name: String) {
        
        guard Auth.auth != nil else { return }
        guard initDB() else { return }
        
        if sqlite3_exec(db, "update shopping_lists set name='\(name)' where list_id=\(list.id)", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            closeDB()
            Toast.shared.showToast(message: "Unable to Update name", type: .error)
            return
        }
        Toast.shared.showToast(message: "Shopping List name updated", type: .success)
        closeDB()
    }
    
    func removeShoppingList(list: ShoppingList) {
        
        guard Auth.auth != nil else { return }
        guard initDB() else { return }
        
        if sqlite3_exec(db, "delete from shopping_lists where list_id=\(list.id)", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            closeDB()
            return
        }
        
        Toast.shared.showToast(message: "Shopping List deleted")
        
        if sqlite3_exec(db, "delete from shopping_list_items where list_id=\(list.id) ", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            closeDB()
            return
        }

        closeDB()
        
    }
    
    // MARK: - Order history functions
    
    func getOrderHistory() -> [OrderHistItem] {
        var orderHistory: [OrderHistItem] = []
        guard let auth = Auth.auth else { return [] }
        guard initDB() else { return [] }
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, "select product_id, purchase_date, item_id, delivery_date from order_history where user_id=\(auth.user.id)", -1, &statement, nil) != SQLITE_OK {
            print("Error \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
            return []
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.locale = .current
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            let productId = sqlite3_column_int(statement, 0)
            let purchaseDateString = String(cString: sqlite3_column_text(statement, 1))
            let itemId = Int(sqlite3_column_int(statement, 2))
            var deliveryDateString = ""
            if let deliveryDate = sqlite3_column_text(statement, 3) {
                deliveryDateString = String(cString: deliveryDate)
            }
            let deliveryDate = dateFormatter.date(from: deliveryDateString)
            if let prod = StorageDB.getProduct(with: Int(productId)), let date = dateFormatter.date(from: purchaseDateString) {
                orderHistory.append(OrderHistItem(itemId: itemId, product: prod, purchaseDate: date, deliveryDate: deliveryDate))
            }
        }
        closeDB()
        return orderHistory
    }
    
    func addToOrderHistory(list: [CartItem], deliveryDate: Date) {
        
        guard let auth = Auth.auth else { return }
        guard initDB() else { return }
        
        let dateString = Date().toString()
        let deliveryDateString = deliveryDate.toString()
        
        list.forEach({ item in
            if sqlite3_exec(db, "insert into order_history (product_id, purchase_date, user_id, delivery_date) values (\(item.product.product_id), '\(dateString)', \(auth.user.id), '\(deliveryDateString)')", nil, nil, nil) != SQLITE_OK{
                print("Error: \(String(cString: sqlite3_errmsg(db)))")
                closeDB()
                Toast.shared.showToast(message: "Unable to Checkout")
                return
            }
        })
        closeDB()
    }
    
    func removeFromOrderHistory(item: OrderHistItem) {
        
        guard Auth.auth != nil else { return }
        guard initDB() else { return }
        
        if sqlite3_exec(db, "delete from order_history where item_id=\(item.itemId)", nil, nil, nil) != SQLITE_OK{
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            closeDB()
            Toast.shared.showToast(message: "Unable to return at the moment")
            return
        }
        Toast.shared.showToast(message: "Return Accepted")
        closeDB()
    }
    
    func userHasPurchased(product: Product) -> Bool {
        
        guard let auth = Auth.auth else { return false }
        guard initDB() else { return false }
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, "select delivery_date from order_history where user_id=\(auth.user.id) and product_id=\(product.product_id)", -1, &statement, nil) != SQLITE_OK {
            print("Error \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
            return false
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.locale = .current
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            var deliveryDateString = ""
            if let deliveryDate = sqlite3_column_text(statement, 0) {
                deliveryDateString = String(cString: deliveryDate)
            }
            if let deliveryDate = dateFormatter.date(from: deliveryDateString), deliveryDate.getOffset(from: Date()) <= 0 {
                sqlite3_finalize(statement)
                closeDB()
                return true
            }
        }
        
        sqlite3_finalize(statement)
        closeDB()
        return false
        
    }
    
    // MARK: - Shopping List functions
    func getShoppingLists() -> [ShoppingList] {
        
        guard let auth = Auth.auth else { return [] }
        var shoppinglists = [ShoppingList]()
        var statement: OpaquePointer?
        
        guard initDB() else { return [] }
        
        if sqlite3_prepare(db, "select list_id, name from shopping_lists where user_id='\(auth.user.id)'", -1, &statement, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
            return []
        }
        
        while(sqlite3_step(statement) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(statement, 0))
            let name = String(cString: sqlite3_column_text(statement, 1))
            shoppinglists.append(ShoppingList(id: id, name: name, userID: auth.user.id))
        }
        
        sqlite3_finalize(statement)
        closeDB()
        return shoppinglists
    }
    
    func getShoppingList(with id: Int) -> [CartItem] {
        
        var shoppinglistProducts = [CartItem]()
        var statement: OpaquePointer?
        
        guard initDB() else { return [] }
        
        if sqlite3_prepare(db, "select product_id, item_id from shopping_list_items where list_id='\(id)'", -1, &statement, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
            return []
        }
        
        while(sqlite3_step(statement) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(statement, 0))
            let itemId = Int(sqlite3_column_int(statement, 1))
            if let prod = StorageDB.getProduct(with: id) {
                shoppinglistProducts.append(CartItem(product: prod, itemId: itemId))
            }
        }
        
        sqlite3_finalize(statement)
        closeDB()
        return shoppinglistProducts
    }
    
    func addShoppingList(name: String) {
        
        guard let auth = Auth.auth else { return }
        var statement: OpaquePointer?
        guard initDB() else { return }
        if sqlite3_prepare(db, "insert into shopping_lists (user_id, name) values (?, ?) ", -1, &statement, nil) != SQLITE_OK{
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
            return
        }
        sqlite3_bind_int(statement, 1, Int32(auth.user.id))
        sqlite3_bind_text(statement, 2, name, -1, SQLITE_TRANSIENT)
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            Toast.shared.showToast(message: "Unable to create Shopping List", type: .error)
        }
        sqlite3_finalize(statement)
        closeDB()
        Toast.shared.showToast(message: "Created Shopping List", type: .success)
    }
    
    // MARK: - Checkout functions
    
    func addAddress(address: Address) {
        
        guard let auth = Auth.auth else { return }
        
        guard initDB() else { return }
        
        if sqlite3_exec(db, "insert into address_items (user_id, address_line_1, address_line_2, pincode, city, country) values (\(auth.user.id), '\(address.addressLine1)', '\(address.addressLine2)', '\(address.pincode)', '\(address.city)', '\(address.country)')", nil, nil, nil) != SQLITE_OK{
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            closeDB()
            Toast.shared.showToast(message: "Unable to add Address", type: .error)
            return
        }
        Toast.shared.showToast(message: "Added new address")
        closeDB()
    }
    
    func removeAddress(address: Address) {
        guard Auth.auth != nil else { return }
        
        guard initDB() else { return }
        
        if sqlite3_exec(db, "delete from address_items where address_id=\(address.addressId)", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            closeDB()
            Toast.shared.showToast(message: "Unable to Delete Address", type: .error)
            return
        }
        
        Toast.shared.showToast(message: "Deleted Address")
        closeDB()
    }
    
    func getAddressList() -> [Address] {
        
        var addresses: [Address] = []
        guard let auth = Auth.auth else { return [] }
        
        guard initDB() else { return [] }
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, "select address_id, address_line_1, address_line_2, pincode, city, country from address_items where user_id=\(auth.user.id)", -1, &statement, nil) != SQLITE_OK {
            print("Error Preparing stmt: \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
            return []
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let addressId = Int(sqlite3_column_int(statement, 0))
            let addressLine1 = String(cString: sqlite3_column_text(statement, 1))
            let addressLine2 = String(cString: sqlite3_column_text(statement, 2))
            let pincode = String(cString: sqlite3_column_text(statement, 3))
            let city = String(cString: sqlite3_column_text(statement, 4))
            let country = String(cString: sqlite3_column_text(statement, 5))
            addresses.append(Address(addressLine1: addressLine1, addressLine2: addressLine2, pincode: pincode, city: city, country: country, addressId: addressId, userId: auth.user.id))
        }
        
        sqlite3_finalize(statement)
        closeDB()
        return addresses
    }
    
    func getCards() -> [CardData] {
        
        var cards = [CardData]()
        guard let auth = Auth.auth else { return [] }
        
        guard initDB() else { return [] }
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, "select card_id, name, expiry_date, card_number from payment_cards where user_id=\(auth.user.id)", -1, &statement, nil) != SQLITE_OK {
            print("Prepare Error: \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
            return []
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let cardId = Int(sqlite3_column_int(statement, 0))
            let name = String(cString: sqlite3_column_text(statement, 1))
            let expdate = String(cString: sqlite3_column_text(statement, 2))
            let cardNumber = String(cString: sqlite3_column_text(statement, 3))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if let date = dateFormatter.date(from: expdate) {
                cards.append(CardData(id: cardId, name: name, number: cardNumber, validityDate: date))
            }
        }
        
        sqlite3_finalize(statement)
        closeDB()
        return cards
    }
    
    func getCard(with cardNum: String) -> CardData? {
        guard let auth = Auth.auth else { return nil }
        
        guard initDB() else { return nil }
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, "select card_id, name, expiry_date, card_number from payment_cards where user_id=\(auth.user.id)", -1, &statement, nil) != SQLITE_OK {
            print("Prepare Error: \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
            return nil
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let cardId = Int(sqlite3_column_int(statement, 0))
            let name = String(cString: sqlite3_column_text(statement, 1))
            let expdate = String(cString: sqlite3_column_text(statement, 2))
            let cardNumber = String(cString: sqlite3_column_text(statement, 3))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if let date = dateFormatter.date(from: expdate), cardNum == cardNumber {
                let card = CardData(id: cardId, name: name, number: cardNumber, validityDate: date)
                sqlite3_finalize(statement)
                closeDB()
                return card
            }
        }
        
        sqlite3_finalize(statement)
        closeDB()
        return nil
    }
    
    func addCard(name: String, date: Date, cardNumber: String) {
        guard let auth = Auth.auth else { return }
        guard getCard(with: cardNumber) == nil else {
            Toast.shared.showToast(message: "Card With number exists", type: .error)
            return
        }
        guard initDB() else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if sqlite3_exec(db, "insert into payment_cards (user_id, card_number, name, expiry_date) values (\(auth.user.id), '\(cardNumber)', '\(name)', '\(dateFormatter.string(from: date))')", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            closeDB()
            return
        }
        closeDB()
        return
        
    }
    
    func deleteCard(card: CardData) {
        guard Auth.auth != nil else { return }
        guard initDB() else { return }
        
        if sqlite3_exec(db, "delete from payment_cards where card_id='\(card.id)'", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            closeDB()
            return
        }
        
        
        closeDB()
        return
    }
    
    func checkoutCart(deliveryDate: Date) {
        guard Auth.auth != nil else { return }
        
        let cart = ApplicationDB.shared.getCart()
        ApplicationDB.shared.addToOrderHistory(list: cart, deliveryDate: deliveryDate)
        ApplicationDB.shared.clearCart()
    }
    
    func checkoutProduct(product: Product, deliveryDate: Date) {
        guard Auth.auth != nil else { return }
        ApplicationDB.shared.addToOrderHistory(list: [CartItem(product: product, itemId: 0)], deliveryDate: deliveryDate)
    }
    
    func checkoutShoppingList(list: ShoppingList, deliveryDate: Date) {
        guard Auth.auth != nil else { return }
        
        let cart = ApplicationDB.shared.getShoppingList(with: list.id)
        ApplicationDB.shared.addToOrderHistory(list: cart, deliveryDate: deliveryDate)
        ApplicationDB.shared.clearShoppingList(list: list)
    }
    
    // MARK: - Review functions
    
    func editReview(review: String, rating: Int, product: Product) {
        
        guard let auth = Auth.auth else { return }
        
        guard initDB() else { return }
        
        if sqlite3_exec(db, "update review_items set review='\(review)', rating=\(rating) where product_id=\(product.product_id) and user_id=\(auth.user.id)", nil, nil, nil) != SQLITE_OK{
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            Toast.shared.showToast(message: "Unable to alter review")
            closeDB()
            return
        }
        Toast.shared.showToast(message: "Review Changed")
        closeDB()
    }
    
    func addReview(review: String, rating: Int, productID: Int) {
        
        guard let auth = Auth.auth else { return }
        
        guard initDB() else { return }
        
        if sqlite3_exec(db, "insert into review_items (user_id, product_id, review, rating) values (\(auth.user.id),\(productID), '\(review)' , \(rating))", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            closeDB()
            Toast.shared.showToast(message: "unable to add review", type: .error)
            return
        }
        Toast.shared.showToast(message: "Review added", type: .success)
        closeDB()
        
    }
    
    func deleteReview(review: Review) {
        guard let auth = Auth.auth, review.userId == auth.user.id else { return }
        
        guard initDB() else { return }
        
        if sqlite3_exec(db, "delete from review_items where review_id=\(review.reviewId)", nil, nil, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            Toast.shared.showToast(message: "Unable to delete review", type: .error)
            closeDB()
            return
        }
        
        Toast.shared.showToast(message: "Review deleted")
        
        closeDB()
    }
    
    func getUserReviews() -> [Review] {
        
        guard let auth = Auth.auth else { return [] }
        var reviews: [Review] = []
        guard initDB() else { return [] }
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, "select review_id, product_id, review, rating, user_id from review_items where user_id=\(auth.user.id)", -1, &statement, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let reviewId = Int(sqlite3_column_int(statement, 0))
            let productId = Int(sqlite3_column_int(statement, 1))
            let review = String(cString: sqlite3_column_text(statement, 2))
            let rating = Int(sqlite3_column_int(statement, 3))
            let userId = Int(sqlite3_column_int(statement, 4))
            reviews.append(Review(reviewId: reviewId, userName: ApplicationDB.shared.getUserName(userID: userId), userId: userId, review: review, rating: rating, productId: productId))
        }
        sqlite3_finalize(statement)
        closeDB()
        
        return reviews
    }
    
    func hasReviewed(product: Product) -> Review? {
        guard let auth = Auth.auth else { return nil }
        guard initDB() else { return nil }
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, "select review_id, product_id, review, rating from review_items where product_id=\(product.product_id) and user_id=\(auth.user.id)", -1, &statement, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
        }
        
        if sqlite3_step(statement) == SQLITE_ROW {
            let reviewId = Int(sqlite3_column_int(statement, 0))
            let productId = Int(sqlite3_column_int(statement, 1))
            let review = String(cString: sqlite3_column_text(statement, 2))
            let rating = Int(sqlite3_column_int(statement, 3))
            sqlite3_finalize(statement)
            closeDB()
            return Review(reviewId: reviewId, userName: "\(auth.user.firstName) \(auth.user.lastName)", userId: auth.user.id, review: review, rating: rating, productId: productId)
        }
        sqlite3_finalize(statement)
        closeDB()
        return nil
    }
    
    func getReviews(product: Product) -> [Review] {
        
        var reviews: [Review] = []
        guard initDB() else { return [] }
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, "select review_id, product_id, review, rating, user_id from review_items where product_id=\(product.product_id)", -1, &statement, nil) != SQLITE_OK {
            print("Error: \(String(cString: sqlite3_errmsg(db)))")
            sqlite3_finalize(statement)
            closeDB()
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let reviewId = Int(sqlite3_column_int(statement, 0))
            let productId = Int(sqlite3_column_int(statement, 1))
            let review = String(cString: sqlite3_column_text(statement, 2))
            let rating = Int(sqlite3_column_int(statement, 3))
            let userId = Int(sqlite3_column_int(statement, 4))
            reviews.append(Review(reviewId: reviewId, userName: ApplicationDB.shared.getUserName(userID: userId), userId: userId, review: review, rating: rating, productId: productId))
        }
        sqlite3_finalize(statement)
        closeDB()
        
        return reviews
    }
    
    
    // MARK: - Profile functions
    
    
//    func setProfileImage(image: Data) {
//
//        var statement: OpaquePointer?
//        guard image.withUnsafeBytes({ bufferPointer -> Int32 in
//                sqlite3_bind_blob(statement, 5, bufferPointer.baseAddress, Int32(image.count), SQLITE_TRANSIENT)
//            }) == SQLITE_OK else {
//                print("Error\(sqlite3_errmsg(db))")
//                return
//            }
//    }
    
//    func getProfileImage() -> Data? {
//
//        return nil
//    }
    
    
    // MARK: - Clear table
    
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
