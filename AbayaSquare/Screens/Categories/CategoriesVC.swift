//
//  CategoriesVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/3/21.
//

import UIKit

class CategoriesVC: UIViewController {

    @IBOutlet weak var categoriesCV: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    
    let viewModel = CategorieViewModel()
    let router = CategoriesRouter()
    var type: CategoryDetailsEnum = .List
    var layoutButton = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories".localized
        router.viewController = self
        router.dataSource = viewModel
        categoriesCV.register(nibName: CategoriesCellGrid.identifier)
        categoriesCV.register(nibName: CategoriesCellVertical.identifier)
        setupBarButton()
        setupRefreshControl()
        getCategories()
    }
}

extension CategoriesVC {
    func setupBarButton(){
        layoutButton.setImage(UIImage(named: "ic_grid"), for: .normal)
        layoutButton.setTitleColor(.black, for: .normal)
        layoutButton.addTarget(self, action: #selector(switchLayout), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: layoutButton)
    }
    
    func setupRefreshControl() {
        categoriesCV.refreshControl = UIRefreshControl()
        categoriesCV.refreshControl?.tintColor = UIColor("#7C7160")
        categoriesCV.refreshControl?.addTarget(self, action: #selector(startAPI), for: .valueChanged)
    }
    
    func getCategories(){
        view.showSpinner(spinnerColor: .black)
        startAPI()
    }
    
    func onSuccess(_ response: CategoryModel.Response){
        removeSpinner()
        categoriesCV.refreshControl?.endRefreshing()
        viewModel.categories = response.categories ?? []
        categoriesCV.reloadData()
        checkEmpty()
    }
    
    func checkEmpty(){
        viewModel.categories.isEmpty ? (emptyView.isHidden = false ) : (emptyView.isHidden = true)
    }
}

extension CategoriesVC {
    @objc func startAPI(){
        viewModel.getCategories() { result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    @objc func switchLayout(){
        switch type {
        case .Grid:
            layoutButton.setImage(UIImage(named: "ic_grid"), for: .normal)
            type = .List
            categoriesCV.reloadData()
            
        case .List:
            layoutButton.setImage(UIImage(named: "ic_list"), for: .normal)
            type = .Grid
            categoriesCV.reloadData()
        }
    }
}

extension CategoriesVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.categories[indexPath.row]
        switch type {
        case .Grid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCellGrid.identifier, for: indexPath) as! CategoriesCellGrid
            cell.config(with: model)
            cell.categoryImage.corner = cell.categoryImage.bounds.height / 2
            return cell
        case .List:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCellVertical.identifier, for: indexPath) as! CategoriesCellVertical
            cell.config(with: model)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router.dataSource?.category = viewModel.categories[indexPath.row]
        router.goToCategoriesDetails()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch type {
        case .Grid:
            return CGSize(width: (collectionView.frame.size.width - 10) / 2.5, height: 230)
        case .List:
            return CGSize(width: collectionView.frame.size.width, height: 250)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch type {
        case .Grid:
            return UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        case .List:
            return UIEdgeInsets.zero
        }
    }
}

enum CategoryDetailsEnum {
    case Grid
    case List
}

