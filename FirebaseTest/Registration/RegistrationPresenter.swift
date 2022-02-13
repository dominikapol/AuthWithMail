//
//  RegistrationPresenter.swift
//  FirebaseTest
//
//  Created Dominika Poleschuk on 11.02.22.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation
import Firebase

// MARK: View -
protocol RegistrationViewProtocol: class {
    func showUserInfoScreen(userID: String)
}

// MARK: Presenter -
protocol RegistrationPresenterProtocol: class {
	var view: RegistrationViewProtocol? { get set }
    
    func viewDidLoad()
    func changeRegistrationMethod(selectedIndex: Int)
    func authenticate(email: String?, password: String?)
}

enum RegistrationMethod {
    case registration
    case login
}

class RegistrationPresenter: RegistrationPresenterProtocol {

    weak var view: RegistrationViewProtocol?

    private var registrationMethod: RegistrationMethod = .registration
    
    func viewDidLoad() {

    }
    
    func changeRegistrationMethod(selectedIndex: Int) {
        if selectedIndex == 0 {
            registrationMethod = .login
        } else {
            registrationMethod = .registration
        }
    }
    
    func authenticate(email: String?, password: String?) {
        guard let email = email,
              let password = password else {
            return
        }

        switch registrationMethod {
        case .registration:
            Auth.auth().createUser(
                withEmail: email,
                password: password,
                completion: { result, error in
                    print("registration",result, error)
                    let user = result?.user
                    user?.sendEmailVerification(completion: { error in
                        
                    })
                }
            )
        case .login:
            Auth.auth().signIn(
                withEmail: email,
                password: password,
                completion: { result, error in
                    let userID = result?.user.uid ?? ""
                    self.view?.showUserInfoScreen(userID: userID)
                }
            )
        }
    }
}
