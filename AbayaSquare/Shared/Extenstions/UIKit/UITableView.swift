//
//  UITableView.swift
//  ProductiveFamilies
//
//  Created by Mohamed Zakout on 29/03/2021.
//

import UIKit

extension UITableView {
    func register(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: nibName)
    }
}
