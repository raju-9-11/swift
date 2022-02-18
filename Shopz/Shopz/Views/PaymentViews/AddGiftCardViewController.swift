//
//  AddGiftCardViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 10/02/22.
//

import UIKit

class AddGiftCardViewController: UIViewController {
    
    weak var delegate: AddGiftCardDelegate?
    
    let backgroundView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(named: "background_color")?.withAlphaComponent(0.5)
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "background_color")
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Buy new gift card"
        label.font = .monospacedSystemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkBox: CheckBox = {
        let checkBox = CheckBox()
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        return checkBox
    }()
    
    let email: TextFieldWithError = {
        let textField = TextFieldWithError()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter email of user"
        textField.keyBoardType = .emailAddress
        textField.error = "Email cannot be empty"
        textField.isHidden = true
        return textField
    }()
    
    let otherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "For someone else ?"
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    lazy var otherStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [checkBox, otherLabel])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        return stack
    }()
    
    let amount: TextFieldWithError = {
        let textField = TextFieldWithError()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter amount"
        textField.keyBoardType = .numberPad
        textField.error = "Amount cannot be empty"
        return textField
    }()
    
    
    let cardList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumLineSpacing = 5
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CardItemCollectionViewCell.self, forCellWithReuseIdentifier: CardItemCollectionViewCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isUserInteractionEnabled = true
        cv.backgroundColor = .clear
        return cv
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, cardList, amount, email, otherStack, button])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        return stack
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Purchase", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 6
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var cards: [CardData] = []
    
    var selectedCard: CardData?
    
    var bottomConstraint: NSLayoutConstraint?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .clear

        containerView.addSubview(stackView)
        
        button.addTarget(self, action: #selector(onAddCard), for: .touchUpInside)
        checkBox.delegate = self
        cardList.delegate = self
        cardList.dataSource = self
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDismiss)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        
        bottomConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        bottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            
            cardList.heightAnchor.constraint(equalToConstant: 100),
            
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1.2),
        ])
        
        self.loadData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadData() {
        cards = ApplicationDB.shared.getCards()
        cardList.reloadData()
    }
    
    @objc
    func onAddCard() {
        view.endEditing(true)
        amount.errorState = amount.text.isEmpty
        email.errorState = checkBox.isOn && email.text.isEmpty
        guard let user = Auth.auth?.user, !email.errorState && !amount.errorState, let amount = Double(amount.text) else {
            return
        }
        if selectedCard == nil {
            Toast.shared.showToast(message: "Select a Payment method", type: .error)
            return
        }
        if checkBox.isOn {
            if let userID = ApplicationDB.shared.userExists(email: email.text) {
                ApplicationDB.shared.addGiftCard(card: GiftCardData(id: -1, amount: amount, validityDate: Date().offset(by: 30*6)), to: userID)
            } else {
                Toast.shared.showToast(message: "User does not exist", type: .error)
                return
            }
        } else {
            ApplicationDB.shared.addGiftCard(card: GiftCardData(id: -1, amount: amount, validityDate: Date().offset(by: 30*6)), to: user.id)
        }
        delegate?.onAddCardcomplete()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func onKeyboardShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        bottomConstraint?.constant = -120
    }
    
    @objc
    func onKeyboardHide(notification: Notification) {
        bottomConstraint?.constant = 0
    }
    
    @objc
    func onDismiss() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension AddGiftCardViewController: CheckBoxDelegate {
    
    func onToggle(_ elem: CheckBox) {
        UIView.animate(withDuration: 0.5) {
            self.email.isHidden = !elem.isOn
        }
    }
}


extension AddGiftCardViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardItemCollectionViewCell.cellID, for: indexPath) as! CardItemCollectionViewCell
        cell.cardData = cards[indexPath.row]
        cell.selectState = selectedCard?.id == cell.cardData?.id
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if cards[indexPath.row].id == selectedCard?.id {
            return UIContextMenuConfiguration()
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: {
            _ in
            let delete = UIAction(title: "Delete Card", image: UIImage(systemName: "trash"), attributes: .destructive, handler: {
                _ in
                ApplicationDB.shared.deleteCard(card: self.cards[indexPath.row])
                self.cards.remove(at: indexPath.row)
                collectionView.deleteItems(at: [indexPath])
                self.loadData()
            })
            return UIMenu(title: "Card Actions", children: [delete])
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCard = cards[indexPath.row]
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height + 50, height: collectionView.frame.height - 5)
    }
}


protocol AddGiftCardDelegate: AnyObject {
    func onAddCardcomplete()
}
