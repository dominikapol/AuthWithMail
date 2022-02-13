//
//  UserInfoPresenter.swift
//  FirebaseTest
//
//  Created Dominika Poleschuk on 11.02.22.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation
import FirebaseDatabase

// MARK: View -
protocol UserInfoViewProtocol: class {
    func reloadData()
}

// MARK: Presenter -
protocol UserInfoPresenterProtocol: class {
	var view: UserInfoViewProtocol? { get set }
    
    func viewDidLoad()
    func car(for indexPath: IndexPath) -> String
    func numberOfCars() -> Int
    func createCar(name: String)
}

class UserInfoPresenter: UserInfoPresenterProtocol {
    weak var view: UserInfoViewProtocol?
    private let userId: String
    private var cars: [Car] = []
    private var database: DatabaseReference!
    
    init(userId: String) {
        self.userId = userId
        Database.database().isPersistenceEnabled = true
    }

    func viewDidLoad() {
        database = Database.database().reference()
        
        database.child(userId).setValue(nil)
    }
    
    func car(for indexPath: IndexPath) -> String {
        let car = cars[indexPath.row]
        return car.name
    }
    
    func numberOfCars() -> Int {
        return cars.count
    }
    
    func createCar(name: String) {
        let car = Car(name: name)
        addCarToFirebase(car: car)
        cars.append(car)
        view?.reloadData()
    }
    
    private func addCarToFirebase(car: Car) {
        database
            .child(userId)
            .child("Cars")
            .child("\(cars.count)")
            .setValue(["name": car.name])
    }
    
    private func readCarsForFirebase() {
        database
            .child(userId)
            .child("Cars")
            .getData { error, snapshot in
                guard let cars = snapshot.value as? [[String: String]] else {
                    return
                }
                
                self.cars = cars.compactMap({ (dicationary) in
                    guard let name = dicationary["name"] else {
                        return nil
                    }
                    return Car(name: name)
                })
                self.view?.reloadData()
            }
    }
}

struct Car: Codable {
    let name: String
}
