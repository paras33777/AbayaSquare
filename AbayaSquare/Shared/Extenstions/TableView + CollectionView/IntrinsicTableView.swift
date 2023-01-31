
import UIKit

@IBDesignable
class IntrinsicTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
        // Drawing code
        layoutIfNeeded()
        
        #if TARGET_INTERFACE_BUILDER
        return CGSize(width: UIView.noIntrinsicMetric, height: 300)
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


