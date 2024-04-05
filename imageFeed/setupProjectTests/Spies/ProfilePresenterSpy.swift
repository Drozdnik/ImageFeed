//
//  ProfilePresenterSpy.swift
//  imageFeed
//
//  Created by Михаил  on 30.03.2024.
//

import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    
    var view: ProfileViewControllerProtocol?
    var viewDidloadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidloadCalled = true
    }
    
    func updateAvatar() {   }
    
    func logout() {   }
    

    
    func updateLabels() -> Profile? {
        return nil
    }
    
    func toSplashViewController() {

    }
}
