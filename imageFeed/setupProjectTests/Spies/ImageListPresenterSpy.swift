import Foundation

final class ImagesListPresenterSpy: ImageListPresenterProtocol {
    
    var viewDidLoadCalled: Bool = false
    var view: ImageListViewControllerProtocol?
    
    var photos: [Photo] = []
    
    func fetchPhotosNextPage() {
    }
    
    
    func willDisplay(for indexPath: IndexPath) {
    }
    
    func setNotification() {
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func imageListCellDidTapLike(_ cell: ImageListCell, indexPath: IndexPath) {
    }
}
