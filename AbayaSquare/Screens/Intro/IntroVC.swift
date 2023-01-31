//
//  IntroVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/23/21.
//

import UIKit
import FSPagerView

class IntroVC: UIViewController {
    
    @IBOutlet weak var imagePager: FSPagerView! {
        didSet {
            self.imagePager.register(UINib(nibName: IntroCell.identifier, bundle: nil), forCellWithReuseIdentifier: IntroCell.identifier)
            self.imagePager.automaticSlidingInterval = 5.0
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.setImage(UIImage(named: "silderNormal"), for: .normal)
            self.pageControl.setImage(UIImage(named: "sliderSelected"), for: .selected)
            
        }
    }

    @IBOutlet weak var discountLB: UILabel!
    
    private let  router = IntroRouter()
    var images: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAppContent()
        router.viewController = self
    }
    
    @IBAction func didTapDiscount(_ sender: Any) {
    }
    
    @IBAction func didTapGoToLogin(_ sender: Any) {
        router.goToLogin()
    }
    
    @IBAction func didTapGoToHome(_ sender: Any) {
        router.goToHome()
    }
}

extension IntroVC {
    func setupDetails(){
        
    }
    
    func getAppContent() {
        view.showSpinner(spinnerColor: .Color333333)
        API.shared.startAPI(endPoint: .getConfig, req: ConfigModel.Request()) { (result: Response<ConfigModel.Response>) in
            switch result {
            case .success(let reponse): self.onSuccess(reponse)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onSuccess(_ response: ConfigModel.Response){
        removeSpinner()
        let string1 = NSMutableAttributedString(string: response.data?.settings?.splashPromotionTextAr ?? "").with(font: .boldSystemFont(ofSize: 14)).with(textColor: .white)
        discountLB.attributedText = [string1].joined
        images = response.data?.splashImages ?? []
        imagePager.reloadData()
    }
}

extension IntroVC: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        self.pageControl.numberOfPages = images.count
        return images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: IntroCell.identifier, at: index) as! IntroCell
        cell.productImage.setImage(url: images[index])
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}
