//
//  CheckoutViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit

class CheckoutViewController: CustomViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AddAddressCellDelegate {
    
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
    
    let totalItemsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total number of items"
        return label
    }()
    
    let shippingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Shipping Cost"
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total Cost"
        return label
    }()
    
    let totalItemsLabelCost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$ 0"
        return label
    }()
    
    let shippingLabelCost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$ 0"
        return label
    }()
    
    let totalLabelCost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$ 0"
        return label
    }()
    
    let giftWrapView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let giftWrapText: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name on gift wrap"
        textField.isHidden = true
        return textField
    }()
    
    let giftWrapSwitch: UISwitch = {
        let giftSwitch = UISwitch()
        giftSwitch.translatesAutoresizingMaskIntoConstraints = false
        return giftSwitch
    }()
    
    let addressList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 2
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
        cv.register(AddressItemCollectionViewCell.self, forCellWithReuseIdentifier: AddressItemCollectionViewCell.cellID)
        cv.register(AddAddressCollectionViewCell.self, forCellWithReuseIdentifier: AddAddressCollectionViewCell.cellID)
        cv.backgroundColor = .clear
        return cv
    }()
    
    let addressDetails: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Address Details"
        return label
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue to Payment", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
    let addressListData: [String] = {
        return ["String string sgring asdf as ", "SDFSDF fsdfs , sdsdfs fsdfsd ", "dsfsdfsd", "String Sgring ,fsdfsd","String string sgring asdf as ", "SDFSDF fsdfs , sdsdfs fsdfsd ", "dsfsdfsd", "String Sgring ,fsdfsd"]
    }()
    
    let pvc = PaymentViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addressListData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == addressListData.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAddressCollectionViewCell.cellID, for: indexPath) as! AddAddressCollectionViewCell
            cell.setupLayout()
            cell.delegate = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressItemCollectionViewCell.cellID, for: indexPath) as! AddressItemCollectionViewCell
        cell.address = addressListData[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.48, height: collectionView.frame.width*0.48)
    }
    
    func onAddClick() {
        print("Add Clicked")
    }
    
    override func setupLayout() {
        view.backgroundColor = .white
        
        continueButton.addTarget(self, action: #selector(onContinue), for: .touchUpInside)
        giftWrapSwitch.addTarget(self, action: #selector(onGiftwrapToggle), for: .valueChanged)
        
        billingDetailsContainer.addSubview(totalItemsLabel)
        billingDetailsContainer.addSubview(totalItemsLabelCost)
        billingDetailsContainer.addSubview(shippingLabel)
        billingDetailsContainer.addSubview(shippingLabelCost)
        billingDetailsContainer.addSubview(totalLabel)
        billingDetailsContainer.addSubview(totalLabelCost)
        topView.addSubview(cartDetails)
        topView.addSubview(billingDetailsContainer)
        
        giftWrapView.addSubview(giftWrapText)
        giftWrapView.addSubview(giftWrapSwitch)
        
        addressList.dataSource = self
        addressList.delegate = self
        
        
        view.addSubview(topView)
        view.addSubview(giftWrapView)
        view.addSubview(addressDetails)
        view.addSubview(addressList)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            topView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cartDetails.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 20),
            cartDetails.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20),
            billingDetailsContainer.topAnchor.constraint(equalTo: cartDetails.bottomAnchor),
            billingDetailsContainer.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            billingDetailsContainer.widthAnchor.constraint(equalTo: topView.widthAnchor),
            billingDetailsContainer.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            shippingLabel.centerYAnchor.constraint(equalTo: billingDetailsContainer.centerYAnchor),
            shippingLabel.leftAnchor.constraint(equalTo: billingDetailsContainer.leftAnchor),
            shippingLabelCost.centerYAnchor.constraint(equalTo: billingDetailsContainer.centerYAnchor),
            shippingLabelCost.rightAnchor.constraint(equalTo: billingDetailsContainer.rightAnchor),
            totalItemsLabel.bottomAnchor.constraint(equalTo: shippingLabel.topAnchor),
            totalItemsLabel.leftAnchor.constraint(equalTo: shippingLabel.leftAnchor),
            totalItemsLabelCost.bottomAnchor.constraint(equalTo: shippingLabel.topAnchor),
            totalItemsLabelCost.rightAnchor.constraint(equalTo: billingDetailsContainer.rightAnchor),
            totalLabel.topAnchor.constraint(equalTo: shippingLabel.bottomAnchor),
            totalLabel.leftAnchor.constraint(equalTo: billingDetailsContainer.leftAnchor),
            totalLabelCost.topAnchor.constraint(equalTo: shippingLabel.bottomAnchor),
            totalLabelCost.rightAnchor.constraint(equalTo: billingDetailsContainer.rightAnchor),
            giftWrapView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 5),
            giftWrapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            giftWrapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            giftWrapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            giftWrapText.centerXAnchor.constraint(equalTo: giftWrapView.centerXAnchor),
            giftWrapText.widthAnchor.constraint(equalTo: giftWrapView.widthAnchor, multiplier: 0.8),
            giftWrapText.topAnchor.constraint(equalTo: giftWrapView.topAnchor),
            giftWrapSwitch.topAnchor.constraint(equalTo: giftWrapText.bottomAnchor),
            giftWrapSwitch.leftAnchor.constraint(equalTo: giftWrapText.leftAnchor),
            addressDetails.topAnchor.constraint(equalTo: giftWrapView.bottomAnchor),
            addressDetails.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addressList.topAnchor.constraint(equalTo: addressDetails.bottomAnchor),
            addressList.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            addressList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addressList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc
    func onContinue() {
        pvc.modalPresentationStyle = .fullScreen
        pvc.modalTransitionStyle = .coverVertical
        self.present(pvc, animated: true)
    }
    
    @objc
    func onGiftwrapToggle(sender: UISwitch) {
        if sender.isOn {
            giftWrapText.isHidden = false
        } else {
            giftWrapText.isHidden = true
        }
    }

}