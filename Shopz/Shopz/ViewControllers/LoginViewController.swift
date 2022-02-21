//
//  LoginViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class LoginViewController: UIViewController, TextFieldWithErrorDelegate {
    
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
        view.backgroundColor = UIColor.shopzBackGroundColor
        view.layer.cornerRadius = 6
        return view
    }()
    
    let signUpView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 0
        view.distribution = .fillProportionally
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let signupLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account? "
        label.textColor = UIColor.appTextColor
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
        label.textColor = UIColor.appTextColor
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

    let emailField: TextFieldWithError = {
        let emailField = TextFieldWithError()
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.placeholder = "Enter Email"
        emailField.keyBoardType = .emailAddress
        emailField.error = "Email cannot be empty"
        return emailField
    }()
    
    let passwordField: TextFieldWithError = {
        let passwordField = TextFieldWithError()
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.placeholder = "Enter Password"
        passwordField.error = "Password cannot be empty"
        passwordField.isSecureTextEntry = true
        return passwordField
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

    // MARK: - Load view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailField.text = ""
        passwordField.text = ""
        emailField.errorState = false
        passwordField.errorState = false
    }
    
    
    // MARK: - Functions
    
    @objc
    func onLogin() {
        self.view.endEditing(true)
        let email = emailField.text
        let password = passwordField.text
        emailField.errorState = email.isEmpty
        passwordField.errorState = password.isEmpty
        if email.isEmpty || password.isEmpty {
            return
        }
        switch ApplicationDB.shared.verifyUser(email: email, password: password) {
        case .success(let user):
            if let _ = ApplicationDB.shared.createSession(user: user) {
                ApplicationDB.shared.getCurrentUser()
                Toast.shared.showToast(message: "User Logged in", type: .success)
            }
        case .failure(let err):
            switch err {
            case .userNotFound:
                Toast.shared.showToast(message: "User not found", type: .error)
            case .dataNotFound:
                Toast.shared.showToast(message: "Unable to contact database", type: .error)
            case .invalidPassword:
                Toast.shared.showToast(message: "Password Invalid", type: .error)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func shouldReturn(_ textField: TextFieldWithError) {
        if textField == emailField {
            textField.removeFirstResponder()
            passwordField.makeFirstResponder()
        } else {
            passwordField.removeFirstResponder()
            self.onLogin()
        }
    }
    
    @objc
    func onSignup() {
        let vc = SignUpViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func setupLayout() {
        emailField.delegate = self
        passwordField.delegate = self
        view.backgroundColor = .systemGray
        
        topView.addSubview(errorLabel)
        view.addSubview(topView)
        
        loginButton.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        signupButton.addTarget(self.presentingViewController, action: #selector(onSignup), for: .touchUpInside)
        
        signUpView.addArrangedSubview(signupLabel)
        signUpView.addArrangedSubview(signupButton)
        
        containerView.addSubview(signInLabel)
        containerView.addSubview(emailField)
        containerView.addSubview(passwordField)
        containerView.addSubview(loginButton)
        containerView.addSubview(signUpView)
        
        view.addSubview(containerView)
        
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
            signUpView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            signUpView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

