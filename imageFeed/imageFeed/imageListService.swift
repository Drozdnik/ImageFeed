import UIKit

final class ImageListService {
    static let shared = ImageListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let urlSession = URLSession.shared
    let tokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private lazy var lastLoadedPage: Int = 0
    private (set) var photos: [Photo] = []
    init(){}
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let nextPage = lastLoadedPage + 1
        assert(Thread.isMainThread)
        
        if task != nil{
            task?.cancel()
        }
        guard let token = tokenStorage.token else {return}
        
        guard let request = URLRequest.makeRequestWithToken(path: "/photos?page=\(nextPage)", httpMethod: "GET", token: token) else {
            completion (.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                debugPrint("task внутри замыкания")
                switch result {
                case .success(let photoResult):
                    let photos = photoResult.map {Photo(photoResult: $0)}
                    self?.photos.append(contentsOf: photos)
                    self?.lastLoadedPage += 1
                    completion(.success(photos))
                    NotificationCenter.default.post(
                        name: ImageListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": photos]
                    )
                    
                case .failure(let error):
                    completion (.failure(error))
                }
                self?.task = nil
            }
            
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike:Bool, completion: @escaping (Result<Void, Error>) -> Void){
        assert(Thread.isMainThread)
        
        if task != nil{
            task?.cancel()
         }
        
        guard let token = tokenStorage.token else {return}
        guard let request = URLRequest.makeRequestWithToken(path: "/photos/\(photoId)/like", httpMethod: isLike ? "Delete" : "POST", token: token) else {
            completion (.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            guard let self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let photoLike):
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        var updatedPhoto = self.photos[index]
                        updatedPhoto.isLiked = isLike
                        self.photos[index] = updatedPhoto
                    }
                    completion(.success(()))
                case .failure(let error):
                    completion (.failure(error))
                }
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
