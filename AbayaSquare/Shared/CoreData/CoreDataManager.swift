import Foundation
import CoreData

class CoreDataManager:NSObject {
    
    class func getContext () -> NSManagedObjectContext {
        return CoreDataStack.persistentContainer.viewContext
    }
    
    class func save() {
        do {
            try getContext().save()
        } catch {
            print(error)
        }
    }
    
    class func emptyBasket() {
        let prodcuts = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductEntity")
        let emptyProdcutsReq = NSBatchDeleteRequest(fetchRequest: prodcuts)
        
        do {
            try getContext().execute(emptyProdcutsReq)
        } catch {
            
        }
    }
    
    class func getTotalCount() -> Int {
        return getProdcuts().count
    }
    
    //MARK: ProductEntity:
    class func insert(prodcut: Product, quantity: Int, size: Size) {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = \(prodcut.id)")
        var products: [ProductEntity] = []
        
        do {
            products = try getContext().fetch(fetchRequest) as [ProductEntity]
        } catch {
            print("Error with request: \(error)")
        }
        
        for oldProduct in products {
            if oldProduct.sizeId == size.sizeId.zeroIfNull.int16 {
                oldProduct.quantity += quantity.int16
                save()
                return
            }
        }
        
        let newProdcut = NSEntityDescription.insertNewObject(forEntityName: "ProductEntity", into: getContext()) as! ProductEntity
        newProdcut.id = prodcut.id.int16
        newProdcut.name = prodcut.name
        newProdcut.price = prodcut.price.zeroIfNull
        newProdcut.image = prodcut.mainImage
        newProdcut.sizeId = size.sizeId.zeroIfNull.int16
        newProdcut.sizeName = size.size
        newProdcut.quantity = quantity.int16
        newProdcut.availableQuantity = size.qty.zeroIfNull.int16
        newProdcut.inFavorite = prodcut.inFavorite.falseIfNull
        newProdcut.designerName = prodcut.designer?.name
        newProdcut.discountRatio = prodcut.discountRatio.zeroIfNull
        newProdcut.discountPrice = prodcut.salePrice.zeroIfNull
        newProdcut.designerId = prodcut.designer?.id.int16 ?? 0
        newProdcut.cod = prodcut.cod?.int16 ?? 0
        save()
        print(newProdcut)
    }
    
    class func insert(prodcut: Product,quantity: Int,size: Size, disount: Double) {
        
    }
    
