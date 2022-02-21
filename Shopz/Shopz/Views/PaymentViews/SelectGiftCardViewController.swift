//
//  SelectGiftCardViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 09/02/22.
//

import UIKit

class SelectGiftCardViewController: UIViewController {

    let backgroundView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.shopzBackGroundColor.withAlphaComponent(0.5)
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.shopzBackGroundColor
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Buy gift card", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.layer.cornerRadius = 6
        button.setTitleColor(.white, for: .normal)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10)
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let donebutton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select a gift Card"
        label.font = .monospacedSystemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let giftCardsList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumLineSpacing = 5
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(GiftCardCollectionViewCell.self, forCellWithReuseIdentifier: GiftCardCollectionViewCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isUserInteractionEnabled = true
        cv.backgroundColor = .clear
        return cv
    }()
    
    var cards: [GiftCardData] = []
    
    var selectedCard: GiftCardData?
    var requiredAmount: Double?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .clear

        
        button.addTarget(self, action: #selector(onAddCard), for: .touchUpInside)
        donebutton.addTarget(self, action: #selector(onDismiss), for: .touchUpInside)
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDismiss)))
        
        giftCardsList.delegate = self
        giftCardsList.dataSource = self
        
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(giftCardsList)
        containerView.addSubview(donebutton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(button)
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.98),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            giftCardsList.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            giftCardsList.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            giftCardsList.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            giftCardsList.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5),
            
            donebutton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            donebutton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            
            titleLabel.centerYAnchor.constraint(equalTo: donebutton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            button.bottomAnchor.constraint(equalTo: giftCardsList.topAnchor, constant: 5),
            button.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
        ])
        
        self.loadData()
    }
    
    func loadData() {
        self.cards = ApplicationDB.shared.getGiftCards()
        self.giftCardsList.reloadData()
    }

    @objc
    func onDismiss() {
        self.backgroundView.alpha = 0
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func onAddCard() {
        let addGiftVC = AddGiftCardViewController()
        addGiftVC.delegate = self
        self.present(addGiftVC, animated: true, completion: nil)
    }

}

extension SelectGiftCardViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiftCardCollectionViewCell.cellID, for: indexPath) as! GiftCardCollectionViewCell
        cell.cardData = cards[indexPath.row]
        cell.selectState = selectedCard?.id == cell.cardData?.id
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCard = cards[indexPath.row]
        guard let required = requiredAmount else { return }
        if cards[indexPath.row].amount <= required {
            Toast.shared.showToast(message: "Please select a card with enough amount",type: .error)
            self.selectedCard = nil
            return
        }
        if let vc = self.presentingViewController as? PaymentViewController {
            vc.selectedGiftCard = cards[indexPath.row]
            vc.selectedCard = nil
            vc.paymentCardsCollectionView.reloadData()
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height + 50, height: collectionView.frame.height - 5)
    }
}

extension SelectGiftCardViewController: AddGiftCardDelegate {
    func onAddCardcomplete() {
        self.loadData()
    }
}
