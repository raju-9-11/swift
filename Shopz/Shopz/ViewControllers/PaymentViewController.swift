//
//  PaymentViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class PaymentViewController: CustomViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total Cost"
        return label
    }()
    
    let totalLabelCost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$ 0"
        return label
    }()
    
    let savedCardsLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Saved Cards"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setTitle("Add Card", for: .normal)
        return button
    }()
    
    
    let completePayment: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Complete Payment", for: .normal)
        button.backgroundColor = UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1)
        return button
    }()
    
    let useGiftCard: UIButton = {
        let button = UIButton()
        button.setTitle("Use Gift card", for: .normal)
        button.backgroundColor = UIColor(red: 0.965, green: 0.416, blue: 0.549, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelPayment: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Cancel Payment", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cards : [CardData] = {
        return [
            CardData(name: "Pacman", number: UUID().uuidString, validityDate: Date()),
            CardData(name: "JOGNAS", number: UUID().uuidString, validityDate: Date()),
            CardData(name: "Jone", number: UUID().uuidString, validityDate: Date()),
            CardData(name: "Dow", number: UUID().uuidString, validityDate: Date()),
            CardData(name: "Picaa", number: UUID().uuidString, validityDate: Date()),
        ]
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
//        view.addSubview(savedCardsLabel)
//        view.addSubview(paymentCardsCollectionView)
//        view.addSubview(addNewCard)
//        view.addSubview(completePayment)
//        view.addSubview(useGiftCard)
//        view.addSubview(cancelPayment)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            topView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cartDetails.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 5),
            cartDetails.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20),
            billingDetailsContainer.centerYAnchor.constraint(equalTo: backGroundView.centerYAnchor),
            billingDetailsContainer.widthAnchor.constraint(equalTo: topView.widthAnchor),
            billingDetailsContainer.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor),
            backGroundView.topAnchor.constraint(equalTo: cartDetails.bottomAnchor, constant: 5),
            backGroundView.heightAnchor.constraint(equalTo: billingDetailsContainer.heightAnchor, multiplier: 1.5),
            backGroundView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            backGroundView.widthAnchor.constraint(equalTo: billingDetailsContainer.widthAnchor, multiplier: 1.1),
//            savedCardsLabel.topAnchor.constraint(equalTo: topView.bottomAnchor),
//            savedCardsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
//            paymentCardsCollectionView.topAnchor.constraint(equalTo: savedCardsLabel.bottomAnchor),
//            paymentCardsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            paymentCardsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
//            paymentCardsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            addNewCard.topAnchor.constraint(equalTo: paymentCardsCollectionView.bottomAnchor),
//            addNewCard.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
//            useGiftCard.bottomAnchor.constraint(equalTo: cancelPayment.topAnchor),
//            useGiftCard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
//            useGiftCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            completePayment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            completePayment.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
//            completePayment.bottomAnchor.constraint(equalTo: useGiftCard.topAnchor),
//            cancelPayment.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            cancelPayment.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
//            cancelPayment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func titleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .monospacedSystemFont(ofSize: 20, weight: .heavy)
        return label
    }
    
    func newStackView(views: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        return stack
    }
    
    @objc
    func onAddNewCard() {
        print("Adding New card....")
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
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
    }
    
    @objc
    func onCancelPayment() {
        self.dismiss(animated: true, completion: nil)
    }

}

