import UIKit
import Kingfisher
class ImagesListViewController: UIViewController{
    
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    var presenter: ImageListPresenterProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        UIBlockingProgressHUD.show()
        presenter = ImageListPresenter(view: self)
        presenter?.viewDidLoad()
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(handeDataServiceUpdate(_ :)),
//            name: ImageListService.didChangeNotification,
//            object: nil
//        )
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 300
    }
    
}

extension ImagesListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        guard let photo = presenter?.photos[indexPath.row] else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath, photo: photo)
        
        return imageListCell
    }
    
    private func configCell(for cell: ImageListCell, with indexPath: IndexPath, photo: Photo) {
        if let url = URL(string: photo.thumbImageURL){
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(
                with: url,
                placeholder: UIImage(named: "Stub"),
                options: [
                    .transition(.fade(1))
                ]
            )
        }
        
        let dateFormatterForImageView: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            return formatter
        }()
        
        if let createdAt = photo.createdAt {
            cell.dateLabel.text = dateFormatterForImageView.string(from: createdAt)
        } else {
            cell.dateLabel.text = " "
        }
        
        let likeImage = photo.isLiked ? UIImage(named: "buttonTapped") : UIImage(named: "buttonDisabled")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let photosCount = presenter?.photos.count ?? 0
        let lastIndex = photosCount - 1
        if indexPath.row == lastIndex {
            presenter?.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.photos[indexPath.row] else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let imageHeight = photo.size.height
        
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
}

extension ImagesListViewController: ImageListCellDelegate{
    func imageListCellDidTapLike(_ cell: ImageListCell){
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        presenter?.didTapLikeButton(at: indexPath)
    }
    
//    private func fetchPhotosNextPage(){
//        ImageListService.shared.fetchPhotosNextPage{ [weak self] result in
//            switch result{
//            case .success(let newPhoto):
//                let currentCount = self?.photos.count ?? 0
//                let (start, end) = (currentCount, currentCount + newPhoto.count)
//                let indexPaths = (start..<end).map{IndexPath(row: $0, section: 0)}
//                
//                self?.photos.append(contentsOf: newPhoto)
//                self?.tableView.insertRows(at: indexPaths, with: .automatic)
//                
//            case .failure(let error)
//                debugPrint(error)
//            }
//        }
//    }
    
    @objc private func handeDataServiceUpdate(_ notification: Notification){
        guard let newPhotos = notification.userInfo?["photos"] as? [Photo] else {
            return
        }
        let photosCount = presenter?.photos.count ?? 0
        let oldPhotosCount = photosCount
        let newIndexPath = (oldPhotosCount..<photosCount).map{IndexPath(row: $0, section: 0) }
        
        tableView.performBatchUpdates({
            tableView.insertRows(at: newIndexPath, with: .automatic)
        }, completion: nil) // можно вставить доп логику после завершения анимации
        
    }
}

extension ImagesListViewController: ImagesListViewProtocol{
    func navigateToShowSingleImage(forPhoto photo: Photo) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: photo)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            if let viewController = segue.destination as? SingleImageViewController,
               let indexPath = sender as? IndexPath{
                guard let photo = presenter?.photos[indexPath.row] else {return}
                viewController.imageURL = URL(string: photo.largeImageURL)
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func insertRows(at indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
    
    
    func setLikeButtonState(forItemAt indexPath: IndexPath, isLiked: Bool) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImageListCell else { return }
            let likeImage = isLiked ? UIImage(named: "buttonTapped") : UIImage(named: "buttonDisabled")
            cell.likeButton.setImage(likeImage, for: .normal)
    }
}
