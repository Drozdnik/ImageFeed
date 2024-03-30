import Foundation
import UIKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func updateAvatar()
    func updateLabels() -> Profile?
    func logout()
    func viewDidLoad()
    func toSplashViewController()
}

final class ProfileViewPresenter: ProfilePresenterProtocol{
    var view: ProfileViewControllerProtocol?
    
    init (view: ProfileViewControllerProtocol){
        self.view = view
    }
    private var logoutService = ProfileLogoutService.shared
        func logout() {
        logoutService.logout()
    }
    
    func viewDidLoad(){
        updateAvatar()
        view?.updateLabels()
    }
    
    func updateAvatar(){
        guard
            let profileImageUrl = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageUrl) else {
            return
        }
        view?.updateAvatar(url: url)
    }
    
    func updateLabels() -> Profile?{
        guard let profile = ProfileService.sharedProfile.profile else {return nil}
        return profile
    }
    
    func toSplashViewController(){
        guard let window = UIApplication.shared.windows.first else {return}
        let splashViewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "SplashViewController")
        window.rootViewController = splashViewController
    }
}
