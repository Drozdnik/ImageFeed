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
//        lastLoadedPage += 1
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
                switch result {
                case .success(let photoResult):
                    let photos = photoResult.map {Photo(photoResult: $0)}
                    self?.photos.append(contentsOf: photos)
                    completion(.success(photos))
                case .failure(let error):
                    completion (.failure(error))
                }
                self?.task = nil
            }

        }
        self.task = task
        task.resume()
    }
}
