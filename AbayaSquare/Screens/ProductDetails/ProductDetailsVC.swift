//
//  ProductDetailsVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit
import FSPagerView
import PPBadgeViewSwift
import SafariServices
import FirebaseDynamicLinks
import Kingfisher
var selectedSSize : Size?
class ProductDetailsVC: UIViewController {
    
    @IBOutlet weak var lblSoldOut: UILabel!
    @IBOutlet weak var soldOutView: UIView!
    @IBOutlet weak var btnChart: UIButton!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblLearbMore: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imagesPager: FSPagerView! {
        didSet {
            self.imagesPager.register(UINib(nibName: IntroCell.identifier, bundle: nil), forCellWithReuseIdentifier: IntroCell.identifier)
            self.imagesPager.automaticSlidingInterval = 5.0
        }
    }
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.setFillColor(.black, for: .selected)
            self.pageControl.setFillColor(UIColor("#000000").withAlphaComponent(0.5), for: .normal)
        }
    }
    
    @IBOutlet weak var productNameLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var saleLB: UILabel!
    @IBOutlet weak var offLB: UILabel!
    @IBOutlet weak var designerImage: UIImageView!
    @IBOutlet weak var designerNameLB: UILabel!
    @IBOutlet weak var offCouponLB: UILabel!
    @IBOutlet weak var couponLB: UILabel!
    @IBOutlet weak var sizesCV: UICollectionView!
    @IBOutlet weak var detailsLB: UILabel!
    @IBOutlet weak var detailsArrow: UIImageView!
    @IBOutlet weak var deliveryArrow: UIImageView!
    @IBOutlet weak var deliveryLB: UILabel!
    @IBOutlet weak var productsCV: UICollectionView!
    @IBOutlet weak var relatedProductsView: UIView!
    @IBOutlet weak var availableOfferStack: UIStackView!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var returnView: UIView!
    @IBOutlet weak var favoriteButtonStack: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var addToCartStack: UIView!
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var tabbyView: UIView!
    @IBOutlet weak var noInterestLB: UILabel!
    @IBOutlet weak var tabbyPaymentLB: UILabel!
    @IBOutlet weak var tamaraPaymentLB: UILabel!
    @IBOutlet weak var learnMoreLB: UIButton!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var viewsCountView: UIView!

    var likeButton = UIButton()
    let router = ProductDetailsRouter()
    let viewModel = ProductDetailsViewModel()
    var index = -1
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
        self.lblSoldOut.layer.cornerRadius = 10
        self.lblSoldOut.clipsToBounds = true
        
        self.lblSoldOut.layer.borderWidth = 1
        self.lblSoldOut.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        self.sizesCV.allowsMultipleSelection = false
        self.soldOutView.isHidden = true
        router.viewController = self
        router.dataSource = viewModel
        productsCV.register(nibName: ProductCell.identifier)
        setupBarButtons()
        setupRefreshControl()
        getDetails()
        setupBadge()
        mainScrollView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(setupBadge), name: .UserDidAddProduct, object: nil)
        setViewsCount()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
    
    func setViewsCount() {
        let settings = UserDefaultsManager.config.data?.settings
        guard let randomFrom = Int(settings?.randomFrom ?? "0"), let randomTo = Int(settings?.randomTo ?? "0") else {return}
        let viewsCount = Int.random(in: randomFrom...randomTo)
        viewsCountLabel.text = "\(viewsCount) " + "other people are watching this product".localized
    }
    
    @IBAction func dismissWatchingView(_ sender: UIButton) {
        viewsCountView.isHidden = true
    }
    
    @IBAction func didTapShowAllOffers(_ sender: Any) {
        router.goToDiscountCodes()
    }
    
    @IBAction func didTapApplyCode(_ sender: Any) {
        guard let offer = viewModel.product?.offer else {return}
        if CoreDataManager.getProdcuts().isEmpty {
            MainHelper.shared.showErrorMessage(responseMessage: "Cart Empty Can't Apply Code".localized)
        } else {
            let id = Int(CoreDataManager.getDesigners().first {$0 == offer.id} ?? 0).int16
            
            if id == offer.designer?.id.int16  {
                let designerId = offer.designer?.id.int16 ?? 0
                let couponRatio = offer.discountRatio.zeroIfNull
                let code = offer.code.emptyIfNull
                CoreDataManager.updateProduct(designerId: designerId, couponId: id, couponRatio: couponRatio, couponCode: code)
                MainHelper.shared.showSuccessMessage(responseMessage: "Discount Code has been applied to all the products in the cart from the designer".localized)
            } else {
                MainHelper.shared.showErrorMessage(responseMessage: "No Products in the cart form this designer".localized)
            }
        }
    }
    
    @IBAction func didTapShowSizes(_ sender: Any) {
        guard let imageUrl = UserDefaultsManager.config.data?.sizesImage else {return}
        let url: URL! = URL(string: imageUrl)
        let svc = SFSafariViewController(url: url! as URL)
        svc.delegate = self
        svc.title = "Size Chart".localized
        navigationController?.pushViewController(svc, animated: true)
    }
    
    @IBAction func didTapShowMoreDetails(_ sender: UIButton) {
        if detailsLB.isHidden {
            detailsLB.isHidden = false
            detailsArrow.transform = detailsArrow!.transform.rotated(by: .pi)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.detailsArrow.transform = self.detailsArrow!.transform.rotated(by: .pi)
                self.detailsLB.isHidden = true
            }
        }
    }
    
    @IBAction func didTapShowMoreDelivery(_ sender: UIButton) {
        if deliveryLB.isHidden {
            deliveryLB.isHidden = false
            deliveryArrow.transform = deliveryArrow!.transform.rotated(by: .pi)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.deliveryArrow.transform = self.deliveryArrow!.transform.rotated(by: .pi)
                self.deliveryLB.isHidden = true
            }
        }
    }
    
    @IBAction func didTapAddToCart(_ sender: Any) {
        
        guard let size = viewModel.product?.sizes?.first(where: {$0.sizeId == viewModel.selectedSize?.sizeId}) else {
            MainHelper.shared.showNoticeMessage(message: "You Must Select a Size First".localized)
            return
        }
        
        guard let product = viewModel.product else { return }
        
        if CoreDataManager.checkProductExists(id: product.id, sizeId: size.sizeId.zeroIfNull) {
            guard let productEntity = CoreDataManager.getProduct(id: size.sizeId.zeroIfNull) else {return}
            guard CoreDataManager.isQuantityAvailable(product: productEntity) else {
                MainHelper.shared.showNoticeMessage(message: "Quantity isn't Available".localized)
                return
            }
            CoreDataManager.insert(prodcut: product, quantity: 1, size: size)
            MainHelper.shared.showSuccessMessage(responseMessage: "Quantity Increased".localized)
        } else {
            guard size.qty.zeroIfNull > 0 else {
                MainHelper.shared.showNoticeMessage(message: "Quantity isn't Available".localized)
                return
            }
            MainHelper.shared.showSuccessMessage(responseMessage: "Product Was Added To Cart".localized)
            CoreDataManager.insert(prodcut: product, quantity: 1, size: size)
            if CoreDataManager.isSameDesigner(designerId: product.designer?.id ?? 0) {
                let coupon = CoreDataManager.getCouponDetails(designerId: product.designer?.id ?? 0)
                CoreDataManager.updateProduct(designerId: coupon?.designerId ?? 0, couponId: coupon?.couponId ?? 0, couponRatio: coupon?.couponRatio ?? 0, couponCode: coupon?.couponCode ?? "")
            } else {
                
            }
            NotificationCenter.default.post(name: .UserDidAddProduct, object: nil)
        }
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        viewModel.selectedSize = nil
        likeButtonPressed()
    }
    
    @IBAction func didTapShareProduct(_ sender: Any) {
        
        guard let product = viewModel.product else {return}
        var components = URLComponents()
        components.scheme = "https"
        components.host = "abayasquare.com"
        components.path = "/api/v1/get-product-details"
        
        let itemIDQueryItem = URLQueryItem(name: "productId", value: product.id.description)
        components.queryItems = [itemIDQueryItem]
        
        guard let linkParameter = components.url else { return }
        
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://abayasquare.page.link") else {
            print("error with the link")
            return
        }
        
        if let myBundle = Bundle.main.bundleIdentifier {
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundle)
        }
        
        guard let imageUrl = URL(string: product.mainImage.emptyIfNull) else {return}
        
        shareLink.androidParameters = DynamicLinkAndroidParameters(packageName: "com.selsela.abayasquare")
        shareLink.iOSParameters?.appStoreID = "1572412908"
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = product.name.emptyIfNull
        shareLink.socialMetaTagParameters?.descriptionText = product.details.emptyIfNull.htmlStripped
        shareLink.socialMetaTagParameters?.imageURL = imageUrl
        guard let longUrl = shareLink.url else {return}
        print("longUrl: \(longUrl)")
        shareLink.shorten { [unowned self] (url, warningsString, error) in
            if let error = error {
                print("error \(error.localizedDescription)")
                return
            }
            if let warningsString = warningsString {
                warningsString.forEach { print($0) }
            }
            
            guard let shortUrl = url else {return }
            print("the short url to share: \(shortUrl)")
            var activityItems: [Any] = []
            activityItems.append(shortUrl)
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapGoToDesignerDetails(_ sender: Any) {
        router.dataSource?.designer = viewModel.product?.designer
        router.goToDesignerDetails()
    }
    
    @IBAction func didTapLearnMoreTabby(_ sender: Any) {
        let url: URL! = URL(string: L102Language.isRTL ? viewModel.tabbyArUrl : viewModel.tabbyEnUrl)
        let svc = SFSafariViewController(url: url! as URL)
        present(svc, animated: true)
    }
    
    @IBAction func didTapLearnMoreTamara(_ sender: Any) {
        guard let prod = viewModel.product else { return }
        let uurl = "https://cdn.tamara.co/widget/tamara-introduction.html?lang=en&widgetType=product-widget&paymentType=installment&price=\(String(format: "%.2f",prod.salePrice ?? 0.0))&currency=SAR"
        let url: URL! = URL(string: uurl)
        let svc = SFSafariViewController(url: url! as URL)
        present(svc, animated: true)
    }
    
    
}

