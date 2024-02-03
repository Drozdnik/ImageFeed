import UIKit
class AuthViewController: UIViewController{
    private let segueIdToWebView:String = "ShowWebView"
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        configureConstraints()
    }
    
    private func addSubViews(){
        view.addSubview(authButton)
        view.addSubview(logoImageView)
        view.backgroundColor = customBlack
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            authButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            authButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    private lazy var logoImageView: UIImageView = {
        let logoImage = UIImage(named: "authScreenLogo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoImageView
    }()
    
    private lazy var authButton: UIButton = {
        let authButton = UIButton(type: .system)
        authButton.setTitle("Войти", for: .normal)
        authButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        authButton.setTitleColor(customBlack, for: .normal)
        authButton.backgroundColor = customWhiteBackGrounds
        authButton.layer.cornerRadius = 16
        authButton.layer.masksToBounds = true
        authButton.translatesAutoresizingMaskIntoConstraints = false
        authButton.addTarget(self, action: #selector (didTapButton), for: .touchUpInside)
        return authButton
    }()
    
    @objc private func didTapButton(){
        self.performSegue(withIdentifier: segueIdToWebView, sender: self)
    }
}
