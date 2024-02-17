
import UIKit
import ProgressHUD

class SplashViewController: UIViewController{
    
    private let showAuthScreenSegue = "ShowAuthenticationScreen"
    private let outh2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        configureConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage().token{
            toBarController()
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
        ProgressHUD.show()
        dismiss(animated: true){ [weak self] in
            guard let self = self else {return}
            self.fetchToken(code)
            toBarController()
        }
    }
    
    private func fetchToken(_ code: String){
        outh2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success:
                self.toBarController()
                ProgressHUD.dismiss()
            case .failure:
                // will do in 11
                ProgressHUD.dismiss()
                break
            }
        }
    }
}