extension ProductDetailsVC {
    
    func setupTabbyView(amount: Double){
        let tabbyAmout: Double = amount / 4
        let tamaraAmout: Double = amount / 3
        tabbyPaymentLB.text = tabbyAmout.clean + " " + MainHelper.shared.currency
        tamaraPaymentLB.text = "\(String(format: "%.2f",tamaraAmout))"
        learnMoreLB.underline(font: .systemFont(ofSize: 13))
        lblLearbMore.underline(font: .systemFont(ofSize: 13))
        
        if !L102Language.isRTL {
            noInterestLB.isHidden = true
        }
    }
    
    func setupRefreshControl() {
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.tintColor = .black
        scrollView.refreshControl?.addTarget(self, action: #selector(startAPI), for: .valueChanged)
    }
    
    func setupBarButtons(){
        likeButton.setImage(UIImage(named: "ic_like_black")!, for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        let cartButton = UIBarButtonItem(image: UIImage(named: "ic_cart_big"), style: .plain, target: self, action: #selector(cartButtonPressed))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: likeButton), cartButton]
    }
    
    func setupDetails(){
        guard let prod = viewModel.product else { return }
        productNameLB.text = prod.name
//       
//        UserDefaultsManager.cod = prod.cod ?? 0
        UserDefaultsManager.flag = prod.offer?.flag ?? 0
        UserDefaultsManager.flag = prod.offer?.show ?? 0
        UserDefaultsManager.discount_ratio = prod.discountRatio ?? 0.0
        priceLB.text = prod.salePrice.zeroIfNull.clean + " " + MainHelper.shared.currency
        if prod.discountRatio == 0 {
            saleLB.isHidden = true
            offLB.isHidden =  true
        } else {
            let discount = NSMutableAttributedString(string: prod.price.zeroIfNull.clean + MainHelper.shared.currency).with(font: .mySystemFont(ofSize: 15)).with(textColor: UIColor("#999999")).with(strikethroughColor: "#999999")
            saleLB.attributedText = discount
            offLB.text = prod.discountRatio.zeroIfNull.clean + " % " + "OFF".localized
        }
        designerNameLB.text = prod.designer?.name
        designerImage.setImage(url: prod.designer?.imageUrl)
        viewModel.sizes = prod.sizes ?? []
        viewModel.sizes.isEmpty ? (sizeView.isHidden = true) : (sizeView.isHidden = false)
        
        if viewModel.sizes.contains(where: {$0.qty ?? 0 > 0}){
            
            self.btnChart.isHidden = false
            self.lblSize.isHidden = false
            self.sizesCV.isHidden = false
            self.soldOutView.isHidden = true
            sizesCV.reloadData()

        }else{
            
            self.btnChart.isHidden = true
            self.lblSize.isHidden = true
            self.sizesCV.isHidden = true
            self.soldOutView.isHidden = false
        }
        viewModel.images = prod.images ?? []
        if viewModel.images.isEmpty {
            viewModel.images.append(prod.mainImage ?? "")
        }
        imagesPager.reloadData()
        let data = prod.details?.htmlStripped.replacingOccurrences(of: "&nbsp;", with: "")
        detailsLB.text = data?.replacingOccurrences(of: "nbsp;", with: "")
        if prod.inFavorite == true {
            likeButton.setImage(UIImage(named: "ic_like_fill")!, for: .normal)
            favoriteButton.setImage(UIImage(named: "ic_like_fill")!, for: .normal)
            favoriteButtonStack.setImage(UIImage(named: "ic_like_fill")!, for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "ic_like_black")!, for: .normal)
            favoriteButton.setImage(UIImage(named: "ic_like")!, for: .normal)
            favoriteButtonStack.setImage(UIImage(named: "ic_like")!, for: .normal)
        }
        viewModel.relatedProducts = prod.relatedProducts ?? []
        productsCV.reloadData()
        
        if viewModel.relatedProducts.isEmpty {
            relatedProductsView.isHidden = true
        }
        
        if let coupon = prod.offer {
            if coupon.show == 1{
                availableOfferStack.isHidden = false
                if coupon.flag == 1{
                    let data = "Get a".localized
                    let dis = "discount offer".localized
                    
                    offCouponLB.text = "\(data) \(coupon.discountRatio ?? 0.0)% \(dis)"
                    
//                    "\(data) \(coupon.discountRatio ?? 0.0)% \(dis))"
//                    + " " + coupon.discountRatio.zeroIfNull.clean + " " + "%"
                }else if coupon.flag == 2{
                    
                    let data = "Get a discount offer of".localized
                    let sar = "SAR".localized
                    
                    offCouponLB.text = "\(data) \(coupon.discountRatio ?? 0.0) \(sar)"//+ \(coupon.discountRatio ?? 0.0) ".localized
//                    + " " + coupon.discountRatio.zeroIfNull.clean + " " + "%"
                }else if coupon.flag == 3{
                    offCouponLB.text = "Get a free shipping".localized
//                    + " " + coupon.discountRatio.zeroIfNull.clean + " " + "%"
                }else{
                    availableOfferStack.isHidden = true
                }
                couponLB.text = coupon.code
            }else{
                availableOfferStack.isHidden = true
            }
        } else {
            availableOfferStack.isHidden = true
        }
        
        if let returnPolicy = prod.designer?.returnPolicy {
            deliveryLB.text = returnPolicy.htmlStripped
        } else {
            returnView.isHidden = true
        }
        
        setupTabbyView(amount: prod.salePrice.zeroIfNull)
    }
    
    @objc func setupBadge(){
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItems?.last?.pp.addBadge(number: CoreDataManager.getTotalCount())
            self.navigationItem.rightBarButtonItems?.last?.pp.badgeView.backgroundColor = UIColor("#EA4F5E")
        }
    }
    
    func getDetails(){
        view.showSpinner(spinnerColor: .black)
        startAPI()
    }
    
    @objc func startAPI(){
        let request = ProductDetailsModel.Request(productId: viewModel.productId)
        viewModel.getProductDetails(request: request) {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onSuccess(_ response: ProductDetailsModel.Response){
        viewModel.product = response.product
        title = viewModel.product?.name
        setupDetails()
        scrollView.refreshControl?.endRefreshing()
        removeSpinner()
    }
}

extension ProductDetailsVC {
    @objc func likeButtonPressed(){
        
        if User.isLoggedIn {
       
            guard let product = viewModel.product else { return }
            (product.inFavorite == false) ? (product.inFavorite = true) : (product.inFavorite = false)
//            setupDetails()
            if viewModel.product?.inFavorite == true {
                likeButton.setImage(UIImage(named: "ic_like_fill")!, for: .normal)
                favoriteButton.setImage(UIImage(named: "ic_like_fill")!, for: .normal)
                favoriteButtonStack.setImage(UIImage(named: "ic_like_fill")!, for: .normal)
            } else {
                likeButton.setImage(UIImage(named: "ic_like_black")!, for: .normal)
                favoriteButton.setImage(UIImage(named: "ic_like")!, for: .normal)
                favoriteButtonStack.setImage(UIImage(named: "ic_like")!, for: .normal)
            }
            let request = AddToFavorite.Request(productId: viewModel.product?.id)
            viewModel.addToFav(request: request) {result in
                switch result {
                case .success(_): NotificationCenter.default.post(name: .DidRemoveFavorite, object: nil)
                case .failure(_): (product.inFavorite == false) ? (product.inFavorite = true) : (product.inFavorite = false);
                }
            }
        } else {
            MainHelper.shared.showErrorMessage(responseMessage: "You Must Login to like the product".localized)
        }
    }
    
    @objc func cartButtonPressed(){
        tabBarController?.selectedIndex = 3
        navigationController?.popViewController(animated: true)
        //        router.goToCart()
    }
}

extension ProductDetailsVC: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        self.pageControl.numberOfPages = viewModel.images.count
        return viewModel.images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: IntroCell.identifier, at: index) as! IntroCell
        cell.productImage.setImage(url: viewModel.images[index])
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {

        
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
        self.router.dataSource?.images = self.viewModel.images
        self.router.goToProductImages()
    }
}

extension ProductDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sizesCV {
            return viewModel.product?.sizes?.count ?? 0
        } else {
            return viewModel.relatedProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sizesCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCellCV", for: indexPath) as! SizeCellCV
            cell.sizeLB.text = viewModel.product?.sizes?[indexPath.row].size
            if let qty = viewModel.product?.sizes?[indexPath.row].qty, qty > 0  {
                cell.backView.borderType = .solid
        
            } else {
                cell.setupForUnAvailable()
            }

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
            let model = viewModel.relatedProducts[indexPath.row]
            cell.config(with: model)
            cell.likeButton.isHidden = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sizesCV {
//            guard let qty = viewModel.sizes[indexPath.row].qty, qty > 0 else {return}
//            viewModel.selectedSize = viewModel.sizes[indexPath.row]
//            selectedSSize = viewModel.sizes[indexPath.row]
            if self.index == -1{
                self.index = indexPath.row
                viewModel.selectedSize = viewModel.sizes[indexPath.row]

                guard let cell = collectionView.cellForItem(at: indexPath) as? SizeCellCV else {return}
                cell.setupSelected()
            }else{
                guard let cell = collectionView.cellForItem(at: self.index) as? SizeCellCV else {return}
                cell.setupUnselected()
                self.index = indexPath.row
                guard let cell = collectionView.cellForItem(at: indexPath) as? SizeCellCV else {return}
                cell.setupSelected()
                viewModel.selectedSize = viewModel.sizes[indexPath.row]

            }
//            self.sizesCV.reloadData()
//            self.view.layoutIfNeeded()
        } else {
            router.dataSource?.productId = viewModel.relatedProducts[indexPath.row].id
            router.goToProductDetails()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView == sizesCV {
            return viewModel.sizes[indexPath.row].qty != nil && viewModel.sizes[indexPath.row].qty ?? 0 > 0
        }
        return true
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if collectionView == sizesCV {
//            guard let qty = viewModel.sizes[indexPath.row].qty, qty > 0 else {return}
////            viewModel.selectedSize = viewModel.sizes[indexPath.row]
////            selectedSSize = viewModel.sizes[indexPath.row]
//
//            guard let cell = collectionView.cellForItem(at: indexPath) as? SizeCellCV else {return}
//            cell.setupUnselected()
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170 , height: 310)
    }
}

extension ProductDetailsVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == mainScrollView else {return}
        if scrollView.contentOffset.y > 390 {
            addToCartView.isHidden = true
            addToCartStack.isHidden = false
        } else {
            addToCartView.isHidden = false
            addToCartStack.isHidden = true
        }
    }
}

extension ProductDetailsVC: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
}
