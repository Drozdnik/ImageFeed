import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: UIViewController {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func updateLabels()
}

class ProfileViewController: UIViewController, ProfileViewControllerProtocol{
    
    private let profileService = ProfileService.sharedProfile
    private lazy var nameLabel = UILabel()
    private lazy var idLabel = UILabel()
    private lazy var statusLabel = UILabel()
    var presenter: ProfilePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureConstraints()
    }
    
    func addSubviews(){
        view.addSubview(avatarImageView)
        view.addSubview(exitButton)
    }
    
    private func configureConstraints(){
        nameLabel = createLabel("Name", size: 23, color: .white)
        nameLabel.accessibilityIdentifier = "Name Lastname"
        idLabel = createLabel("@Id", color: .gray)
        idLabel.accessibilityIdentifier = "@username"
        statusLabel = createLabel("Status", color: .white)
        view.backgroundColor = customBlack
        view.addSubview(nameLabel)
        view.addSubview(idLabel)
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            idLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            
            exitButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private lazy var avatarImageView: UIImageView = {
        let profileImage = UIImage(named: "avatar")
        let avatarImageView = UIImageView(image: profileImage)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.layer.masksToBounds = true
        return avatarImageView
    }()
    
    private lazy var exitButton: UIButton = {
        let exitButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(didTapButton)
        )
        
        exitButton.tintColor = customRedForBackButton
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.accessibilityIdentifier = "logout button"
        return exitButton
    }()
    
    private func createLabel(_ text: String, size: CGFloat = 13, color: UIColor = .white, font:UIFont = UIFont.boldSystemFont(ofSize: 13)) -> UILabel{
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    internal func updateLabels(){
        if let profile = presenter?.updateLabels(){
            nameLabel.text = profile.name
            idLabel.text = profile.loginName
            statusLabel.text = profile.bio
        } else {
            return
        }
    }
    
    func updateAvatar(url: URL){
        avatarImageView.kf.setImage(with: url)
    }
    
    
    
    @objc private func didTapButton(){
        let alertController = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Да", style: .default) {[weak self] _ in
            self?.presenter?.logout()
            self?.presenter?.toSplashViewController()
        }
        
        let cancelAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
}
