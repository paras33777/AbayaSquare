//
//  PopUpViewController.swift
//  ProductiveFamilies
//
//  Created by Mohamed Zakout on 01/04/2021.
//

import UIKit

class PopUpViewController: UIViewController {

    var actionOnDismiss: (_ onComplete: () -> Void) -> Void = { _ in  }
    
    override func viewWillAppear(_ animated: Bool) {
        showAnimate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        actionOnDismiss = { [weak self] _ in self?.dismiss(animated: false, completion: nil) }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    func showAnimate() {
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0;
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.alpha = 1.0
            self?.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self?.view.alpha = 0.0
        } completion: { [weak self] _ in
            self?.actionOnDismiss { [weak self] in self?.dismiss(animated: false, completion: nil) }
        }
    }
}
