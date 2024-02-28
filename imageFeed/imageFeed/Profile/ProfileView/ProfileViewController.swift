import UIKit

class ProfileViewController: UIViewController{
    
    private let profileService = ProfileService.sharedProfile
    private var nameLabel = UILabel()
    private var idLabel = UILabel()
    private var statusLabel = UILabel()
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else {return}
                self.updateAvatar()
            }
        addSubviews()
        configureConstraints()
        updateLabels()
    }
    
     func addSubviews(){
        view.addSubview(avatarImageView)
        view.addSubview(exitButton)
    }
    
    private func configureConstraints(){
        nameLabel = createLabel("Name", size: 23, color: .white)
        idLabel = createLabel("@Id", color: .gray)
        statusLabel = createLabel("Status", color: .white)
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
        return avatarImageView
    }()

    private lazy var exitButton: UIButton = {
        let exitButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(didTapButton)
        )
        
        exitButton.tintColor = .red
        exitButton.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func updateLabels(){
        guard let profile = ProfileService.sharedProfile.profile else {return}
        nameLabel.text = profile.name
        idLabel.text = profile.loginName
        statusLabel.text = profile.bio
    }
    
    private func updateAvatar(){
        guard
            let profileImageURL = ProfileImageService.shared.avatarURl,
            let url = URL(string: profileImageURL)
        else {return}
    }
    
    @objc private func didTapButton(){
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        avatarImageView.tintColor = .gray
        }
}
