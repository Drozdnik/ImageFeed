
import UIKit

final class ImageListCell: UITableViewCell{
    weak var delegate: ImageListCellDelegate?
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    
    static let reuseIdentifier = "ImageListCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setLikeButton(enabled: Bool, isLiked: Bool){
        likeButton.isEnabled = enabled
        likeButton.isSelected = isLiked
        likeButton.accessibilityIdentifier = isLiked ? "like button off" : "like button on"
        
    }
}

