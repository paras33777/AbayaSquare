//
//  UICollectionView.swift
//  ProductiveFamilies
//
//  Created by Mohamed Zakout on 29/03/2021.
//

import UIKit

extension UICollectionView {
    func register(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: nibName)
    }
    
    var selectedItems: [IndexPath] {
        return indexPathsForSelectedItems.emptyIfNull
    }
    
    func selectItem(at indexPath: IndexPath) {
        selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func selectItem(at index: Int) {
        selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func reloadItem(at index: Int) {
        reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell? {
        return cellForItem(at: IndexPath(row: index, section: 0))
    }
}

extension UIScrollView {
    func setContentOffset(_ y: CGFloat) {
        setContentOffset(CGPoint(x: 0, y: y), animated: true)
    }
}
