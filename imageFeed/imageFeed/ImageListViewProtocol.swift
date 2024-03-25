import Foundation

protocol ImagesListViewProtocol: AnyObject {
    func reloadData()
    func insertRows(at indexPaths: [IndexPath])
    func reloadRows(at indexPaths: [IndexPath])
    func displayError(_ error: Error)
    func setLikeButtonState(forItemAt indexPath: IndexPath, isLiked: Bool)
    func navigateToShowSingleImage(forPhoto photo: Photo)
}
