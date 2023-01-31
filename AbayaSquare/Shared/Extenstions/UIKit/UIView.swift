

import Foundation
import UIKit
var initialLoader: UIView?

extension UIView {
    
    @IBInspectable
    var corner: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func didHighlight() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    func didUnHighlight() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.transform = CGAffineTransform.identity
        }
    }
    
    func didTap(scale: CGFloat = 0.9) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: scale, y: scale)
        } completion: { _ in
            self.didUnHighlight()
        }
    }
    
    func rotateView (angle: CGFloat) {
        transform = CGAffineTransform(rotationAngle: angle * .pi / 180)
    }
    
    func showInitialLoading() {
        guard let spinnerView = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()?.view else { return }
        
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        
        spinnerView.frame = bounds
        addSubview(spinnerView)
        indicator.color = .white
        indicator.center.x = spinnerView.center.x
        indicator.center.y = spinnerView.bounds.height * 0.85
        spinnerView.addSubview(indicator)
        
        initialLoader = spinnerView
    }
    
    func removeInitialLoading() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                initialLoader?.alpha = 0
            } completion: { _ in
                initialLoader?.removeFromSuperview()
                initialLoader = nil
            }
        }
    }
    
    func showSpinner(spinnerColor: UIColor = .white, backgroundColor: UIColor? = nil) {
        removeSpinner()
        let spinnerView = UIView()
        spinnerView.corner = corner
        spinnerView.backgroundColor = backgroundColor ?? self.backgroundColor
        
        let spinner = UIActivityIndicatorView()
        spinner.color = spinnerColor
        spinner.startAnimating()
        spinnerView.frame = bounds
        addSubview(spinnerView)
        
        spinner.center = spinnerView.center
        spinnerView.addSubview(spinner)
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        vSpinner?.removeFromSuperview()
        vSpinner = nil
    }
    
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }
    
    func with(height: CGFloat) -> UIView {
        frame = CGRect(origin: frame.origin, size: CGSize(width: bounds.width, height: height))
        return self
    }
    
    func with(width: CGFloat) -> UIView {
        frame = CGRect(origin: frame.origin, size: CGSize(width: width, height: bounds.height))
        return self
    }
    
    func addDashedBorder(_ color: UIColor) {
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: self.corner).cgPath
        self.layer.addSublayer(shapeLayer)
    }
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}

@IBDesignable class CustomView: UIView {
    
    @IBInspectable var isCircle: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.isCircle {
            self.layer.cornerRadius = self.bounds.width / 2
        }
        layer.shadowRadius = self.shadowRadius
    }
    
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            if isCircle {
                layer.shadowRadius = self.bounds.width / 2
            } else {
                layer.shadowRadius = newValue
            }
        }
    }
    
    
    @IBInspectable
    var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var customShadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
}
