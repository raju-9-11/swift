//
//  CheckoutViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit
import CryptoKit

class CheckoutViewController: CustomViewController {
    
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
    
    var shoppingList: ShoppingList?
    var cart: [CartItem] = []
    var product: Product?
    
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
    
    var values: (totalItems: Double, shippingCost: Double, totalCost: Double) = (0,0,0) {
        willSet {
            billingLabels = [defaultLabel(text: "\(newValue.totalItems)"), defaultLabel(text: "\(newValue.shippingCost)"), defaultLabel(text: "\(newValue.totalCost)")]
        }
    }
    
    lazy var billingLabels: [UILabel] = [defaultLabel(text: "0"), defaultLabel(text: "0.0"), defaultLabel(text: "0.0")]
    
    let giftWrapView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let giftWrapText: TextFieldWithError = {
        let textField = TextFieldWithError()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name on gift wrap"
        textField.isHidden = true
        textField.error = "Name Cannot be empty"
        return textField
    }()
    
    let giftWrapSwitch: CheckBox = {
        let giftSwitch = CheckBox()
        giftSwitch.translatesAutoresizingMaskIntoConstraints = false
        return giftSwitch
    }()
    
    let giftWrapLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Should be giftwrapped"
        label.font = .italicSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [giftWrapSwitch, giftWrapLabel])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 2
        return stack
    }()
    
    var selectedAddress: Int = 0 {
        didSet {
            addressList.reloadData()
        }
    }
    
    let addressList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
        cv.register(AddressItemCollectionViewCell.self, forCellWithReuseIdentifier: AddressItemCollectionViewCell.cellID)
        cv.register(AddAddressCollectionViewCell.self, forCellWithReuseIdentifier: AddAddressCollectionViewCell.cellID)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    lazy var addressDetails: UILabel = {
        return titleLabel(text: "Address Details")
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue to Payment", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return button
    }()
    
    var addressListData: [Address] = []
    
    var paymentVC: PaymentViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    func onAddClick() {
        let addAddressVC = AddAddressViewController()
        addAddressVC.delegate = self
        present(addAddressVC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override func setupLayout() {
        view.backgroundColor = UIColor(named: "background_color")
        
        giftWrapText.delegate = self
        continueButton.addTarget(self, action: #selector(onContinue), for: .touchUpInside)
        giftWrapSwitch.delegate = self
        
        billingDetailsContainer.addArrangedSubview(newStackView(views: [defaultLabel(text: "Total number of items"), billingLabels[0]]))
        billingDetailsContainer.addArrangedSubview(newStackView(views: [defaultLabel(text: "Total product cost"), billingLabels[2]]))
        billingDetailsContainer.addArrangedSubview(newStackView(views: [defaultLabel(text: "Shipping cost"), billingLabels[1]]))
        topView.addSubview(cartDetails)
        topView.addSubview(billingDetailsContainer)
        
        giftWrapView.addArrangedSubview(stack)
        giftWrapView.addArrangedSubview(giftWrapText)
        
        addressList.dataSource = self
        addressList.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(paymentComplete), name: NSNotification.Name.paymentCompletion, object: nil)
        
        topView.addSubview(backGroundView)
        view.addSubview(topView)
        view.addSubview(giftWrapView)
        view.addSubview(addressDetails)
        view.addSubview(addressList)
        view.addSubview(continueButton)
        
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
            giftWrapView.topAnchor.constraint(equalTo: backGroundView.bottomAnchor, constant: 5),
            giftWrapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            giftWrapView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            addressDetails.topAnchor.constraint(equalTo: giftWrapView.bottomAnchor, constant: 5),
            addressDetails.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 5),
            addressList.topAnchor.constraint(equalTo: addressDetails.bottomAnchor, constant: 5),
            addressList.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            addressList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addressList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        self.loadData()
    }
    
    func loadData() {
        self.addressListData = ApplicationDB.shared.getAddressList()
        self.addressList.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.paymentCompletion, object: nil)
        paymentVC = nil
        shoppingList = nil
        product = nil
    }
    
    func bind(with product: Product) {
        self.product = product
        billingLabels[0].text = "1"
        billingLabels[1].text = "$ \(product.shipping_cost)"
        billingLabels[2].text = "$ \(product.price)"
    }
    
    func bind(with cart: [CartItem]) {
        self.cart = cart
        billingLabels[0].text = "\(cart.count)"
        billingLabels[1].text = "$ \((cart.map({ item in return item.product.shipping_cost }).reduce(0, +)))"
        billingLabels[2].text = "$ \(cart.map({ item in return item.product.price }).reduce(0, +))"
    }
    
    func bind(with list: [CartItem], shoppingList: ShoppingList) {
        self.shoppingList = shoppingList
        self.cart = list
        billingLabels[0].text = "\(list.count)"
        billingLabels[1].text = "$ \((list.map({ item in return item.product.shipping_cost }).reduce(0, +)))"
        billingLabels[2].text = "$ \(list.map({ item in return item.product.price }).reduce(0, +))"
    }
    
    func newStackView(views: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        return stack
    }
    
    func defaultLabel(text: String ) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .monospacedSystemFont(ofSize: 15, weight: .semibold)
        return label
    }
    
    func titleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .monospacedSystemFont(ofSize: 20, weight: .heavy)
        return label
    }
    
    func shouldReturn(_ textField: TextFieldWithError) {
        if textField == giftWrapText {
            self.view.endEditing(true)
        }
    }
    
    @objc
    func paymentComplete(_ notification: Notification) {
        if let stat = (notification.userInfo as? [String: Any])?["Status"] as? String {
            if stat == "success" {
                print("Payment Success")
            }
        }
        print("Payment Complete")
        self.dismiss(animated: true, completion: nil)
        if let vc = self.parent as? CartViewController {
            vc.loadData()
        }
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @objc
    func onContinue() {
        if (giftWrapSwitch.isOn && giftWrapText.text.isEmpty) {
            giftWrapText.errorState = true
            return
        }
        if addressListData.count < 1 {
            Toast.shared.showToast(message: "You should provide atleast one address", type: .error)
            return
        }
        giftWrapText.errorState = false
        if paymentVC == nil {
            paymentVC = PaymentViewController()
            paymentVC?.product = self.product
            if !self.cart.isEmpty {
                paymentVC?.cart = self.cart
            }
            paymentVC?.shoppingListData = self.shoppingList
        }
        self.present(paymentVC!, animated: true)
    }

}

