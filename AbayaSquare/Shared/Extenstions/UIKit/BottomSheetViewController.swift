//
//  BottomSheetViewController.swift
//  Tulip
//
//  Created by Mohamed Zakout on 01/02/2021.
//

import UIKit

class BottomSheetViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    private var viewTranslation = CGPoint(x: 0, y: 0)
    private var topConstraints = Set<NSLayoutConstraint>()
    
    var actionOnDismiss: (_ onComplete: () -> Void) -> Void = { _ in  }
    
    var willHandleKeyboard: Bool = false {
        didSet {
            willHandleKeyboard ? setupObserver() : DoNoThing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
        animateIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        actionOnDismiss = { [weak self] _ in self?.dismiss(animated: false, completion: nil) }
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        contentView.isHidden = true
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    func animateIn() {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = .push
        transition.subtype = .fromTop
        transition.timingFunction = CAMediaTimingFunction(name: .default)
        contentView.layer.add(transition, forKey: nil)
        contentView.isHidden = false
    }
    
    func animateOut() {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = .push
        transition.subtype = .fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: .default)
        contentView.layer.add(transition, forKey: nil)
        contentView.isHidden = true
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.actionOnDismiss { self?.dismiss(animated: false, completion: nil) }
        }
    }
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .changed:
                viewTranslation = sender.translation(in: view)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) { [weak self] in
                    guard let self = self else { return }
                    self.contentView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                }
                
            case .ended:
                if viewTranslation.y < contentView.bounds.height / 2 {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) { [weak self] in
                        guard let self = self else { return }
                        self.contentView.transform = .identity
                    }
                } else {
                    animateOut()
                }
            default: break
        }
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let constraint = contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        topConstraints.insert(constraint)
        NSLayoutConstraint.activate([constraint])
        
        let duration: TimeInterval = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: duration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let constraints = topConstraints.map { $0 }
        topConstraints.removeAll()
        NSLayoutConstraint.deactivate(constraints)
        
        let duration: TimeInterval = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: duration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

typealias DoNoThing = ()
