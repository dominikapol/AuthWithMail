//
//  RegistrationViewController.swift
//  FirebaseTest
//
//  Created Dominika Poleschuk on 11.02.22.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

class RegistrationViewController: UIViewController, RegistrationViewProtocol {
    
    
    @IBOutlet private weak var registrationMethodSegmentControll: UISegmentedControl!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
	var presenter: RegistrationPresenterProtocol = RegistrationPresenter()

	override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        presenter.viewDidLoad()
    }
    
    func showUserInfoScreen(userID: String) {
        guard let userInfoVC = UIStoryboard(name: "UserInfo", bundle: .main).instantiateViewController(withIdentifier: "UserInfoViewController") as? UserInfoViewController else {
            return
        }
        userInfoVC.presenter = UserInfoPresenter(userId: userID)
        navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
    @IBAction private func registrationMethodSegmentControllDidChange() {
        let selectedIndex = registrationMethodSegmentControll.selectedSegmentIndex
        presenter.changeRegistrationMethod(selectedIndex: selectedIndex)
    }
    
    @IBAction private func goButtonPressed() {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        presenter.authenticate(
            email: email,
            password: password
        )
    }
}
