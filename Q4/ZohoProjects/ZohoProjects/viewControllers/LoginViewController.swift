//
//  ViewController.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 21/11/21.
//

import UIKit

class LoginViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    var imageView: UICollectionView!
    var login: UIButton!
    var googleLoginButton: CustomGoogleButton!
    var signUpLabel: UILabel!
    var signUpButton: UIButton!
    var signupContainer: UIStackView!
    

    override func loadView() {
        super.loadView()
        
        view = UIView()
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 400)
        imageView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.dataSource = self
        imageView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        imageView.showsHorizontalScrollIndicator = false
        
        login = UIButton(type: .custom, primaryAction: UIAction(handler: {
            _ in 
            self.loginTapped()
        }))
        login.translatesAutoresizingMaskIntoConstraints = false
        login.setTitle("Sign In", for: .normal)
        login.setTitleColor(.white, for: .normal)
        login.backgroundColor = .systemGreen
        login.layer.cornerRadius = 2
        login.titleLabel?.font = .monospacedSystemFont(ofSize: 13, weight: .bold)
        login.layer.shadowOpacity = 0.8
        login.layer.shadowColor = UIColor.darkGray.cgColor
        login.layer.shadowRadius = 0.4
        login.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        googleLoginButton = CustomGoogleButton(type: .custom , primaryAction: UIAction(handler: {
            _ in
            print("GoogleLoginClicked")
        }))
        googleLoginButton.setTitleColor(.clear, for: .normal)
        googleLoginButton.customTitleLabel.text = "Sign In with Google"
        googleLoginButton.customTitleLabel.font = .monospacedSystemFont(ofSize: 13, weight: .bold)
        googleLoginButton.backgroundColor = .white
        googleLoginButton.layer.cornerRadius = 2
        googleLoginButton.layer.shadowOpacity = 0.8
        googleLoginButton.layer.shadowColor = UIColor.darkGray.cgColor
        googleLoginButton.layer.shadowRadius = 0.4
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        googleLoginButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        signUpLabel = UILabel()
        signUpLabel.font = .monospacedSystemFont(ofSize: 12, weight: .semibold)
        signUpLabel.text = "Don't have an account? "
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        signUpButton = UIButton(type: .system, primaryAction: UIAction(handler: {
            _ in
            print("SignUpClicked")
        }))
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Sign up", for: .normal)
        signUpButton.titleLabel?.font = .monospacedSystemFont(ofSize: 12, weight: .semibold)
        
        signupContainer = UIStackView(arrangedSubviews: [signUpLabel, signUpButton])
        signupContainer.translatesAutoresizingMaskIntoConstraints = false
        signupContainer.axis = .horizontal
        signupContainer.distribution = .fillProportionally
        
        view.addSubview(login)
        view.addSubview(googleLoginButton)
        view.addSubview(imageView)
        view.addSubview(signupContainer)
        self.setupNavigationController()
        self.setUpLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
        cell.contentMode = .scaleAspectFit
        return cell
    }
    
    
    func setUpLayout() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.7),
            login.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            login.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            login.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            login.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            googleLoginButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            googleLoginButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            googleLoginButton.topAnchor.constraint(equalTo: login.bottomAnchor, constant: 10),
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupContainer.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 10),
            signupContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.03),
            
        ])
    }
    
    func setupNavigationController() {
        self.navigationItem.title = "Login"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]

    }
    
    func loginTapped() {
        let mainVC = MainViewController()
        let feedVC = FeedViewController()
        let backLogVC = BackLogViewController()
        let sprintsVC = SprintsViewController()
        let boardVC = BoardViewController()
        mainVC.viewControllers = [feedVC, backLogVC, sprintsVC, boardVC]
        mainVC.selectedViewController = feedVC
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "BackLog"), tag: 0)
        feedVC.tabBarItem.title = "Feed"
        backLogVC.tabBarItem = UITabBarItem(title: "BackLog", image: UIImage(named: "BackLog"), tag: 1)
        backLogVC.tabBarItem.title = "BackLog"
        sprintsVC.tabBarItem = UITabBarItem(title: "Sprints", image: UIImage(named: "BackLog"), tag: 2)
        sprintsVC.tabBarItem.title = "Sprints"
        boardVC.tabBarItem = UITabBarItem(title: "Board", image: UIImage(named: "BackLog"), tag: 3)
        self.navigationController?.pushViewController(mainVC, animated: true)
    }


}



