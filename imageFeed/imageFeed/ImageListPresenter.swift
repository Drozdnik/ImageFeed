
import Foundation
protocol ImageListPresenterProtocol{
    func willDisplay(for indexPath: IndexPath)
    func fetchPhotosNextPage()
    func setNotification()
    func viewDidLoad()
    var  photos: [Photo] {get set}
    var view:ImageListViewControllerProtocol? {get set}
}
final class ImageListPresenter {
    var view: ImageListViewControllerProtocol?
    var  photos: [Photo] = []
    var imageListService = ImageListService.shared
    
    init (view: ImageListViewControllerProtocol){
        self.view = view
    }
    
    @objc private func handeDataServiceUpdate(_ notification: Notification){
        guard let newPhotos = notification.userInfo?["photos"] as? [Photo] else {
            return
        }
        let oldPhotosCount = photos.count
        let newIndexPath = (oldPhotosCount..<photos.count).map{IndexPath(row: $0, section: 0) }
        view?.animationUpdate(indexPath: newIndexPath)
    }
}

extension ImageListPresenter: ImageListPresenterProtocol{
    func viewDidLoad(){
        setNotification()
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage(){
        
        imageListService.fetchPhotosNextPage{ [weak self] result in
            switch result{
            case .success(let newPhoto):
                let currentCount = self?.photos.count ?? 0
                let (start, end) = (currentCount, currentCount + newPhoto.count)
                let indexPaths = (start..<end).map{IndexPath(row: $0, section: 0)}
                
                self?.photos.append(contentsOf: newPhoto)
                self?.view?.insertRows(indexPaths)
                
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func willDisplay(for indexPath: IndexPath) {
        let lastIndex = photos.count - 1
        if indexPath.row == lastIndex {
            fetchPhotosNextPage()
        }
    }
    
    func setNotification(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handeDataServiceUpdate(_ :)),
            name: ImageListService.didChangeNotification,
            object: nil
        )
    
    }
}
