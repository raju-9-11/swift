//
//  FormElement.swift
//  Shopz
//
//  Created by Rajkumar S on 18/01/22.
//

import Foundation


class FormElement: Hashable {
    var id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FormElement, rhs: FormElement) -> Bool {
        lhs.id == rhs.id
    }
}


class ButtonElement: FormElement {
    var title: String
    var index: Int
    
    init(title: String, index: Int) {
        self.index = index
        self.title = title
    }
}

class DropDownElement: FormElement {
    
    var optionArray: [String]
    var error: String
    var errorState: Bool
    var index: Int
    var tag: String
    var text: String
    
    init(optionArray: [String], error: String, index: Int, errorState: Bool, tag: String, text: String) {
        self.optionArray = optionArray
        self.errorState = errorState
        self.error = error
        self.index = index
        self.tag = tag
        self.text = text
    }
    
    func checkError() -> Bool {
        self.errorState = !self.optionArray.contains(self.text) || self.text.isEmpty
        return !self.optionArray.contains(self.text) || self.text.isEmpty
    }
}

class TextFieldElement: FormElement {
    private var placeholder: String
    private var text: String
    private var error: String
    private var index: Int
    private var type: FieldType
    private var tag: String
    private var errorState: Bool = false
    
    init( text: String, placeholder: String, error: String, index: Int, type: FieldType, tag: String) {
        self.index = index
        self.text = text
        self.placeholder = placeholder
        self.error = error
        self.type = type
        self.tag = tag
    }
    
    func getIndex() -> Int {
        return self.index
    }
    
    func getPlaceholder() -> String {
        return self.placeholder
    }
    
    func getText() -> String {
        return self.text
    }
    
    func setText(text: String) {
        self.text = text
    }
    
    func getType() -> FieldType {
        return self.type
    }
    
    func getTag() -> String {
        return self.tag
    }
    
    func getErrorState() -> Bool {
        return self.errorState
    }
    
    func getError() -> String {
        return self.error
    }
    
    func checkError() -> Bool {
        var state = self.errorState
        switch type {
        case .email:
            state = !isValidEmail()
        case .password:
            state = !isValidPassword()
        case .number:
            state = !isValidPhoneNumber()
        case .plain:
            state = !isValidText()
        }
        self.errorState = state
        return state
    }
    
    func isValidEmail() -> Bool {
        if text.count < 1 {
            self.error = "Email Cannot be empty"
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: text) {
            self.error = "Email should be in format xxx@domain"
        }
        return emailPred.evaluate(with: text)
    }
    
    func isValidPassword() -> Bool {
        if text.count == 0 {
            self.error = "Password cannot be empty"
            return false
        } else {
            self.error = "Passwords should contain atleast 8 characters"
        }
        return text.count > 7
    }
    
    func isSamePassword(asElem other: TextFieldElement) ->Bool {
        if self.text != other.text {
            self.error = "Passwords do not match"
            other.error = "Passwords do not match"
            self.errorState = true
            other.errorState = true
        }
        return !self.errorState
    }
    
    
    func isValidPhoneNumber() -> Bool {
        return text.count == 10
    }
    
    func isValidText() -> Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    
    enum FieldType: String {
        case email = "Email", password = "Password", number = "Number", plain = "Plain"
    }
}

class PlainElement: FormElement {
    var index: Int
    init(index: Int) {
        self.index = index
    }
}
