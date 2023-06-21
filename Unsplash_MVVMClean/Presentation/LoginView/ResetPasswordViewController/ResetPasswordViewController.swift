//
//  ResetPasswordViewController.swift
//  Unsplash_MVVMClean
//
//  Created by Tak on 2023/06/16.
//

import UIKit
import SnapKit

final class ResetPasswordViewController: UIViewController {
    private var inputEmailTextField: UnderLineTextField = {
        let textField = UnderLineTextField()
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.keyboardType = .emailAddress
        textField.setupPlaceholder(placeholder: "Email", color: .lightGray)
        
        return textField
    }()
    
    private lazy var findButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
    }
    
    @objc private func resetPassword() {
        view.endEditing(true)
        
        let title = "reset".localized
        var message = "reset_message".localized
        
        if inputEmailTextField.text?.isEmpty ?? true {
            inputEmailTextField.setError()
            message = "input_error_message".localized
        }
        
        let loginResultAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok".localized, style: .default, handler: nil)
        loginResultAlert.addAction(okAction)
        present(loginResultAlert, animated: true)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Reset Password"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        
        [
            inputEmailTextField,
            findButton
        ].forEach {
            view.addSubview($0)
        }
        
        let spacing = 20
        inputEmailTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        findButton.snp.makeConstraints {
            $0.top.equalTo(inputEmailTextField.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(50)
        }
    }
}
