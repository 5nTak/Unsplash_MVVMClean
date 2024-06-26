//
//  JoinViewController.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/16.
//

import UIKit
import SnapKit

final class JoinViewController: UIViewController {
    private var firstNameTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.setupPlaceholder(placeholder: "First Name".localized, color: .lightGray)
        
        return textField
    }()
    
    private var lastNameTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.setupPlaceholder(placeholder: "Last Name".localized, color: .lightGray)
        
        return textField
    }()
    
    private var userNameTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.setupPlaceholder(placeholder: "User Name".localized, color: .lightGray)
        
        return textField
    }()
    
    private var emailTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.keyboardType = .emailAddress
        textField.setupPlaceholder(placeholder: "Email".localized, color: .lightGray)
        
        return textField
    }()
    
    private var passwordTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.setupPlaceholder(placeholder: "Password".localized, color: .lightGray)
        
        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.setTitle("Sign Up".localized, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(trySignUp), for: .touchUpInside)
        return button
    }()
    
    private var agreeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.text = "join_title".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    @objc private func trySignUp() {
        view.endEditing(true)
        
        let title = "join_result".localized
        var message = "join_success".localized
        
        if firstNameTextField.text?.isEmpty ?? true {
            firstNameTextField.setError()
            message = "input_error_message".localized
        }
        
        if lastNameTextField.text?.isEmpty ?? true {
            lastNameTextField.setError()
            message = "input_error_message".localized
        }
        
        if userNameTextField.text?.isEmpty ?? true {
            userNameTextField.setError()
            message = "input_error_message".localized
        }
        
        if emailTextField.text?.isEmpty ?? true {
            emailTextField.setError()
            message = "input_error_message".localized
        }
        
        if passwordTextField.text?.isEmpty ?? true {
            passwordTextField.setError()
            message = "input_error_message".localized
        }
        
        let loginResultAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok".localized, style: .default, handler: nil)
        loginResultAlert.addAction(okAction)
        present(loginResultAlert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Join Unsplash".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        
        [
            firstNameTextField,
            lastNameTextField,
            userNameTextField,
            emailTextField,
            passwordTextField,
            signUpButton,
            agreeLabel
        ].forEach {
            view.addSubview($0)
        }
        
        let spacing = 20
        firstNameTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        lastNameTextField.snp.makeConstraints {
            $0.top.equalTo(firstNameTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        userNameTextField.snp.makeConstraints {
            $0.top.equalTo(lastNameTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(userNameTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(50)
        }
        
        agreeLabel.snp.makeConstraints {
            $0.top.equalTo(signUpButton.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
}
