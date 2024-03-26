import UIKit

class ImageListPresenter: ImageListPresenterProtocol{
    weak var view: ImagesListViewProtocol?
    var photos: [Photo] = []
    
    private let imageListService: ImageListService
    
    init(view: ImagesListViewProtocol, service: ImageListService = ImageListService.shared){
        self.view = view
        self.imageListService = service
    }
    
    func viewDidLoad() {
        fetchPhotosNextPage()
    }
    
    func willDisplayItem(at indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            fetchPhotosNextPage()
        }
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        view?.navigateToShowSingleImage(forPhoto: photo)
    }
    
    
    func didTapLikeButton(at indexPath: IndexPath) {
        let photo = photos[indexPath.row] // вот тут мб section
        let isLiked = !photo.isLiked
        imageListService.changeLike(photoId: photo.id, isLike: isLiked) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.photos[indexPath.row].isLiked = isLiked
                    self?.view?.reloadRows(at: [indexPath])
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    func fetchPhotosNextPage(){
        imageListService.fetchPhotosNextPage{ [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let newPhoto):
                    guard let self else {return}
                    let currentCount = self.photos.count
                    let (start, end) = (currentCount, currentCount + newPhoto.count)
                    let indexPaths = (start..<end).map{IndexPath(row: $0, section: 0)}
                    
                    self.view?.insertRows(at: indexPaths)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
}

