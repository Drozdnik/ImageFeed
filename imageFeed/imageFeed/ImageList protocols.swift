
import Foundation
protocol ImageListViewControllerProtocol{
    func insertRows(_ indexPath: [IndexPath])
    func showBlockingHud()
    func dismissBlockingHud()
    func animationUpdate(indexPath: [IndexPath])
    func reloadRowsWhenLiked(at indexPath: [IndexPath])
    var presenter: ImageListPresenterProtocol? {get set}
}

protocol ImageListPresenterProtocol{
    func willDisplay(for indexPath: IndexPath)
    func fetchPhotosNextPage()
    func setNotification()
    func viewDidLoad()
    func imageListCellDidTapLike(_ cell: ImageListCell, indexPath: IndexPath)
    var  photos: [Photo] {get set}
    var view:ImageListViewControllerProtocol? {get set}
}
