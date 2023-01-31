//
//  HomeVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import FSPagerView
import UIKit
import Kingfisher

class HomeVC: UIViewController {
    var count = 7

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.setFillColor(UIColor("#7C7160"), for: .selected)
            self.pageControl.setFillColor(UIColor("#7C7160").withAlphaComponent(0.5), for: .normal)
        }
    }
    
    @IBOutlet weak var sliderPagerView: FSPagerView! {
        didSet {
            self.sliderPagerView.register(UINib(nibName: IntroCell.identifier, bundle: nil), forCellWithReuseIdentifier: IntroCell.identifier)
            self.sliderPagerView.automaticSlidingInterval = 5.0
        }
    }
    
    private var lastContentOffset: CGFloat = 0
    
    @IBOutlet weak var productsCV: UICollectionView!
    @IBOutlet weak var categoriesTitleLabel: UILabel!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionViewTwo: UICollectionView!

    @IBOutlet weak var mostSellerTitleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var mostSellerCollectionView: FSPagerView! {
        didSet {
            self.mostSellerCollectionView.register(UINib(nibName: HomeCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeCell.identifier)
        }
    }
    @IBOutlet weak var productsTitleLabel: UILabel!
    @IBOutlet weak var zeroHeightConstraint: NSLayoutConstraint!

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
        viewModel.allProducts = []
        self.page = 1
        self.fetchMoreData(pageNum: self.page)
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.viewModel.allProducts.count-1, section: 0)
            self.productsCV.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }

        
    }
    
    private let viewModel = HomeViewModel()
    private let router = HomeRouter()
    private let categoriesViewModel = CategorieViewModel()
    private let categoriesViewModelTwo = CategorieViewModel()

    private let categoriesRouter = CategoriesRouter()
    
    var page: Int = 1
    var isPageRefreshing:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeStrings()
        UserDefaultsManager.isFirstLaunch = false
        if !Configuration.isConfigSuccess {
            tabBarController?.view.showInitialLoading()
            NotificationCenter.default.addObserver(self, selector: #selector(startApp), name: .ConfigDidSuccess, object: nil)
        }
        router.viewController = self
        router.dataSource = viewModel
        categoriesRouter.viewController = self
        categoriesRouter.dataSource = categoriesViewModel
        productsCV.register(nibName: ProductCell.identifier)
        categoriesCollectionView.register(nibName: CategoriesCellGrid.identifier)
        categoriesCollectionViewTwo.register(nibName: CategoriesCellGrid.identifier)
        setupRefreshControl()
        getHome()
        getCategories()
        getOffers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startAPI), name: .DidRemoveFavorite, object: nil)
        mostSellerCollectionView.itemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 16, height: mostSellerCollectionView.bounds.height)
        mostSellerCollectionView.interitemSpacing = 8
        if L102Language.isRTL {
            mostSellerCollectionView.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    func localizeStrings() {
        categoriesTitleLabel.text = "Categories".localized
        mostSellerTitleLabel.text = "Most Seller".localized
        productsTitleLabel.text = "Browse all products".localized
    }
    
    @IBAction func didTapGoToSearch(_ sender: Any) {
        router.goToSearch()
    }
    
    @IBAction func goToCategories(_ sender: Any) {
        router.goToCategories()
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        tabBarController?.selectedIndex = 4
    }
    
    @IBAction func didTapFilter(_ sender: Any) {
        router.goToFilter()
    }
}

extension HomeVC {
    
