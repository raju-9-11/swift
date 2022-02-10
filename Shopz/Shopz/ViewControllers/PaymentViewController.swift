//
//  PaymentViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class PaymentViewController: UIViewController {
    
    var product: Product? {
        willSet{
            if newValue != nil {
                totalLabelCost.text = "$ \(newValue!.price+newValue!.shipping_cost)"
            }
        }
    }
    
    var cart: [CartItem] = [] {
        willSet {
            totalLabelCost.text = "$ \(newValue.map({ item in return item.product.price+item.product.shipping_cost }).reduce(0, +))"
        }
    }
    
    var shoppingListData: ShoppingList?
    
    var selectedCard: CardData?
    
    var selectedGiftCard: GiftCardData?
    
    lazy var cartDetails: UILabel = {
        return titleLabel(text: "Cart Details")
    }()
    
    let backGroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 7
        return view
    }()
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let billingDetailsContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var totalLabel: UILabel = {
        return defaultLabel(text: "Total Cost")
    }()
    
    lazy var totalLabelCost: UILabel = {
        return defaultLabel(text: "$ 0")
    }()
    
    lazy var savedCardsLabel: UILabel = {
        return titleLabel(text: "Your Saved Cards")
    }()
    
    let paymentCardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumLineSpacing = 5
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CardItemCollectionViewCell.self, forCellWithReuseIdentifier: CardItemCollectionViewCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    let addNewCard: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Card", for: .normal)
        button.setTitleColor(.white, for: .normal)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .blue.withAlphaComponent(0.5)
            config.cornerStyle = .medium
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            button.configuration = config
        } else {
            button.backgroundColor = .blue.withAlphaComponent(0.5)
            button.layer.cornerRadius = 6
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
        button.tintColor = .white
        return button
    }()
    
    
    lazy var completePayment: UIButton = {
        return defaultButton(title: "Complete Payment", color: UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1))
    }()
    
    lazy var useGiftCard: UIButton = {
        return defaultButton(title: "Use GiftCard", color: UIColor(red: 0.965, green: 0.416, blue: 0.549, alpha: 1))
    }()
    
    lazy var cancelPayment: UIButton = {
        return defaultButton(title: "Cancel Payment", color: UIColor.red)
    }()
    
    var cards : [CardData] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .coverVertical
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor(named: "background_color")

        paymentCardsCollectionView.dataSource = self
        paymentCardsCollectionView.delegate = self
        
        addNewCard.addTarget(self, action: #selector(displayAddCardVC), for: .touchUpInside)
        completePayment.addTarget(self, action: #selector(onCompletePayment), for: .touchUpInside)
        useGiftCard.addTarget(self, action: #selector(onUseGiftCard), for: .touchUpInside)
        cancelPayment.addTarget(self, action: #selector(onCancelPayment), for: .touchUpInside)
        
        billingDetailsContainer.addArrangedSubview(newStackView(views: [totalLabel, totalLabelCost]))
        topView.addSubview(cartDetails)
        topView.addSubview(backGroundView)
        topView.addSubview(billingDetailsContainer)
        view.addSubview(topView)
        view.addSubview(savedCardsLabel)
        view.addSubview(paymentCardsCollectionView)
        view.addSubview(addNewCard)
        view.addSubview(completePayment)
        view.addSubview(useGiftCard)
        view.addSubview(cancelPayment)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            topView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cartDetails.leftAnchor.constraint(equalTo: topView.leftAnchor),
            cartDetails.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20),
            billingDetailsContainer.centerYAnchor.constraint(equalTo: backGroundView.centerYAnchor),
            billingDetailsContainer.widthAnchor.constraint(equalTo: topView.widthAnchor),
            billingDetailsContainer.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor),
            backGroundView.topAnchor.constraint(equalTo: cartDetails.bottomAnchor, constant: 5),
            backGroundView.heightAnchor.constraint(equalTo: billingDetailsContainer.heightAnchor, multiplier: 1.5),
            backGroundView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            backGroundView.widthAnchor.constraint(equalTo: billingDetailsContainer.widthAnchor, multiplier: 1.1),
            savedCardsLabel.topAnchor.constraint(equalTo: backGroundView.bottomAnchor, constant: 10),
            savedCardsLabel.leftAnchor.constraint(equalTo: topView.leftAnchor),
            addNewCard.topAnchor.constraint(equalTo: savedCardsLabel.bottomAnchor, constant: 10),
            addNewCard.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            paymentCardsCollectionView.topAnchor.constraint(equalTo: addNewCard.bottomAnchor, constant: 5),
            paymentCardsCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            paymentCardsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            paymentCardsCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            useGiftCard.bottomAnchor.constraint(equalTo: cancelPayment.topAnchor, constant: -10),
            useGiftCard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            useGiftCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completePayment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completePayment.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            completePayment.bottomAnchor.constraint(equalTo: useGiftCard.topAnchor, constant: -10),
            cancelPayment.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelPayment.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            cancelPayment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        loadData()
    }
    
    func loadData() {
        cards = ApplicationDB.shared.getCards()
        
        
        paymentCardsCollectionView.reloadData()
    }
    
    func titleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .monospacedSystemFont(ofSize: 20, weight: .heavy)
        return label
    }
    
    func defaultLabel(text: String ) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .monospacedSystemFont(ofSize: 15, weight: .semibold)
        return label
    }
    
    func defaultButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            config.baseBackgroundColor = color
            config.cornerStyle = .medium
            button.configuration = config
        } else {
            button.backgroundColor = color
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.layer.cornerRadius = 6
        }
        return button
    }
    
    func newStackView(views: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        return stack
    }
    
    @objc
    func displayAddCardVC() {
        let anvc = AddNewCardViewController()
        anvc.modalTransitionStyle = .crossDissolve
        anvc.modalPresentationStyle = .overCurrentContext
        anvc.delegate = self
        self.present(anvc, animated: true, completion: nil)
    }
    
    @objc
    func onCompletePayment() {
        if let selectedGiftCard = selectedGiftCard {
            if product != nil {
                ApplicationDB.shared.checkoutProduct(product: product!, deliveryDate: Date().offset(by: 1), withGiftCard: selectedGiftCard)
            } else if shoppingListData == nil {
                ApplicationDB.shared.checkoutCart(deliveryDate: Date().offset(by: 1),withGiftCard: selectedGiftCard)
            } else {
                ApplicationDB.shared.checkoutShoppingList(list: shoppingListData!, deliveryDate: Date().offset(by: 1), withGiftCard: selectedGiftCard)
            }
            let vc = PaymentResultViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        } else if let selectedCard = selectedCard  {
            if product != nil {
                ApplicationDB.shared.checkoutProduct(product: product!, deliveryDate: Date().offset(by: 1), withCard: selectedCard)
            } else if shoppingListData == nil {
                ApplicationDB.shared.checkoutCart(deliveryDate: Date().offset(by: 1), withCard: selectedCard)
            } else {
                ApplicationDB.shared.checkoutShoppingList(list: shoppingListData!, deliveryDate: Date().offset(by: 1), withCard: selectedCard)
            }
            let vc = PaymentResultViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        } else {
            Toast.shared.showToast(message: "Select a payment Method ")
            return
        }

    }
    
    @objc
    func onUseGiftCard() {
        let selectGiftCardVC = SelectGiftCardViewController()
        selectGiftCardVC.selectedCard = selectedGiftCard
        if product != nil {
            selectGiftCardVC.requiredAmount = Double(truncating: (product!.shipping_cost + product!.price) as NSDecimalNumber)
        } else if shoppingListData == nil {
            selectGiftCardVC.requiredAmount = cart.map({ item in return Double(truncating: (item.product.price+item.product.shipping_cost) as NSDecimalNumber) }).reduce(0, +)
        } else {
            selectGiftCardVC.requiredAmount = ApplicationDB.shared.getShoppingList(with: shoppingListData!.id).map({ item in return Double(truncating: (item.product.shipping_cost + item.product.price) as NSDecimalNumber) }).reduce(0, +)
        }
        self.present(selectGiftCardVC, animated: true, completion: nil)
    }
    
    @objc
    func onCancelPayment() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension PaymentViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
        self.selectedGiftCard = nil
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height + 50, height: collectionView.frame.height - 5)
    }
}

extension PaymentViewController: AddCardDelegate {
    
    func onAddClick(name: String, cardNumber: String, date: Date) {
        let cardNumber = cardNumber.replacingOccurrences(of: " - ", with: "")
        ApplicationDB.shared.addCard(name: name, date: date, cardNumber: cardNumber)
        self.loadData()
    }
}

