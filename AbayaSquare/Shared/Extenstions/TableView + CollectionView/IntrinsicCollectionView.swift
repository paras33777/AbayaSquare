

import UIKit

@IBDesignable
class intrinsicCollectionView: UICollectionView {
    override var intrinsicContentSize: CGSize {
        // Drawing code
        layoutIfNeeded()
        
        #if TARGET_INTERFACE_BUILDER
        return  CGSize(width: UIView.noIntrinsicMetric, height: 250)
        #else
        return CGSize(width: UIView.noIntrinsicMetric, height: self.contentSize.height);
        #endif
    }
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
}

extension UICollectionViewFlowLayout{
    override open var flipsHorizontallyInOppositeLayoutDirection: Bool{
        return true
    }
}