    func setupRefreshControl() {
        productsCV.refreshControl = UIRefreshControl()
        productsCV.refreshControl?.tintColor = .black
        productsCV.refreshControl?.addTarget(self, action: #selector(startAPI), for: .valueChanged)
    }
    
    func getHome(){
        productsCV.showSpinner(spinnerColor: .black)
        startAPI()
    }
    
    func onSuccess(_ response: HomeModel.Response){
        removeSpinner()
//        productsCV.refreshControl?.endRefreshing()
        viewModel.allProducts = response.products ?? []
        isPageRefreshing = response.hasMorePage ?? false
        productsCV.reloadData()
        mostSellerCollectionView.reloadData()
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if(self.productsCV.contentOffset.y >= (self.productsCV.contentSize.height - self.productsCV.bounds.size.height)) {
//            if isPageRefreshing {
////                self.productsCV.refreshControl?.beginRefreshing()
//                isPageRefreshing = false
//                page += 1
//                fetchMoreData(pageNum: page)
//            }
//        }
//    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in productsCV.visibleCells {
            let indexPath = productsCV.indexPath(for: cell)
            if  indexPath != nil{
                //                print("\(indexPath)")
                if indexPath?.row  == self.viewModel.allProducts.count - 1{
                    if isPageRefreshing {
                        //                self.productsCV.refreshControl?.beginRefreshing()
                        isPageRefreshing = false
                        page += 1
                        
                        
                        
                        KingfisherManager.shared.cache.clearMemoryCache()
                        KingfisherManager.shared.cache.clearDiskCache()
                        KingfisherManager.shared.cache.cleanExpiredDiskCache()
                        self.fetchMoreData(pageNum: self.page)
                        
                        
                        
                    }
                }
            }
        }
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//         if (self.lastContentOffset > scrollView.contentOffset.y) {
//             // move up
//         }
//         else if (self.lastContentOffset < scrollView.contentOffset.y) {
//            // move down
//
////             if(self.productsCV.contentOffset.y >= (self.productsCV.contentSize.height - self.productsCV.bounds.size.height)) {
//                 var index = 0
////                 for cell in productsCV.visibleCells {
////                         let indexPath = productsCV.indexPath(for: cell)
////                         print(indexPath)
////                     index = indexPath?.row ?? 0
////                     }
//             let visibleRect = CGRect(origin: productsCV.contentOffset, size: productsCV.bounds.size)
//             let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//             let visibleIndexPath = productsCV.indexPathForItem(at: visiblePoint)
//             let pageWidth = scrollView.frame.width
//             index = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
//
////             index = productsCV.indexPathsForVisibleItems.last?.item ?? 0
//
//
//                 if index == self.viewModel.allProducts.count - 1{
//
//                     if isPageRefreshing {
//                         //                self.productsCV.refreshControl?.beginRefreshing()
//                         isPageRefreshing = false
//                         page += 1
//                         fetchMoreData(pageNum: page)
//                     }
//                 }
////                 if isPageRefreshing {
////     //                self.productsCV.refreshControl?.beginRefreshing()
////                     isPageRefreshing = false
////                     page += 1
////                     fetchMoreData(pageNum: page)
////                 }
////             }
//         }
//
//         // update the new position acquired
//         self.lastContentOffset = scrollView.contentOffset.y
////         print(lastContentOffset)
//     }
    
    func fetchMoreData(pageNum: Int){
        let request = HomeModel.Request(page: pageNum)
        self.activityIndicator.startAnimating()
        viewModel.getHome(request: request) { result in
            switch result {
            case .success(let response): self.onMoreSuccess(response)
//            self.productsCV.refreshControl?.endRefreshing()
            case .failure(let error): self.onFailure(error)
            self.activityIndicator.stopAnimating()
            self.productsCV.reloadData()

            }
        }
    }
    
    func onMoreSuccess(_ response: HomeModel.Response) {
        self.activityIndicator.stopAnimating()
        viewModel.allProducts += response.products ?? []
        productsCV.reloadData()
        isPageRefreshing = response.hasMorePage ?? false
    }
}
extension HomeVC {
    
    func getCategories(){
        
        view.showSpinner(spinnerColor: .black)
        categoriesViewModel.getCategories() { result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onSuccess(_ response: CategoryModel.Response){
        removeSpinner()
        categoriesCollectionView.refreshControl?.endRefreshing()
        categoriesCollectionViewTwo.refreshControl?.endRefreshing()
        categoriesViewModel.categories.removeAll()
        var count = -1
        for id in response.categories!{
            count = count + 1
            if count <= 4{
                categoriesViewModel.categories.append(id)
            }else{
                categoriesViewModelTwo.categories.append(id)

            }
            
        }
//        categoriesViewModel.categories = response.categories ?? []
        categoriesCollectionView.reloadData()
        categoriesCollectionViewTwo.reloadData()
    }
}
extension HomeVC {
    
    @objc func startApp(){
        navigationController?.view.removeInitialLoading()
    }
    
    @objc func startAPI(){
        page = 1
        let request = HomeModel.Request(page: page)
        viewModel.getHome(request: request) {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
        getMostSelling()
        getOffers()
//        productsCV.reloadData()

    }
    
    func getMostSelling() {
        viewModel.getMostSelling() { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.removeSpinner()
                self.viewModel.mostSellingProducts = response.products ?? []
                if self.viewModel.mostSellingProducts.count > 2 {
                    self.mostSellerCollectionView.isInfinite = true
                    self.mostSellerCollectionView.automaticSlidingInterval = 2.0
                }
                self.mostSellerCollectionView.isScrollEnabled = self.viewModel.mostSellingProducts.count > 2
                self.mostSellerCollectionView.reloadData()
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func getOffers() {
        viewModel.getOffers() { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.removeSpinner()
                guard let offers = response.offers else {return}
                self.viewModel.offers = offers
                if !(self.viewModel.offers.count > 0) {
                    self.zeroHeightConstraint.priority = UILayoutPriority(999)
                }
                self.sliderPagerView.reloadData()
            case .failure(let error): self.onFailure(error)
            }
        }
    }
}
extension HomeVC: ProductCellDelegate {
    func productAddedToFavorite(cell: ProductCell) {
        if User.isLoggedIn {
            guard let index = productsCV.indexPath(for: cell)?.row else {return}
            let product = viewModel.allProducts[index]
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
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return categoriesViewModel.categories.count
        }else if collectionView == categoriesCollectionViewTwo{
            return categoriesViewModelTwo.categories.count
        } else {
            return viewModel.allProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCellGrid.identifier, for: indexPath) as! CategoriesCellGrid
            let model = categoriesViewModel.categories[indexPath.row]
            cell.config(with: model)
            cell.setBorder()
            return cell
        }else if collectionView == categoriesCollectionViewTwo {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCellGrid.identifier, for: indexPath) as! CategoriesCellGrid
            let model = categoriesViewModelTwo.categories[indexPath.row]
            cell.config(with: model)
            cell.setBorder()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
            let model = viewModel.allProducts[indexPath.row]
            //            cell.favoriteButton.isHidden = false
            cell.delegate = self
            cell.config(with: model)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            categoriesRouter.dataSource?.category = categoriesViewModel.categories[indexPath.row]
            categoriesRouter.goToCategoriesDetails()
        }else  if collectionView == categoriesCollectionViewTwo {
            categoriesRouter.dataSource?.category = categoriesViewModelTwo.categories[indexPath.row]
            categoriesRouter.goToCategoriesDetails()
        } else {
            router.dataSource?.productId = viewModel.allProducts[indexPath.row].id
            router.goToProductDetails()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.frame.width
        var height = collectionView.frame.height
        if collectionView == categoriesCollectionView {
            width = width / 3 - 20
            height = height - 22
        }else if collectionView == categoriesCollectionViewTwo {
            width = width / 3 - 20
            height = height - 22
        } else {
            return CGSize(width: (collectionView.frame.size.width - 10) / 2 , height: (view.frame.height - 10) / 2)
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == categoriesCollectionView {
            return UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
        }else if collectionView == categoriesCollectionViewTwo {
            return UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
        }
        return UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if collectionView == productsCV {
//            let indexPath1 = productsCV.visibleCurrentCellIndexPath
//            print("visibleIndexPath",indexPath1?.row ?? 0)
//            if indexPath1?.row ?? 0 == self.viewModel.allProducts.count - 1{
//
//                if isPageRefreshing {
//                    //                self.productsCV.refreshControl?.beginRefreshing()
//                    isPageRefreshing = false
//                    page += 1
//                    fetchMoreData(pageNum: page)
//                }
//            }
//        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //        if collectionView == categoriesCollectionView {
        //            return 8
        //        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoriesCollectionView {
            return 8
        }else  if collectionView == categoriesCollectionViewTwo {
            return 8
        }
        return 0
    }
}
extension HomeVC: FSPagerViewDataSource, FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        if pagerView == mostSellerCollectionView {
            return viewModel.mostSellingProducts.count
        }
        self.pageControl.numberOfPages = viewModel.offers.count
        return viewModel.offers.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if pagerView == mostSellerCollectionView {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: HomeCell.identifier, at: index) as! HomeCell
            let model = viewModel.mostSellingProducts[index]
            cell.config(with: model)
            cell.favoriteButton.isHidden = true
            return cell
        } else {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: IntroCell.identifier, at: index) as! IntroCell
            cell.productImage.setImage(url: viewModel.offers[index].imageUrl)
            return cell
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
       

    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        if pagerView == mostSellerCollectionView {
            
        } else {
            self.pageControl.currentPage = targetIndex
        }
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        if pagerView == mostSellerCollectionView {
            
        } else {
            self.pageControl.currentPage = pagerView.currentIndex
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if pagerView == mostSellerCollectionView {
            router.dataSource?.productId = viewModel.mostSellingProducts[index].id
            router.goToProductDetails()
        } else {
            if (viewModel.offers[index].clickable ?? 0) == 1 {
                guard let products = viewModel.offers[index].products else {return}
                router.dataSource?.offerProducts = products
                router.goToDesignerDetails()
            }
        }
    }
}

