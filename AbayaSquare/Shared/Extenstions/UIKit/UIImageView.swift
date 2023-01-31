
import UIKit
import ImageIO
import Kingfisher

extension UIImageView {
    func setImage(url: String? = "") {
        if url == ""{
            
        }else if url == nil{
            
        }else{
            if let urlString = url, let url = URL(string: urlString) {
//                self.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                self.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
                kf.indicatorType = .activity
                 kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            } else {
                self.image = UIImage(named: "placeholder")
            }
//            let urlString = URL(string: imageBaseUrl + profileImage)
    
            
            
            
            
            
        }

    }
    
    @IBInspectable
    var isRTL: Bool {
        get {
            return false
        }
        set {
            if L102Language.isRTL {
                self.image = self.image?.withHorizontallyFlippedOrientation()
            }
        }
    }
    
}

extension UIImage {
    convenience init?(view: UIView) {
        // Based on https://stackoverflow.com/a/41288197/1118398
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }

        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        } else {
            return nil
        }
    }
}


extension UIImageView {
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
    }
    
    @objc
    private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
