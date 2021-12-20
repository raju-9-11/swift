//
//  LoginViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.954, green: 0.843, blue: 0.843, alpha: 1)
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        return view
    }()
    
    let signUpView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let signupLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account? "
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        button.setTitleColor(UIColor(red: 0.692, green: 0.582, blue: 0.582, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signInLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.font = .systemFont(ofSize: 36, weight: .heavy)
        return label
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You have to sign to continue"
        label.sizeToFit()
        label.font = .italicSystemFont(ofSize: 15)
        label.textColor = UIColor(red: 0.692, green: 0.582, blue: 0.582, alpha: 1)
        return label
    }()
    
    let emailField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Email"
        return textField
    }()
    
    let passwordField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.placeholder = "Enter Password"
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" login ", for: .normal)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            config.cornerStyle = .medium
            config.baseBackgroundColor = UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1)
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.backgroundColor = UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1)
            button.layer.cornerRadius = 6
        }
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var delegate: ModalViewDelegate?

    // MARK: - Load view
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6
        
        topView.addSubview(errorLabel)
        view.addSubview(topView)
        loginButton.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        signupButton.addTarget(self.presentingViewController, action: #selector(onSignup), for: .touchUpInside)
        
        
        signUpView.addSubview(signupLabel)
        signUpView.addSubview(signupButton)
        
        containerView.addSubview(signInLabel)
        containerView.addSubview(emailField)
        containerView.addSubview(passwordField)
        containerView.addSubview(loginButton)
        containerView.addSubview(signUpView)
        
        view.addSubview(containerView)
        
        self.setupLayout()
    }
    
    
    // MARK: - Functions
    
    @objc
    func onLogin() {
        let auth = Auth()
        auth.userName = "Mario"
        auth.authToken = "Stringasa231wasasd"
        delegate?.sendState(vc: self, auth)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func onSignup() {
        let vc = SignUpViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.widthAnchor.constraint(equalTo: view.widthAnchor),
            topView.heightAnchor.constraint(equalToConstant: 40),
            topView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 30),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            signInLabel.bottomAnchor.constraint(equalTo: emailField.topAnchor, constant: -10),
            signInLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emailField.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -10),
            emailField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            emailField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: containerView.centerYAnchor),
            passwordField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            passwordField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            loginButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            signUpView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            signUpView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            signUpView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            signUpView.heightAnchor.constraint(equalToConstant: 40),
            signupLabel.leftAnchor.constraint(equalTo: signUpView.leftAnchor),
            signupLabel.centerYAnchor.constraint(equalTo: signUpView.centerYAnchor),
            signupButton.leftAnchor.constraint(equalTo: signupLabel.rightAnchor),
            signupButton.centerYAnchor.constraint(equalTo: signUpView.centerYAnchor),
            signupButton.rightAnchor.constraint(equalTo: signUpView.rightAnchor),
        ])
    }
}

