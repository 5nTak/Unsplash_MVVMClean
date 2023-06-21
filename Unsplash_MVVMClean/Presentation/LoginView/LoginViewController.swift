//
//  LoginViewController.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/16.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    private var emailTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.keyboardType = .emailAddress
        textField.setupPlaceholder(placeholder: "Email", color: .lightGray)
        
        return textField
    }()
    
    private var passwordTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.setupPlaceholder(placeholder: "Password", color: .lightGray)
        
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("login".localized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(executeLogin), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var forgetPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("find_password".localized, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(showResetPasswordVC), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("join".localized, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(showJoinVC), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func executeLogin() {
        view.endEditing(true)
        
        let title = "login_result".localized
        var message = "login_result_message".localized
        
        if emailTextField.text?.isEmpty ?? true {
            emailTextField.setError()
            message = "input_error_message".localized
        }
        
        if passwordTextField.text?.isEmpty ?? true {
            passwordTextField.setError()
            message = "input_error_message".localized
        }
        
        let loginResultAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let successAction = UIAlertAction(title: "ok", style: .default)
        loginResultAlert.addAction(successAction)
        present(loginResultAlert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigatonBar()
        setupLayout()
    }
    
    @objc private func showResetPasswordVC() {
        let resetPasswordVC = ResetPasswordViewController()
        navigationController?.pushViewController(resetPasswordVC, animated: true)
    }

    @objc private func showJoinVC() {
        let joinVC = JoinViewController()
        navigationController?.pushViewController(joinVC, animated: true)
    }
    
    private func setupNavigatonBar() {
        navigationItem.title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        
        [
            emailTextField,
            passwordTextField,
            loginButton,
            forgetPasswordButton,
            joinButton
        ].forEach {
            view.addSubview($0)
        }
        
        let spacing: CGFloat = 20
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(50)
        }
        
        forgetPasswordButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(forgetPasswordButton.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
    }
}
