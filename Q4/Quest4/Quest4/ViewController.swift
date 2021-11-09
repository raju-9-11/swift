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
    var currentColor: UIColor = .systemRed
    
    let colorWell : UIColorWell = {
       let colorwell = UIColorWell()
        colorwell.selectedColor = .systemRed
        colorwell.supportsAlpha = true
        colorwell.title = "Pick a color"
        return colorwell
    }()

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
            UIMenuItem(title: "FontColor", action: #selector(changeFontColor)),
            UIMenuItem(title: "StrikeColor", action: #selector(changeStrikeColor)),
            UIMenuItem(title: "HighlightColor", action: #selector(changeHighlightColor))
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
        unEditedText.isSelectable = false
        view.addSubview(unEditedText)
        
        let label = UILabel()
        label.text = "Select color for bg and font here: "
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let testView = UIView()
        testView.contentMode = .center
        testView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(testView)
        colorWell.translatesAutoresizingMaskIntoConstraints = false
        colorWell.addTarget(self, action: #selector(setCurrentColor), for: .valueChanged)
        testView.addSubview(colorWell)
        testView.addSubview(label)
        
        NSLayoutConstraint.activate([
            richTextEditor.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            richTextEditor.bottomAnchor.constraint(equalTo: testView.topAnchor),
            richTextEditor.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            richTextEditor.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            testView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.98),
            testView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            label.centerYAnchor.constraint(equalTo: testView.centerYAnchor),
            label.leftAnchor.constraint(equalTo: testView.safeAreaLayoutGuide.leftAnchor, constant: 10),
            colorWell.heightAnchor.constraint(equalTo: testView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.9),
            colorWell.centerYAnchor.constraint(equalTo: testView.centerYAnchor),
            colorWell.leftAnchor.constraint(equalTo: label.safeAreaLayoutGuide.rightAnchor, constant: 10),
            unEditedText.topAnchor.constraint(equalTo: testView.bottomAnchor),
            unEditedText.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            unEditedText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            unEditedText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
    // Set color for further use
    @objc
    func setCurrentColor(sender: UIColorWell) {
        self.currentColor = sender.selectedColor ?? .systemRed
    }
    
    @objc
    func changeFontColor() {
        let mutableString = NSMutableAttributedString(attributedString: richTextEditor.attributedText)
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: currentColor, range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func changeStrikeColor() {
        let mutableString = NSMutableAttributedString(attributedString: richTextEditor.attributedText)
        mutableString.addAttribute(NSAttributedString.Key.strikethroughColor, value: currentColor, range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func changeHighlightColor() {
        let mutableString = NSMutableAttributedString(attributedString: richTextEditor.attributedText)
        mutableString.addAttribute(NSAttributedString.Key.backgroundColor, value: currentColor, range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func makeDefault() {
        let mutableString = NSMutableAttributedString(attributedString: richTextEditor.attributedText )
        mutableString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func makeBold() {
        let mutableString = NSMutableAttributedString(attributedString: richTextEditor.attributedText )
        mutableString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 10), range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func makeItalic() {
        let mutableString = NSMutableAttributedString(attributedString: richTextEditor.attributedText )
        mutableString.addAttribute(NSAttributedString.Key.font, value: UIFont.italicSystemFont(ofSize: 10), range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func makeUnderLine() {
        let mutableString = NSMutableAttributedString(attributedString: richTextEditor.attributedText )
        mutableString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.thick.rawValue , range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func makeStrikethrough() {
        let mutableString = NSMutableAttributedString(attributedString: richTextEditor.attributedText )
        mutableString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.thick.rawValue , range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func makeSuperScript() {
        let mutableString = NSMutableAttributedString(attributedString: richTextEditor.attributedText)
        mutableString.setAttributes([.font: UIFont.systemFont(ofSize: 7), .baselineOffset: 5], range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    
    @objc
    func makeSubScript() {
        let mutableString = NSMutableAttributedString(attributedString: richTextEditor.attributedText)
        mutableString.setAttributes([.font: UIFont.systemFont(ofSize: 7), .baselineOffset: -5], range: richTextEditor.selectedRange)
        richTextEditor.attributedText = mutableString
    }
    


}

