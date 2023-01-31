//
//  FilterVC.swift
//  AbayaSquare
//
//  Created by Ayman  on 5/24/21.
//

import UIKit
import MultiSlider
import IBAnimatable

protocol FilterDelegate {
    func didFilter(products: [Product], filterReqeust: FilterModel.FiltetProductsRequest,isFromFilter: Int)
}

class FilterVC: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var filterTypesTV: UITableView!
    @IBOutlet weak var filterTV: UITableView!
    @IBOutlet weak var viewTV: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var pricesSlider: MultiSlider!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var selectedFiltersLB: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    
    let router = FilterRouter()
    var type: FilterType = .Category
    let viewModel = FilterViewModel()
    var delegate: FilterDelegate?
    var isSearchActive = 0
    var isFromHome = 0
    var filterResultCount = 0
    var vcCase: FilterCases = .CategoryFilter
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
        getFilterContent()
        setupSlider()
    }
    
    @IBAction func didBeginSearch(_ sender: UITextField) {
        isSearchActive = 1
        filterTV.reloadData()
        UIView.animate(withDuration: 0.03) {
            self.closeButton.isHidden = false
        }
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        emptyView.isHidden = true
        viewModel.searchResults = []
        searchTF.text = nil
        searchTF.resignFirstResponder()
        isSearchActive = 0
        filterTV.reloadData()
        
        UIView.animate(withDuration: 0.03) {
            self.closeButton.isHidden = true
        }
    }
    
    @IBAction func didSearch(_ sender: UITextField) {
        let filteredStrings = viewModel.categories.filter({(item: Category) -> Bool in
            let stringMatch = item.name.emptyIfNull.range(of: sender.text.emptyIfNull)
            return stringMatch != nil ? true : false
        })
        if filteredStrings.isEmpty {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
        
        viewModel.searchResults = filteredStrings
        filterTV.reloadData()
    }
    
    @IBAction func didEndSearch(_ sender: UITextField) {
        // closeButton.isHidden = true
    }
    
    @IBAction func didTapClear(_ sender: Any) {
        setupDeselecte()
        pricesSlider.minimumValue = CGFloat(viewModel.minPrice)
        pricesSlider.maximumValue = CGFloat(viewModel.maxPrice)
        pricesSlider.value[0] = CGFloat(viewModel.minPrice)
        pricesSlider.value[1] = CGFloat(viewModel.maxPrice)
        
    }
    
    @IBAction func didTapFilter(_ sender: UIButton) {
        sender.showSpinner(spinnerColor: .white)
        var selectedCategoriesId: [Int] = []
        
        viewModel.selectedCategories.forEach {
            selectedCategoriesId.append($0.id)
        }
        
        var selectedSizesId: [Int] = []
        
        viewModel.selectedSizes.forEach {
            selectedSizesId.append($0.id.zeroIfNull)
        }
        
        var selectedColorsId: [Int] = []
        
        viewModel.selectedColors.forEach {
            selectedColorsId.append($0.id)
        }
        
        viewModel.request = FilterModel.FiltetProductsRequest(categoriesList: selectedCategoriesId.description,
                                                        sizesList: selectedSizesId.description,
                                                        designerId: viewModel.designerId,
                                                        colorsList: selectedColorsId.description,
                                                        minPrice: Double(pricesSlider.value[0]),
                                                        maxPrice: Double(pricesSlider.value[1]),
                                                        categoryId: viewModel.categoryId)
        
        print("viewModel.filterProducts: \(viewModel.request)")
        
        viewModel.filterProducts(request: viewModel.request) {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
}

extension FilterVC {
    
    func setup(){
        router.viewController = self
        router.dataSource = viewModel
        filterTV.register(nibName: ColorCellTV.identifier)
        filterTV.register(nibName: CategoryCellTV.identifier)
        searchView.isHidden = false
        filterTV.tableFooterView = UIView().with(height: 90)
        filterTypesTV.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        if vcCase != .HomeFilter {
            viewModel.categoryId.zeroIfNull == 0 ? (vcCase = .DesignerFilter) : (vcCase = .CategoryFilter)
        }
        if vcCase == .CategoryFilter {
            viewModel.stings.removeFirst()
            type = .Color
            searchView.isHidden = true
        }
    }
    
    private func setupSlider(){
        pricesSlider.valueLabelPosition = .bottom
        pricesSlider.isValueLabelRelative = false
        pricesSlider.valueLabelFormatter.positiveSuffix = MainHelper.shared.currency
        pricesSlider.valueLabelFont = .boldSystemFont(ofSize: 12)
    }
    
    func setupNavigationBar(){
        let closeButton = UIBarButtonItem(image: UIImage(named: "ic_close"), style: .plain, target: self, action: #selector(closeButtonPressed))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func closeButtonPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    func getFilterContent(){
        view.showSpinner(spinnerColor: .black)
        viewModel.getFilterContent {result in
            switch result {
            case .success(let response): self.onSuccess(response)
            case .failure(let error): self.onFailure(error)
            }
        }
    }
    
    func onSuccess(_ response: FilterModel.Response){
        viewModel.categories = response.categories ?? []
        viewModel.categories.insert(Category(id: 0, name: "Select All".localized), at: 0)
        viewModel.sizes = response.sizes ?? []
        viewModel.sizes.insert(Size(id: 0, name: "Select All".localized), at: 0)
        viewModel.colors = response.colors ?? []
        viewModel.colors.insert(Color(id: 0, name: "Select All".localized,colorHex: "#FFFFFF"), at: 0)
        viewModel.maxPrice = response.maxPrice ?? 0
        viewModel.minPrice = response.minPrice ?? 0
        pricesSlider.minimumValue = CGFloat(viewModel.minPrice)
        pricesSlider.maximumValue = CGFloat(viewModel.maxPrice)
        pricesSlider.value[0] = CGFloat(viewModel.minPrice)
        pricesSlider.value[1] = CGFloat(viewModel.maxPrice)
        filterTV.reloadData()
        removeSpinner()
        viewModel.productCount = response.productsCount ?? 0
        getProductCount()
    }
    
    func onSuccess(_ response: HomeModel.Response) {
        removeSpinner()
        let products = response.products ?? []
        if products.isEmpty {
            MainHelper.shared.showNoticeMessage(message: "No Products Found".localized)
        } else {
            if vcCase == .HomeFilter {
                router.dataSource?.filterResponse = response
                router.dataSource?.homeFiltetRequest = viewModel.request
                router.goToFilterResults()
            } else {
                delegate?.didFilter(products: products,filterReqeust: viewModel.request,isFromFilter: 1)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func getProductCount(){
        let title = UILabel()
        title.numberOfLines = 0
        let filterString =  NSMutableAttributedString(string: "Filter".localized).with(font: .boldSystemFont(ofSize: 16)).with(textColor: UIColor("#333333"))
        let productCount = NSMutableAttributedString(string: "(\(viewModel.productCount)" + " " + "Products)".localized).with(font: .boldSystemFont(ofSize: 10)).with(textColor: UIColor("#333333"))
        title.textAlignment = .center
        title.attributedText = [filterString,.newLine, productCount].joined
        navigationItem.titleView = title
    }
    
    func setupLabel(){
        let label = AnimatableLabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor("#F3F3F3")
        label.clipsToBounds = true
        label.cornerRadius = 6
        
        var strings: [NSMutableAttributedString] = []
        
        let categoryFilters: [NSMutableAttributedString] = viewModel.selectedCategories.map {
            label.attributedText = NSMutableAttributedString(string: $0.name.emptyIfNull)
                .with(font: .myMediumSystemFont(ofSize: 12))
                .with(textColor: UIColor("#2C2826"))
            label.sizeToFit()
            label.frame.size.height += 12
            label.frame.size.width += 24
            let string = NSTextAttachment()
            string.image = UIImage(view: label)
            return NSMutableAttributedString(attachment: string)
        }
        
        let sizeFilters:[NSMutableAttributedString] = viewModel.selectedSizes.map {
            label.attributedText = NSMutableAttributedString(string: $0.name.emptyIfNull)
                .with(font: .myMediumSystemFont(ofSize: 12))
                .with(textColor: UIColor("#2C2826"))
            label.sizeToFit()
            label.frame.size.height += 12
            label.frame.size.width += 24
            let string = NSTextAttachment()
            string.image = UIImage(view: label)
            return NSMutableAttributedString(attachment: string)
        }
        
        let colorFilters: [NSMutableAttributedString] = viewModel.selectedColors.map {
            label.attributedText = NSMutableAttributedString(string: $0.name.emptyIfNull)
                .with(font: .myMediumSystemFont(ofSize: 12))
                .with(textColor: UIColor("#2C2826"))
            label.sizeToFit()
            label.frame.size.height += 12
            label.frame.size.width += 24
            let string = NSTextAttachment()
            string.image = UIImage(view: label)
            return NSMutableAttributedString(attachment: string)
        }
        
        strings.append(categoryFilters.joined)
        strings.append(colorFilters.joined)
        strings.append(sizeFilters.joined)
        selectedFiltersLB.attributedText = strings.joined
    }
    
    func setupSelected(){
        switch type {
        case .Category:
            if isSearchActive == 1 {
                for (index,cat) in viewModel.searchResults.enumerated() {
                    if cat.isSelected ?? false {
                        filterTV.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
                    }
                }
            } else {
                for (index,cat) in viewModel.categories.enumerated() {
                    if cat.isSelected ?? false {
                        filterTV.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
                    }
                }
            }
        case .Size:
            for (index,size) in viewModel.sizes.enumerated() {
                if size.isSelected ?? false {
                    filterTV.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
                }
            }
        case .Color:
            for (index,color) in viewModel.colors.enumerated() {
                if color.isSelected ?? false {
                    filterTV.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
                }
            }
        }
    }
    
    func setupDeselecte(){
        for index in 0..<viewModel.categories.count {
            if isSearchActive == 1 {
                filterTV.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
                viewModel.searchResults[index].isSelected = false
            } else {
                filterTV.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
                viewModel.categories[index].isSelected = false
            }
        }
        for index in 0..<viewModel.sizes.count {
            filterTV.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
            viewModel.sizes[index].isSelected = false
        }
        
        for index in 0..<viewModel.colors.count {
            filterTV.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
            viewModel.colors[index].isSelected = false
        }
        
        selectedFiltersLB.isHidden = true
        viewModel.selectedSizes = []
        viewModel.selectedCategories = []
        viewModel.selectedColors = []
        setupLabel()
    }
    
    func selectAllCategories() {
        for row in 0..<viewModel.categories.count{
            filterTV.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .middle)
            viewModel.selectedCategories.append(viewModel.categories[row])
            viewModel.categories[row].isSelected = true
        }
        viewModel.selectedCategories.removeAll(where: {$0.name == "Select All".localized})
        viewModel.selectedCategories = viewModel.selectedCategories.uniqued()
    }
    
    func deselectAllCategories(){
        for row in 0..<viewModel.categories.count{
            filterTV.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
            viewModel.categories[row].isSelected = false
        }
    }
    
    func selectAllSizes(){
        for row in 0..<viewModel.sizes.count{
            filterTV.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .middle)
            viewModel.selectedSizes.append(viewModel.sizes[row])
            viewModel.sizes[row].isSelected = true
        }
        viewModel.selectedSizes.removeAll(where: {$0.name == "Select All".localized})
        viewModel.selectedSizes = viewModel.selectedSizes.uniqued()
    }
    
    func deselectAllSizes(){
        for row in 0..<viewModel.sizes.count{
            filterTV.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
            viewModel.sizes[row].isSelected = false
        }
    }
    
    func selectAllColors(){
        for row in 0..<viewModel.colors.count{
            filterTV.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .middle)
            viewModel.selectedColors.append(viewModel.colors[row])
            viewModel.colors[row].isSelected = true
        }
        viewModel.selectedColors.removeAll(where: {$0.name == "Select All".localized})
        viewModel.selectedColors = viewModel.selectedColors.uniqued()
    }
    
    func deselectAllColors(){
        for row in 0..<viewModel.colors.count{
            filterTV.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
            viewModel.colors[row].isSelected = false
        }
    }
    
    func setupIfColorSelected(){
        type = .Color
        filterTV.reloadData()
        searchView.isHidden = true
        priceView.isHidden = true
        viewTV.isHidden = false
    }
    
    func setupIfSizeSelected(){
        type = .Size
        filterTV.reloadData()
        searchView.isHidden = true
        priceView.isHidden = true
        viewTV.isHidden = false
    }
    
    func setupIfPriceSelected() {
        viewTV.isHidden = true
        searchView.isHidden = true
        priceView.isHidden = false
    }
}

extension FilterVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == filterTypesTV {
            return viewModel.stings.count
        } else {
            switch type {
            case .Category:
                if isSearchActive == 1 {
                    return viewModel.searchResults.count
                } else {
                    return viewModel.categories.count
                }
            case .Size:
                return viewModel.sizes.count
            case .Color:
                return viewModel.colors.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == filterTypesTV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTypesCellTV", for: indexPath) as! FilterTypesCellTV
            cell.typeLB.text = viewModel.stings[indexPath.row]
            return cell
        } else {
            switch type {
            case .Category:
                let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCellTV.identifier, for: indexPath) as! CategoryCellTV
                var model: Category?
                if isSearchActive == 1 {
                    model = viewModel.searchResults[indexPath.row]
                } else {
                    model = viewModel.categories[indexPath.row]
                }
                if indexPath.row == 0 {
                    cell.productCountLB.isHidden = true
                } else {
                    cell.productCountLB.isHidden = false
                }
                cell.config(with: model!)
                return cell
            case .Size:
                let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCellTV.identifier, for: indexPath) as! CategoryCellTV
                let model = viewModel.sizes[indexPath.row]
                if indexPath.row == 0 {
                    cell.productCountLB.isHidden = true
                } else {
                    cell.productCountLB.isHidden = false
                }
                cell.config(with: model)
                return cell
            case .Color:
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorCellTV.identifier, for: indexPath) as! ColorCellTV
                let model = viewModel.colors[indexPath.row]
                cell.cellIndex = indexPath.row
                if indexPath.row == 0 {
                    cell.productCount.isHidden = true
                } else {
                    cell.productCount.isHidden = false
                }
                cell.config(with: model)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == filterTypesTV {
            if vcCase == .CategoryFilter {
                switch indexPath.row {
                case 0:
                    setupIfColorSelected()
                case 1:
                    setupIfSizeSelected()
                case 2:
                    setupIfPriceSelected()
                default:
                    print("error")
                }
            } else {
                switch indexPath.row {
                case 0:
                    type = .Category
                    filterTV.reloadData()
                    priceView.isHidden = true
                    viewTV.isHidden = false
                    searchView.isHidden = false
                case 1:
                    setupIfColorSelected()
                case 2:
                    setupIfSizeSelected()
                case 3:
                    setupIfPriceSelected()
                default:
                    print("error")
                }
            }
            setupSelected()
        } else {
            selectedFiltersLB.isHidden = false
            switch type {
            case .Category:
                if isSearchActive == 1 {
                    viewModel.selectedCategories.append(viewModel.searchResults[indexPath.row])
                    viewModel.searchResults[indexPath.row].isSelected = true
                } else {
                    if indexPath.row == 0 {
                        selectAllCategories()
                    } else {
                        viewModel.selectedCategories.append(viewModel.categories[indexPath.row])
                        viewModel.categories[indexPath.row].isSelected = true
                    }
                }
            case .Size:
                if indexPath.row == 0 {
                    selectAllSizes()
                } else {
                    viewModel.selectedSizes.append(viewModel.sizes[indexPath.row])
                    viewModel.sizes[indexPath.row].isSelected = true
                    filterResultCount += viewModel.sizes[indexPath.row].productsCount.zeroIfNull
                    print("FilterResultCount: \(filterResultCount)")
                }
            case .Color:
                if indexPath.row == 0 {
                    selectAllColors()
                } else {
                    viewModel.selectedColors.append(viewModel.colors[indexPath.row])
                    viewModel.colors[indexPath.row].isSelected = true
                }
            }
            setupLabel()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == filterTV {
            switch type {
            case .Category:
                if isSearchActive == 1 {
                    viewModel.selectedCategories.removeAll {$0.name == viewModel.searchResults[indexPath.row].name.emptyIfNull}
                    viewModel.searchResults[indexPath.row].isSelected = false
                } else {
                    if indexPath.row == 0 {
                        viewModel.selectedCategories.removeAll()
                        deselectAllCategories()
                    } else {
                        viewModel.selectedCategories.removeAll {$0.name == viewModel.categories[indexPath.row].name.emptyIfNull}
                        viewModel.categories[0].isSelected = false
                        filterTV.deselectRow(at: IndexPath(row: 0, section: 0), animated: true)
                        viewModel.categories[indexPath.row].isSelected = false
                    }
                }
            case .Size:
                if indexPath.row == 0 {
                    viewModel.selectedSizes.removeAll()
                    deselectAllSizes()
                } else {
                    viewModel.selectedSizes.removeAll {$0.name == viewModel.sizes[indexPath.row].name.emptyIfNull}
                    viewModel.sizes[0].isSelected = false
                    filterTV.deselectRow(at: IndexPath(row: 0, section: 0), animated: true)
                    viewModel.sizes[indexPath.row].isSelected = false
                }
            case .Color:
                if indexPath.row == 0 {
                    viewModel.selectedColors.removeAll()
                    deselectAllColors()
                } else {
                    viewModel.selectedColors.removeAll {$0.name == viewModel.colors[indexPath.row].name.emptyIfNull}
                    viewModel.colors[0].isSelected = false
                    filterTV.deselectRow(at: IndexPath(row: 0, section: 0), animated: true)
                    viewModel.colors[indexPath.row].isSelected = false
                }
            }
            setupLabel()
        }
    }
}

enum FilterType {
    case Category
    case Color
    case Size
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

enum FilterCases{
    case HomeFilter
    case DesignerFilter
    case CategoryFilter
}
