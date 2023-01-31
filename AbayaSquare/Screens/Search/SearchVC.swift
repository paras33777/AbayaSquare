//
//  SearchDesignersVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/25/21.
//

import UIKit
import Kingfisher
class SearchVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var trendingSearchesCV: UICollectionView!
    @IBOutlet weak var productsCV: UICollectionView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyResultsLB: UILabel!
    @IBOutlet weak var trendingStack: UIStackView!
    @IBOutlet weak var trendingSearchLB: UILabel!
    
    var type: SearchEnum = .SearchProducts
    let viewModel = SearchViewModel()
    let router = SearchRouter()
    var page: Int = 1
    var isPageRefreshing:Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        router.viewController = self
        router.dataSource = viewModel
        productsCV.register(nibName: ProductCell.identifier)
        productsCV.register(nibName: DesignerSearchCell.identifier)
        if type == .SearchProducts {
            getTrendingSearch()
            trendingSearchLB.text = "Trending Searches".localized
        } else {
            getTrendingDesingerSearch()
            trendingSearchLB.text = "Trending Desingers".localized
        }
        
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didBeginSearch(_ sender: Any) {
    }
    
    @IBAction func didSearch(_ sender: UITextField) {
        switch type {
        case .SearchDesigners:
            searchDesigner(text: sender.text.emptyIfNull)
        case .SearchProducts:
            searchProduct(text: sender.text.emptyIfNull)
        }
    }
}

extension SearchVC {
    
