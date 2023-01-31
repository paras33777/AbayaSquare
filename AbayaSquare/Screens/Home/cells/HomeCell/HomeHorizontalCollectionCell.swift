////
////  HomeHorizontalCollectionCell.swift
////  AbayaSquare
////
////  Created by Afnan MacBook Pro on 24/04/2022.
////
//
//import UIKit
//
//enum HomeHorizontalType {
//    case categories
//    case mostSeller
//}
//
//class HomeHorizontalCollectionCell: UICollectionViewCell {
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//    var type: HomeHorizontalType = .categories
//    let categoriesViewModel = CategorieViewModel()
//    let categoriesRouter = CategoriesRouter()
//    static let identifier = "HomeHorizontalCollectionCell"
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//}
//
//extension HomeHorizontalCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch type {
//        case .categories:
//            return categoriesViewModel.categories.count
//        case .mostSeller:
//            return categoriesViewModel.categories.count
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        switch type {
//        case .categories:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCellGrid.identifier, for: indexPath) as! CategoriesCellGrid
//            let model = categoriesViewModel.categories[indexPath.row]
//            cell.config(with: model)
//            cell.setBorder()
//            return cell
//        case .mostSeller:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.identifier, for: indexPath) as! HomeCell
//            //            cell.config(with: model)
//            return cell
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch type {
//        case .categories:
//            categoriesRouter.dataSource?.category = categoriesViewModel.categories[indexPath.row]
//            categoriesRouter.goToCategoriesDetails()
//        case .mostSeller:
//            break
//            //            router.dataSource?.productId = viewModel.products[indexPath.row].id
//            //            router.goToProductDetails()
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.width / 3 - 20
//        let height = collectionView.frame.height / 2 - 24
//        return CGSize(width: width, height: height)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        switch type {
//        case .categories:
//            return UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
//        case .mostSeller:
//            return UIEdgeInsets.zero
//        }
//    }
//}
