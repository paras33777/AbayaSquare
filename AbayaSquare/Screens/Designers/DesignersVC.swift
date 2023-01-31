//
//  DesignersVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit
import FSPagerView
import Kingfisher

class DesignersVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productsView: UIView!
    @IBOutlet weak var productsPager: FSPagerView! {
        didSet {
            self.productsPager.register(UINib(nibName: ProductImageCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProductImageCell.identifier)
            self.productsPager.automaticSlidingInterval = 5.0
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.setFillColor(UIColor("#7C7160"), for: .selected)
            self.pageControl.setFillColor(UIColor("#7C7160").withAlphaComponent(0.5), for: .normal)
        }
    }
    
    @IBOutlet weak var designersCV: UICollectionView!
    
    private let router = DesignersRouter()
    let viewModel = DesignersViewModel()
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
        designersCV.register(nibName: DesignerCell.identifier)
        setupRefreshControl()
        getDesigners()
        scrollView.delegate = self
    }
    
    @IBAction func didTapGoToSearch(_ sender: Any) {
        router.goToSearch()
    }
    
    @IBAction func didTapGoToCategories(_ sender: Any) {
        router.goToCategories()
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        tabBarController?.selectedIndex = 4
    }
}

extension DesignersVC {
    func setupRefreshControl() {
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.tintColor = .black
        scrollView.refreshControl?.addTarget(self, action: #selector(startAPI), for: .valueChanged)
    }
    
    func getDesigners(){
        scrollView.showSpinner(spinnerColor: .black)
        startAPI()
    }
    
    func onSuccess(_ response: DesignerModel.Response){
        removeSpinner()
        scrollView.refreshControl?.endRefreshing()
        viewModel.sliders = response.sliders ?? []
        viewModel.sliders.removeAll(where: {$0.imageUrl == nil})
        productsPager.reloadData()
        if viewModel.sliders.isEmpty {
            productsView.isHidden = true
        }
        viewModel.designers = response.designers ?? []
        isPageRefreshing = response.hasMorePage ?? false
        designersCV.reloadData()
    }
    
    func fetchMoreData(pageNum: Int){
        let request = DesignerModel.Request(page: pageNum)
        viewModel.getDesigners(request: request) {result in
            switch result{
            case .success(let response): self.onMoreSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onMoreSuccess(_ response: DesignerModel.Response) {
        viewModel.designers += response.designers ?? []
        designersCV.reloadData()
        isPageRefreshing = response.hasMorePage ?? false
    }
}

extension DesignersVC {
    @objc func startAPI() {
        page = 1
        let request = DesignerModel.Request(page: page)
        viewModel.getDesigners(request: request) { result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
}

extension DesignersVC: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        self.pageControl.numberOfPages = viewModel.sliders.count
        return viewModel.sliders.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier, at: index) as! ProductImageCell
        let model = viewModel.sliders[index]
        cell.productImage.setImage(url: model.imageUrl)
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if (viewModel.sliders[index].clickable ?? 0) == 1 {
            guard let products = viewModel.sliders[index].products else {return}
            router.dataSource?.sliderProducts = products
            router.goToDesignerDetailsWithProducts()
        }
    }
}

extension DesignersVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.designers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DesignerCell.identifier, for: indexPath) as! DesignerCell
        let model = viewModel.designers[indexPath.row]
        cell.config(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router.dataSource?.designer = viewModel.designers[indexPath.row]
        router.goToDesignerDetails()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width) / 3 , height: 120)
    }
}

extension DesignersVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.scrollView.contentOffset.y >= (self.scrollView.contentSize.height - self.scrollView.bounds.size.height)) {
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
}

