//
//  FavouriteVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit

class FavouriteVC: UIViewController {

    @IBOutlet weak var productsCV: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    private let viewModel = FavouriteViewModel()
    private let router = FavouriteRouter()
    var isFromProfile = 0
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaultsManager.isFirstLaunch {
            tabBarController?.selectedIndex = 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourite".localized
        router.viewController = self
        router.dataSource = viewModel
        productsCV.register(nibName: ProductCell.identifier)
        setupRefreshControl()
        setupNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(startAPI), name: .UserDidLogged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startAPI), name: .DidRemoveFavorite, object: nil)
        if User.isLoggedIn {
            getFavorite()
        }
    }
}

extension FavouriteVC {
    func setupNavigationBar(){
        let menuButton = UIBarButtonItem(image: UIImage(named: "ic_profile"), style: .plain, target: self, action: #selector(menunButtonPressed))
        
        let categoryButton = UIButton()
        categoryButton.setTitle("Categories".localized, for: .normal)
        categoryButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        categoryButton.setTitleColor(UIColor("#333333"), for: .normal)
        categoryButton.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [menuButton,UIBarButtonItem(customView: categoryButton)]
    }
    
    func setupRefreshControl() {
        productsCV.refreshControl = UIRefreshControl()
        productsCV.refreshControl?.tintColor = .black
        productsCV.refreshControl?.addTarget(self, action: #selector(startAPI), for: .valueChanged)
    }
    
    func getFavorite(){
        view.showSpinner(spinnerColor: .black)
        startAPI()
    }
    
    func onSuccess(_ response: HomeModel.Response){
        removeSpinner()
        productsCV.refreshControl?.endRefreshing()
        viewModel.products = response.products ?? []
        checkEmpty()
        productsCV.reloadData()
    }
    
    func checkEmpty(){
        viewModel.products.isEmpty ? (emptyView.isHidden = false ) : (emptyView.isHidden = true)
    }
}

extension FavouriteVC {
    
    @objc func startAPI() {
        let request = HomeModel.Request(page: 1)
        viewModel.getFavourites(request: request) {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    @objc func menunButtonPressed() {
        if isFromProfile == 1 {
            navigationController?.popViewController(animated: true)
        } else {
            tabBarController?.selectedIndex = 4
        }
    }
    
    @objc func categoryButtonPressed(){
        router.goToCategories()
    }
}

extension FavouriteVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        let model = viewModel.products[indexPath.row]
        cell.config(with: model)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router.dataSource?.productId = viewModel.products[indexPath.row].id
        router.goToProductDetails()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 10) / 2 , height: (productsCV.frame.height - 10) / 2)
    }
}

extension FavouriteVC: ProductCellDelegate {
    func productAddedToFavorite(cell: ProductCell) {
        guard let row = productsCV.indexPath(for: cell)?.row else {return}
        let product = viewModel.products[row]
        (product.inFavorite == false) ? (product.inFavorite = true) : (product.inFavorite = false)
        let request = AddToFavorite.Request(productId: product.id)
        viewModel.addToFav(request: request) {_ in}
        productsCV.deleteItems(at: [IndexPath(row: row, section: 0)])
        viewModel.products.remove(at: row)
        productsCV.reloadData()
        checkEmpty()
        //NotificationCenter.default.post(name: .DidRemoveFavorite, object: nil)
    }
}
