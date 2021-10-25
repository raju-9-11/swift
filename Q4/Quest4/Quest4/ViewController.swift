//
//  ViewController.swift
//  Quest4
//
//  Created by Rajkumar S on 21/10/21.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    var richTextEditor: UITextView!
    var unEditedText: UITextView!

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        UIMenuController.shared.menuItems = [
            UIMenuItem(title: "Default", action: #selector(makeDefault)),
            UIMenuItem(title: "Bold", action: #selector(makeBold)),
            UIMenuItem(title: "Italic", action: #selector(makeItalic)),
            UIMenuItem(title: "UnderLine", action: #selector(makeUnderLine)),
            UIMenuItem(title: "StrikeThrough", action: #selector(makeStrikethrough)),
            UIMenuItem(title: "Subscript", action: #selector(makeSubScript)),
            UIMenuItem(title: "Superscript", action: #selector(makeSuperScript)),
        ]
        
//      TextEditor initialization
        richTextEditor = UITextView()
        richTextEditor.text = "Enter Text Here "
        richTextEditor.layer.borderWidth = 1
        richTextEditor.layer.cornerRadius = 6
        richTextEditor.textColor = .black
        richTextEditor.font = .systemFont(ofSize: 10)
        richTextEditor.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(richTextEditor)
        richTextEditor.delegate = self
        
//      TextView initialization
        unEditedText = UITextView()
        unEditedText.text = "Your unedited text appears here"
        unEditedText.translatesAutoresizingMaskIntoConstraints = false
        unEditedText.isEditable = false
        unEditedText.font = .italicSystemFont(ofSize: 10)
        view.addSubview(unEditedText)
        
        NSLayoutConstraint.activate([
            richTextEditor.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
            richTextEditor.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            richTextEditor.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            richTextEditor.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            unEditedText.topAnchor.constraint(equalTo: richTextEditor.layoutMarginsGuide.bottomAnchor, constant: 50),
            unEditedText.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            unEditedText.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            unEditedText.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == richTextEditor {
            if textView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).count < 1  {
                unEditedText.text = "Your unedited text appears here"
            } else {
                unEditedText.text = richTextEditor.text ?? "Uknown Text!!"
            }
        }
    }
    
    @objc
    func makeDefault() {
        let mutableString = NSMutableAttributedString.init(attributedString: richTextEditor.attributedText )
        mutableString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func makeBold() {
        let mutableString = NSMutableAttributedString.init(attributedString: richTextEditor.attributedText )
        mutableString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 10), range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func makeItalic() {
        let mutableString = NSMutableAttributedString.init(attributedString: richTextEditor.attributedText )
        mutableString.addAttribute(NSAttributedString.Key.font, value: UIFont.italicSystemFont(ofSize: 10), range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func makeUnderLine() {
        let mutableString = NSMutableAttributedString.init(attributedString: richTextEditor.attributedText )
        mutableString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.thick.rawValue , range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func makeStrikethrough() {
        let mutableString = NSMutableAttributedString.init(attributedString: richTextEditor.attributedText )
        mutableString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.thick.rawValue , range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func makeSuperScript() {
        let mutableString = NSMutableAttributedString.init(attributedString: richTextEditor.attributedText)
        mutableString.setAttributes([.font: UIFont.systemFont(ofSize: 7), .baselineOffset: 5], range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func makeSubScript() {
        let mutableString = NSMutableAttributedString.init(attributedString: richTextEditor.attributedText)
        mutableString.setAttributes([.font: UIFont.systemFont(ofSize: 7), .baselineOffset: -5], range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    


}

