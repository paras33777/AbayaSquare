//
//  DesignerDetailsVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit
import IBAnimatable
import Kingfisher

class DesignerDetailsVC: UIViewController {
    
    @IBOutlet weak var productsCV: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var vcTitle = UILabel()
    private let router = DesignerDetailsRouter()
    let viewModel = DesignerDetailsViewModel()
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
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
        setupRefreshControl()
        setupBar()
        setupObservers()
        if viewModel.products.count > 0 { //From "offer slider" || "designers slider"
            checkEmpty()
        } else if viewModel.isFormFilterHome == 0 {
            getDesignerDetails()
        } else {
            emptyView.isHidden = true
            viewModel.products = viewModel.filterResponse?.products ?? []
            viewModel.isPageRefreshing = viewModel.filterResponse?.hasMorePage ?? false
            vcTitle.text = "Filter Results".localized + " (\(viewModel.filterResponse?.resultCount ?? 0))"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

extension DesignerDetailsVC {
    func setupObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(showAll), name: .ShowAll, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showHighest), name: .ShowHighestPrice, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showLowest), name: .ShowLowestPrice, object: nil)
    }
    
    func setupRefreshControl() {
        productsCV.refreshControl = UIRefreshControl()
        productsCV.refreshControl?.tintColor = .black
        productsCV.refreshControl?.addTarget(self, action: #selector(startAPI), for: .valueChanged)
    }
    
    func setupBar(){
        vcTitle = UILabel()
        vcTitle.textColor = UIColor("#333333")
        vcTitle.font = .boldSystemFont(ofSize: 14)
        
        let designerImage = AnimatableImageView()
        designerImage.translatesAutoresizingMaskIntoConstraints = false
        designerImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        designerImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        designerImage.cornerRadius = 15
        designerImage.clipsToBounds = true
        designerImage.contentMode = .scaleAspectFill
        
        
        if let designer = viewModel.designer {
            vcTitle.text = designer.name
            designerImage.setImage(url: designer.imageUrl)
        } else if let category = viewModel.category {
            vcTitle.text = category.name
            designerImage.setImage(url: category.imageUrl)
        } else {
            designerImage.isHidden = true
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonPressed))
        designerImage.addGestureRecognizer(gesture)
        var image: UIImage?
        if L102Language.isRTL {
            image = UIImage(named: "ic_back")?.withHorizontallyFlippedOrientation()
        } else {
            image = UIImage(named: "ic_back")
        }
        
        let closeButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(closeButtonPressed))
        
        let searchButton = UIButton()
        searchButton.setImage(UIImage(named: "ic_search_big"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        
        let sortButton = UIButton()
        sortButton.setImage(UIImage(named: "ic_sort"), for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonPressed), for: .touchUpInside)
        
        let filterButton = UIButton()
        filterButton.setImage(UIImage(named: "ic_filter"), for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [sortButton,filterButton,searchButton])
        stackView.spacing = 16
        
        if viewModel.isFormFilterHome == 0 { navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView) }
        
        navigationItem.leftBarButtonItems = [closeButton,UIBarButtonItem(customView: designerImage),UIBarButtonItem(customView: vcTitle)]
    }
    
    func getDesignerDetails(){
        view.showSpinner(spinnerColor: .black)
        startAPI()
    }
    
    func onSuccess(_ response: HomeModel.Response){
        viewModel.products = []
        viewModel.products = response.products ?? []
        productsCV.reloadData()
        viewModel.isPageRefreshing = response.hasMorePage ?? false
        removeSpinner()
        productsCV.refreshControl?.endRefreshing()
        checkEmpty()
    }
    
    func checkEmpty(){
        viewModel.products.isEmpty ? (emptyView.isHidden = false ) : (emptyView.isHidden = true)
//        pageNoLabel.isHidden = !emptyView.isHidden
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.productsCV.contentOffset.y >= (self.productsCV.contentSize.height - self.productsCV.bounds.size.height)) {
            if viewModel.isPageRefreshing {
                viewModel.isPageRefreshing = false
                viewModel.page += 1
//                pageNoLabel.text = "\(viewModel.page)"

                KingfisherManager.shared.cache.clearMemoryCache()
                KingfisherManager.shared.cache.clearDiskCache()
                KingfisherManager.shared.cache.cleanExpiredDiskCache()
                self.fetchMoreData(pageNum: self.viewModel.page)

            }
        }
    }
    
    func fetchMoreData(pageNum: Int){
        if viewModel.isFromFilter == 1 || viewModel.isFormFilterHome == 1 {
            var request = viewModel.filterPaggingRequest
            request.page = pageNum
            activityIndicator.startAnimating()
            viewModel.filterProducts(request: request) { result in
                switch result {
                case .success(let response): self.onMoreSuccess(response)
                case .failure(let error): self.onFailure(error)
                }
            }
        } else {
            let request = FilterModel.FiltetProductsRequest(designerId:viewModel.designer?.id, categoryId: viewModel.category?.id, page: viewModel.page)
            activityIndicator.startAnimating()
            viewModel.filterProducts(request: request) {result in
                switch result{
                case .success(let response): self.onMoreSuccess(response)
                case .failure(let error): self.onFailure(error)
                }
            }
        }
    }
    
    func onMoreSuccess(_ response: HomeModel.Response) {
        activityIndicator.stopAnimating()
        viewModel.products += response.products ?? []
        self.productsCV.reloadData()
        viewModel.isPageRefreshing = response.hasMorePage ?? false
    }
}

extension DesignerDetailsVC {
    
    @objc func startAPI() {
        viewModel.page = 1
//        pageNoLabel.text = "\(viewModel.page)"
        let request = FilterModel.FiltetProductsRequest(designerId:viewModel.designer?.id, categoryId: viewModel.category?.id, page: viewModel.page)
        viewModel.getDesignerProducts(request: request) {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    @objc func closeButtonPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func searchButtonPressed(){
        router.goToSearch()
    }
    
    @objc func filterButtonPressed(){
        router.dataSource?.designerId = viewModel.designer?.id
        router.dataSource?.categoryId = viewModel.category?.id
        router.goToFilter()
    }
    
    @objc func sortButtonPressed(){
        router.goToSort()
    }
    
    @objc func showAll(){
        viewModel.products.sort(by: {$0.id > $1.id})
        productsCV.reloadData()
    }
    
    @objc func showHighest(){
        viewModel.products.sort(by: {$0.salePrice.zeroIfNull > $1.salePrice.zeroIfNull})
        productsCV.reloadData()
    }
    
    @objc func showLowest(){
        viewModel.products.sort(by: {$0.salePrice.zeroIfNull < $1.salePrice.zeroIfNull})
        productsCV.reloadData()
    }
}

extension DesignerDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

extension DesignerDetailsVC: ProductCellDelegate {
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

extension DesignerDetailsVC: FilterDelegate {
    func didFilter(products: [Product],filterReqeust: FilterModel.FiltetProductsRequest,isFromFilter: Int) {
        viewModel.products = products
        productsCV.reloadData()
        viewModel.filterPaggingRequest = filterReqeust
        viewModel.isFromFilter = isFromFilter
    }
}
