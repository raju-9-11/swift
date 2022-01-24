//
//  PaymentViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class PaymentViewController: CustomViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var cart: [CartItem] = [] {
        willSet {
            totalLabelCost.text = "$ \(newValue.map({ item in return item.product.price+item.product.shipping_cost }).reduce(0, +))"
        }
    }
    
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
    
    let addNewCard: AddCardButton = {
        let button = AddCardButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Card", for: .normal)
        button.setTitleColor(.white, for: .normal)
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
    
    var cards : [CardData] = {
        return ApplicationDB.shared.getCards()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardItemCollectionViewCell.cellID, for: indexPath) as! CardItemCollectionViewCell
        cell.cardData = cards[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height + 50, height: collectionView.frame.height - 5)
    }
    
    override func setupLayout() {
        view.backgroundColor = .white

        paymentCardsCollectionView.dataSource = self
        paymentCardsCollectionView.delegate = self
        
        addNewCard.addTarget(self, action: #selector(onAddNewCard), for: .touchUpInside)
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
            paymentCardsCollectionView.topAnchor.constraint(equalTo: savedCardsLabel.bottomAnchor, constant: 5),
            paymentCardsCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            paymentCardsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            paymentCardsCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            addNewCard.topAnchor.constraint(equalTo: paymentCardsCollectionView.bottomAnchor, constant: 10),
            addNewCard.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
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
    func onAddNewCard() {
        let dateString = "12/2029"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/YYYY"
        dateFormatter.locale = .current
        guard let date = dateFormatter.date(from: dateString) else { return }
        ApplicationDB.shared.addCard(name: "Test", date: date, cardNumber: "1234567823451234")
        self.cards = ApplicationDB.shared.getCards()
        self.paymentCardsCollectionView.reloadData()
    }
    
    @objc
    func onCompletePayment() {
        let vc = PaymentResultViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc
    func onUseGiftCard() {
        print("Getting your gift cards...")
    }
    
    @objc
    func onCancelPayment() {
        self.dismiss(animated: true, completion: nil)
    }

}

