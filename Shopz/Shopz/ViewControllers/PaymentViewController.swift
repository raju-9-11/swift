//
//  PaymentViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class PaymentViewController: CustomViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let cartDetails: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cart Details"
        return label
    }()
    
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let billingDetailsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 7
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
        
        billingDetailsContainer.addSubview(totalLabel)
        billingDetailsContainer.addSubview(totalLabelCost)
        topView.addSubview(cartDetails)
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
            topView.widthAnchor.constraint(equalTo: view.widthAnchor),
            topView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            cartDetails.topAnchor.constraint(equalTo: topView.topAnchor, constant: 10),
            cartDetails.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 10),
            billingDetailsContainer.topAnchor.constraint(equalTo: cartDetails.bottomAnchor),
            billingDetailsContainer.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            billingDetailsContainer.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            billingDetailsContainer.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.9),
            totalLabel.leftAnchor.constraint(equalTo: billingDetailsContainer.leftAnchor),
            totalLabel.centerYAnchor.constraint(equalTo: billingDetailsContainer.centerYAnchor),
            totalLabelCost.rightAnchor.constraint(equalTo: billingDetailsContainer.rightAnchor),
            totalLabelCost.centerYAnchor.constraint(equalTo: billingDetailsContainer.centerYAnchor),
            savedCardsLabel.topAnchor.constraint(equalTo: topView.bottomAnchor),
            savedCardsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            paymentCardsCollectionView.topAnchor.constraint(equalTo: savedCardsLabel.bottomAnchor),
            paymentCardsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            paymentCardsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            paymentCardsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNewCard.topAnchor.constraint(equalTo: paymentCardsCollectionView.bottomAnchor),
            addNewCard.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            useGiftCard.bottomAnchor.constraint(equalTo: cancelPayment.topAnchor),
            useGiftCard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            useGiftCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completePayment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completePayment.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            completePayment.bottomAnchor.constraint(equalTo: useGiftCard.topAnchor),
            cancelPayment.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelPayment.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            cancelPayment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
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
    
    @objc
    func onCancelPayment() {
        self.dismiss(animated: true, completion: nil)
    }

}