    func getTrendingSearch(){
        scrollView.showSpinner(spinnerColor: .black,backgroundColor: .white)
        viewModel.getTrendingSearch() {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func getTrendingDesingerSearch(){
        scrollView.showSpinner(spinnerColor: .black,backgroundColor: .white)
        viewModel.getTrendingDesignerSearch { result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onSuccess(_ response: TrendingSearchModel.Response){
        removeSpinner()
        switch type {
        case .SearchDesigners:
            viewModel.trendingSearch = response.trendingDesignersList ?? []
        case .SearchProducts:
            viewModel.trendingSearch = response.trendingSearch ?? []
        }
        trendingSearchesCV.reloadData()
    }
    
    
    func searchProduct(text: String) {
        //scrollView.showSpinner(spinnerColor: .black)
        let request = SearchRequest(page: 1, name: text)
        viewModel.searchProduct(request: request) { result in
            switch result {
            case .success(let response): self.onSuccessSearchProducts(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onSuccessSearchProducts(_ response: HomeModel.Response) {
        removeSpinner()
//        searchTF.resignFirstResponder()
//        searchTF.text = nil
        trendingStack.isHidden = true
        viewModel.products = response.products ?? []
        isPageRefreshing = response.hasMorePage ?? false
        checkEmpty()
        productsCV.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.productsCV.contentOffset.y >= (self.productsCV.contentSize.height - self.productsCV.bounds.size.height)) {
            if isPageRefreshing {
                isPageRefreshing = false
                page += 1
                
                KingfisherManager.shared.cache.clearMemoryCache()
                KingfisherManager.shared.cache.clearDiskCache()
                KingfisherManager.shared.cache.cleanExpiredDiskCache()
                self.fetchMoreData(pageNum: self.page)

            }
        }
    }
    
    func fetchMoreData(pageNum: Int){
        let request = SearchRequest(page: pageNum, name: searchTF.text.emptyIfNull)
        viewModel.searchProduct(request: request) {result in
            switch result{
            case .success(let response): self.onMoreSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onMoreSuccess(_ response: HomeModel.Response) {
        viewModel.products += response.products ?? []
        productsCV.reloadData()
        isPageRefreshing = response.hasMorePage ?? false
    }
    
    func searchDesigner(text: String){
        //scrollView.showSpinner(spinnerColor: .black)
        let request = SearchRequest(page: 1, name: text)
        viewModel.searchDesigner(request: request) {result in
            switch result {
            case .success(let response): self.onSuccessSearchDesigners(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onSuccessSearchDesigners(_ response: DesignerModel.Response){
        removeSpinner()
        viewModel.designers = response.designers ?? []
        trendingStack.isHidden = true
        let newDesigner = Designer(id: 0,name: "")
        viewModel.designers.insert(newDesigner, at: 0)
        productsCV.reloadData()
        checkEmpty()
    }
    
    func checkEmpty(){
        switch type {
        case .SearchDesigners:
            if viewModel.designers.count == 1 {
                emptyView.isHidden = false
                emptyResultsLB.isHidden = false
            } else {
                emptyView.isHidden = true
                emptyResultsLB.isHidden = true
            }
        case .SearchProducts:
            if viewModel.products.isEmpty {
                emptyView.isHidden = false
                emptyResultsLB.isHidden = false
            } else {
                emptyView.isHidden = true
                emptyResultsLB.isHidden = true
            }
        }
    }
}

extension SearchVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == trendingSearchesCV {
            return viewModel.trendingSearch.count
        } else {
            switch type {
            case .SearchProducts:
                return viewModel.products.count
            case .SearchDesigners:
                return viewModel.designers.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == trendingSearchesCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingSearchesCell", for: indexPath) as! TrendingSearchesCell
            cell.searchLB.text = viewModel.trendingSearch[indexPath.row].text
            return cell
        } else {
            switch type {
            case .SearchDesigners:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DesignerSearchCell.identifier, for: indexPath) as! DesignerSearchCell
                if indexPath.row == 0 {
                    cell.designerNameLB.text = searchTF.text?.first?.description
                    cell.designerImage.isHidden = true
                } else {
                    let model = viewModel.designers[indexPath.row]
                    cell.designerImage.isHidden = false
                    cell.config(with: model)
                }
                return cell
            case .SearchProducts:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
                let model = viewModel.products[indexPath.row]
                cell.config(with: model)
                cell.delegate = self
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == trendingSearchesCV {
            searchTF.text = viewModel.trendingSearch[indexPath.row].text
            switch type {
            case .SearchDesigners:
                searchDesigner(text: viewModel.trendingSearch[indexPath.row].text.emptyIfNull)
            case .SearchProducts:
                searchProduct(text: viewModel.trendingSearch[indexPath.row].text.emptyIfNull)
            }
        } else {
            switch type {
            case .SearchDesigners:
                router.dataSource?.designer = viewModel.designers[indexPath.row]
                router.goToDesignerDetails()
            case .SearchProducts:
                router.dataSource?.productId = viewModel.products[indexPath.row].id
                router.goToProductDetails()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch type {
        case .SearchDesigners:
            return CGSize(width: (collectionView.frame.size.width), height: 50)
        case .SearchProducts:
            return CGSize(width: (collectionView.frame.size.width - 10) / 2 , height: (view.frame.height - 130) / 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productsCV {
            switch type {
            case .SearchDesigners:
                return 0
            case .SearchProducts:
                return 10
            }
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productsCV {
            switch type {
            case .SearchDesigners:
                return 0
            case .SearchProducts:
                return 10
            }
        }
        return 10
    }
}

extension SearchVC: ProductCellDelegate {
    func productAddedToFavorite(cell: ProductCell) {
        if User.isLoggedIn {
            guard let index = productsCV.indexPath(for: cell)?.row else { return }
            let product = viewModel.products[index]
            (product.inFavorite == false) ? (product.inFavorite = true) : (product.inFavorite = false)
            cell.updateFav(product)
            let request = AddToFavorite.Request(productId: product.id)
            viewModel.addToFav(request: request) {result in
                switch result {
                case .success(_): NotificationCenter.default.post(name: .DidRemoveFavorite, object: nil)
                case .failure(_): (product.inFavorite == false) ? (product.inFavorite = true) : (product.inFavorite = false); cell.updateFav(product)
                }
            }
        } else {
            MainHelper.shared.showErrorMessage(responseMessage: "You Must Login to like the product".localized)
        }
    }
}

enum SearchEnum {
    case SearchDesigners
    case SearchProducts
}