extension CheckoutViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addressListData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == addressListData.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddAddressCollectionViewCell.cellID, for: indexPath) as! AddAddressCollectionViewCell
            cell.setupLayout()
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressItemCollectionViewCell.cellID, for: indexPath) as! AddressItemCollectionViewCell
        cell.isCustSelected = selectedAddress == indexPath.row
        cell.address = addressListData[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if indexPath.row != selectedAddress && indexPath.row != addressListData.count {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: {
                _ in
                let delete = UIAction(title: "Delete Address", image: UIImage(systemName: "trash"), attributes: .destructive, handler: {
                    _ in
                    ApplicationDB.shared.removeAddress(address: self.addressListData[indexPath.row])
                    self.addressListData = ApplicationDB.shared.getAddressList()
                    self.addressList.deleteItems(at: [indexPath])
                    self.addressList.reloadData()
                })
                
                return UIMenu(children: [delete])
            })
        }
        return UIContextMenuConfiguration()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.48, height: collectionView.frame.width*0.48)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < addressListData.count {
            self.selectedAddress = indexPath.row
        } else {
            onAddClick()
        }
        self.view.endEditing(true)
    }
}

extension CheckoutViewController: CheckBoxDelegate, TextFieldWithErrorDelegate, AddAddressDelegate {
    
    func onToggle(_ elem: CheckBox) {
        UIView.animate(withDuration: 0.5, animations: {
            self.giftWrapText.alpha = elem.isOn ? 1 : 0
            self.giftWrapText.isHidden = !elem.isOn
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
        })
        self.view.endEditing(true)
    }
    
    func addAddressClick(_ address: Address) {
        ApplicationDB.shared.addAddress(address: address)
        self.loadData()
    }
}

extension Notification.Name {
    static var paymentCompletion: Notification.Name {
          return .init(rawValue: "Payment.Complete")
    }
    static var userLogin: Notification.Name {
        return .init(rawValue: "User.Login.Success")
    }
    
    static var userLogout: Notification.Name {
        return .init(rawValue: "User.Logout.success")
    }
    static var cartUpdate: Notification.Name {
        return .init(rawValue: "Cart.Update.success")
    }
    static var profileUpdate: Notification.Name {
        return .init(rawValue: "Profile.update.success")
    }
}
