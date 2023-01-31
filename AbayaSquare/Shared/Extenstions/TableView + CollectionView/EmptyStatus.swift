//
//  EmptyStatus.swift
//  HomeFoodCheif
//
//  Created by Ayman  on 12/30/20.
//

import Foundation
import UIKit

extension UITableView {
    func setEmpty(title: String, image: EmptyStates) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let width = self.bounds.width * 0.7
            
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 0
            titleLabel.text = title
            titleLabel.font = .boldSystemFont(ofSize: 22)
            titleLabel.textColor = .black
            titleLabel.sizeToFit()
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image.image
            
            let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fill
            stackView.spacing = 0
            stackView.frame.size.width = width
            stackView.frame.size.height = imageView.frame.height + titleLabel.frame.height
            stackView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2.25)
            
            self.backgroundView = UIView()
            self.backgroundView?.addSubview(stackView)
        }
    }
    
    func removeState() {
        DispatchQueue.main.async { [weak self] in
            self?.backgroundView = nil
        }
    }
}


extension UICollectionView {
    func setEmpty(title: String, subTitle: String, image: EmptyStates) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let width = self.bounds.width * 0.7
            
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 0
            titleLabel.text = title
            titleLabel.font = .boldSystemFont(ofSize: 22)
            titleLabel.textColor = .black
            titleLabel.sizeToFit()
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image.image
            
            let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fill
            stackView.spacing = 0
            stackView.frame.size.width = width
            stackView.frame.size.height = imageView.frame.height + titleLabel.frame.height
            stackView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2.25)
            
            self.backgroundView = UIView()
            self.backgroundView?.addSubview(stackView)
        }
    }
    
    func removeState() {
        DispatchQueue.main.async { [weak self] in
            self?.backgroundView = nil
        }
    }
}


enum EmptyStates {
    case empty
    case emptyCart
    case emptySearchResult
    
    var image: UIImage? {
        switch self {
            case .empty             : return UIImage(named: "empty")
            case .emptyCart         : return UIImage(named: "emptyCart")
            case .emptySearchResult : return UIImage(named: "emptySearchResults")
        }
    }
}