    class func updateProduct(designerId: Int16,
                             couponId: Int16,
                             couponRatio: Double,
                             couponCode: String) {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "designerId =\(designerId)")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try getContext().fetch(fetchRequest)
            for result in results {
                if result.couponRatio == 0 {
                    let couponRatio = couponRatio / 100
                    let discount = (result.discountPrice) * (couponRatio)
                    let productPrice = result.discountPrice - discount
                    let objectUpdate = result
                    objectUpdate.setValue(result.discountPrice, forKey: "price")
                    objectUpdate.setValue(couponId, forKey: "couponId")
                    objectUpdate.setValue(couponRatio, forKey: "couponRatio")
                    objectUpdate.setValue(couponCode, forKey: "couponCode")
                    objectUpdate.setValue(productPrice, forKey: "couponPrice")
                    objectUpdate.setValue(discount, forKey: "couponDiscount")
                    do {
                        try getContext().save()
                        print("update product couponCode \(objectUpdate)")
                    }catch let error as NSError {
                        print("error \(error)")
                    }
                }
            }
        } catch let error as NSError {
            print("error \(error)")
        }
        
    }
    
    class func getProdcuts() -> [ProductEntity] {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        do {
            return try getContext().fetch(fetchRequest) as [ProductEntity]
        } catch {
            print("Error with request: \(error)")
        }
        return []
    }
    
    class func deleteProdcut(_ prodcut: ProductEntity) {
        getContext().delete(prodcut)
        save()
    }
    
    class func increaseQuantity(_ product: ProductEntity) {
        product.quantity += 1
        save()
    }
    
    class func decreaseQuantity(_ product: ProductEntity) {
        product.quantity -= 1
        save()
    }
    
    class func getProductsTotalPrice() -> Double {
        var totalPrice = 0.0
        for product in getProdcuts() {
            if product.couponRatio == 0 {
                totalPrice += (product.discountPrice * Double(product.quantity))
            } else {
                totalPrice += (product.couponPrice * Double(product.quantity))
            }
            
        }
        
        return totalPrice
    }
    
    class func getProductsTotalPriceWithoutDiscount() -> Double {
        var totalPrice = 0.0
        for product in getProdcuts() {
            totalPrice += (product.discountPrice * Double(product.quantity))
        }
        return totalPrice
    }
    
    class func getTotalPriceWithDiscount() -> Double {
        var totalPrice = 0.0
        for product in getProdcuts() {
            let discount = product.couponRatio / 100
            if product.discountRatio == 0 {
                totalPrice += (product.price * Double(product.quantity)) * discount
            } else {
                totalPrice += (product.discountPrice * Double(product.quantity)) * discount
            }
        }
        return totalPrice
    }
    
    class func checkProductExists(id: Int, sizeId: Int) -> Bool {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id = \(id) and sizeId = \(sizeId)")
        do {
            let count = try getContext().count(for: fetchRequest)
            if count > 0 {
                return true
            }else {
                return false
            }
        }catch let error as NSError {
            print("Could not fetch. \(error)")
            return false
        }
    }
    
    class func getDesigners() -> [Int16] {
        return getProdcuts().map {$0.designerId}
    }
    
    class func getDiscountTotal() -> Double {
        var totalDiscount = 0.0
        getProdcuts().forEach {
            if $0.couponRatio != 0 {
                totalDiscount += ($0.couponDiscount * Double($0.quantity))
            }
        }
        return totalDiscount
    }
    
    class func getProductsIds() -> [Int16] {
        return getProdcuts().map {$0.id}
    }
    
    class func updateProducts(product: Product){
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id =\(product.id)")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try getContext().fetch(fetchRequest)
            let productToUpdate = results[0]
            if productToUpdate.couponRatio == 0 {
                productToUpdate.setValue(product.name, forKey: "name")
                productToUpdate.setValue(product.price, forKey: "price")
                productToUpdate.setValue(product.discountRatio, forKey: "discountRatio")
                productToUpdate.setValue(product.salePrice, forKey: "discountPrice")
            }
            do {
                try getContext().save()
                print("update product couponCode \(productToUpdate)")
            }catch let error as NSError {
                print("error \(error)")
            }
            
        } catch let error as NSError {
            print("error \(error)")
        }
    }
    
    class func isQuantityAvailable(product: Size, quantityToAdd: Int) -> Bool {
        if let previousProduct = getProduct(id: product.sizeId.zeroIfNull) {
            return (previousProduct.availableQuantity + quantityToAdd.int16) <= product.qty.zeroIfNull
        }
        
        return product.qty.zeroIfNull >= quantityToAdd
    }
    
    class func isQuantityAvailable(product: ProductEntity, quantityToAdd: Int = 1) -> Bool {
        return product.availableQuantity >= product.quantity + quantityToAdd.int16
    }
    
    class func getProduct(id: Int) -> ProductEntity? {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "sizeId = \(id)")
        var products: [ProductEntity] = []
        
        do {
            products = try getContext().fetch(fetchRequest) as [ProductEntity]
        } catch {
            print("Error with request: \(error)")
        }
        return products.first
    }
    
    class func isSameDesigner(designerId: Int) -> Bool {
        var result: Bool?
        getProdcuts().forEach {result = $0.designerId == designerId}
        return result.falseIfNull
    }
    
    //MARK: Coupon Entity:
    
    class func insert(coupon: Int16){
        let newCoupon = NSEntityDescription.insertNewObject(forEntityName: "CouponEntity", into: getContext()) as! CouponEntity
        newCoupon.couponId = coupon
        save()
        print(newCoupon)
    }
    
    class func isCouponIsUsedBefore(couponId: Int) -> Bool{
        let fetchRequest: NSFetchRequest<CouponEntity> = CouponEntity.fetchRequest()
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "couponId = \(couponId)")
        do {
            let count = try getContext().count(for: fetchRequest)
            if count > 0 {
                return true
            }else {
                return false
            }
        }catch let error as NSError {
            print("Could not fetch. \(error)")
            return false
        }
    }
    
    class func getAllCoupons() -> [CouponEntity]{
        let fetchRequest: NSFetchRequest<CouponEntity> = CouponEntity.fetchRequest()
        do {
            return try getContext().fetch(fetchRequest) as [CouponEntity]
        } catch {
            print("Error with request: \(error)")
        }
        return []
    }
    
    //MARK: Discount Entity:
    class func insert(coupon: Offer){
        
        let fetchRequest: NSFetchRequest<DiscountEntity> = DiscountEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "couponId = \(coupon.id)")
        var coupons: [DiscountEntity] = []
        
        do {
            coupons = try getContext().fetch(fetchRequest) as [DiscountEntity]
        } catch {
            print("Error with request: \(error)")
        }
        for oldCoupons in coupons {
            if oldCoupons.couponId == coupon.id {
                return
            }
        }
        let newCoupon = NSEntityDescription.insertNewObject(forEntityName: "DiscountEntity", into: getContext()) as! DiscountEntity
        newCoupon.designerId = coupon.designer?.id.int16 ?? 0
        newCoupon.couponId = coupon.id.int16
        newCoupon.couponCode = coupon.code
        newCoupon.couponRatio = coupon.discountRatio ?? 0
        save()
    }
    
    class func getCouponDetails(designerId: Int) -> DiscountEntity? {
        let fetchRequest: NSFetchRequest<DiscountEntity> = DiscountEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "designerId = \(designerId)")
        var coupons: [DiscountEntity] = []
        do {
            coupons = try getContext().fetch(fetchRequest) as [DiscountEntity]
        } catch {
            print("Error with request: \(error)")
        }
        return coupons.first
    }
    
    class func deleteAllCoupons(){
        let prodcuts = NSFetchRequest<NSFetchRequestResult>(entityName: "DiscountEntity")
        let emptyProdcutsReq = NSBatchDeleteRequest(fetchRequest: prodcuts)
        
        do {
            try getContext().execute(emptyProdcutsReq)
        } catch {
            
        }
    }
}
