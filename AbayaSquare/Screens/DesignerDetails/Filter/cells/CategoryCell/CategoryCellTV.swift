//
//  CategoryCellTV.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import UIKit

class CategoryCellTV: UITableViewCell {
    
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var cellLB: UILabel!
    @IBOutlet weak var productCountLB: UILabel!
    
    static let identifier = "CategoryCellTV"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(with model: Category) {
        cellLB.text = model.name
        productCountLB.text = model.productsCount.zeroIfNull.description
    }
    
    func config(with model: Size){
        cellLB.text = model.name
        productCountLB.text = model.productsCount.zeroIfNull.description
    }
    
    func select(){
        checkImage.isHidden = false
        checkView.backgroundColor = UIColor("#7C7160")
        cellLB.font = .boldSystemFont(ofSize: 14)
    }
    
    func deselect(){
        checkImage.isHidden = true
        checkView.backgroundColor = .white
        cellLB.font = .systemFont(ofSize: 14)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            select()
        } else {
            deselect()
        }
    }
    
}
