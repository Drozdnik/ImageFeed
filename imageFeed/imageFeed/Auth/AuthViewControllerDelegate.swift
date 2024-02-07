
import Foundation

protocol AuthViewControllerDelegate: AnyObject{
    func authViewController(_ vc: AuthViewController, didAuthWithCode code:String)
}
