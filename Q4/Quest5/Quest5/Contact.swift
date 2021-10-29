//
//  Contact.swift
//  Quest5
//
//  Created by Rajkumar S on 25/10/21.
//

import Foundation


struct Contact : Hashable {
    
    var name: String!
    var address: String!
    var dob: Date!
    var job: String!
    var ph: String!
    var dept: String!
    var company: String!
    var color: String!
    var song: String!
    var food: String!
    var email: String!
    
    init(name: String, address: String, dob: Date, color: String, dept: String, company: String, food: String, song: String, email: String, ph: String) {
        self.name = name
        self.address = address
        self.dob = dob
        self.color = color
        self.dept = dept
        self.company = company
        self.food = food
        self.ph = ph
        self.song = song
        self.email = email
    }
    
    func isValid() -> Bool {
        return (!name.isEmpty && !address.isEmpty && !ph.isEmpty && email.isEmail()) ? true : false
    }
    
    static func ==(x: Contact, y: Contact) -> Bool {
        return x.name == y.name && x.address == y.address
    }

    func hash(into hasher: inout Hasher) {
        return hasher.combine(email)
    }
    
    func printDetails() {
        print("Name: \(self.name!) \nAddress: \(self.address!) \nDate: \(dob!) \nFavourite color: \(self.color!) \nCompany: \(self.company!) \nFavourite food\(self.food!) \nFavourite Song: \(self.song!) \nEmail: \(self.email!) \nPhone number: \(self.ph!) \nDepartment: \(self.dept!)")
    }
    
}


extension String {
    func isEmail() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
