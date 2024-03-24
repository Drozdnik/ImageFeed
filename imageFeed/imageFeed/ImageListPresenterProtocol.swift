import Foundation

protocol ImageListPresenterProtocol{
    var photo: [Photo] {get}
    
    func viewDidLoad()
    func willDisplayItem(at indexPath: IndexPath)
    func didSelectItem(at indexPath: IndexPath)
    func didTapLikeButton(at indexPath: IndexPath)
}
