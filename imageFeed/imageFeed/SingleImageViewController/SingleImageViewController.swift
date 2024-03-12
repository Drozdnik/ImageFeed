
import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController{
    var imageURL:URL?
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        if let imageURL = imageURL {
            UIBlockingProgressHUD.show()
            loadImage(from: imageURL)
        }
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage){
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    private func loadImage(from url: URL){
        imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(1))]){[weak self] result in
            guard let self else {return}
            
            switch result{
            case .success(let photoFull):
                self.imageView.image = photoFull.image
                self.rescaleAndCenterImageInScrollView(image: photoFull.image)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                debugPrint(error)
            }
        }
    }
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let imageToShare = imageView.image else {return}
        let share = UIActivityViewController(
        activityItems: [imageToShare],
        applicationActivities: nil)
        self.present(share, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
