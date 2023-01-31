//
//  CategorieViewModel.swift
//  AbayaSquare
//
//  Created by Ayman  on 6/3/21.
//

import Foundation

protocol CategoriesDataSource {
    var category: Category? {get set}
}

class CategorieViewModel: CategoriesDataSource {
    
    var categories: [Category] = []
    var category: Category?
    
    func getCategories(onComplete: @escaping onComplete<CategoryModel.Response>){
        API.shared.startAPI(endPoint: .getCategories, req: CategoryModel.Request(), onComplete: onComplete)
    }
}

enum CategoryModel {
    struct Request: Codable {
    }
    
    struct Response: GenericResponse {
        var status: Bool?
        var responseMessage: String?
        var errors: [ResponseError]?
        let categories: [Category]? 
    }
}

struct Category:Codable,Hashable {
    var id: Int
    var name: String?
    var isSelected: Bool? = false
    var productsCount: Int?
    var imageUrl: String?
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(id: Int,name: String) {
        self.id = id
        self.name = name
    }
    
}
