import Foundation

protocol ImageListPresenterProtocol{
    var photos: [Photo] {get}
    
    func viewDidLoad()
    func willDisplayItem(at indexPath: IndexPath)
    func didSelectItem(at indexPath: IndexPath)
    func didTapLikeButton(at indexPath: IndexPath)
    func fetchPhotosNextPage()
}
