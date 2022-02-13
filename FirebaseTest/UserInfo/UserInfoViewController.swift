//
//  UserInfoViewController.swift
//  FirebaseTest
//
//  Created Dominika Poleschuk on 11.02.22.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

class UserInfoViewController: UIViewController, UserInfoViewProtocol {
    @IBOutlet private weak var tableView: UITableView!
    
	var presenter: UserInfoPresenterProtocol!

	override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        presenter.viewDidLoad()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    @IBAction private func addCarButtonPressed() {
        let alertController = UIAlertController(title: "Add Car", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Car name"
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            self.presenter.createCar(name: textField.text ?? "")
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension UserInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = presenter.car(for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfCars()
    }
}
