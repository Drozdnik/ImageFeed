
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController{
    
    private let showAuthScreenSegue = "ShowAuthenticationScreen"
    private let outh2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.sharedProfile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        configureConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage().token{
            profileService.fetchProfile(token) { [weak self] result in
                guard let self = self else {return}
                
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.toBarController()
                    }
                case .failure:
                    debugPrint("Не удалось выполнить profileService.fetchProfile")
                }
            }
        } else {
            performSegue(withIdentifier: showAuthScreenSegue, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func toBarController(){
        guard let window = UIApplication.shared.windows.first else {fatalError("Invalid conf")}
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarController") //Вот тут упасть может
        window.rootViewController = tabBarController
    }
    
    private func addSubViews(){
        view.addSubview(logoImage)
        view.backgroundColor = customBlack
    }
    
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    private lazy var logoImage: UIImageView = {
        let logoImage = UIImage(named: "launch")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoImageView
    }()
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthScreenSegue {
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { assertionFailure("Failed to prepare fo \(showAuthScreenSegue)")
                return
            }
            
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController:AuthViewControllerDelegate{
    func authViewController(_ vc: AuthViewController, didAuthWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true){ [weak self] in
            guard let self = self else {return}
            fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String){
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code){ [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let token):
                    self.fetchProfile(token.accessToken)
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    self.presentAlertOnTopViewController(message: "Не удалось войти в систему")
                }
            }
        }
    }
    
    
    private func fetchProfile(_ token: String){
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) {[weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let profile):
                    ProfileImageService.shared.fetchProfileImage(userName: profile.username) {_ in}
                    self.toBarController()
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.presentAlertOnTopViewController(message: "Не удалось получить данные профиля")
                }
            }
        }
    }
}



