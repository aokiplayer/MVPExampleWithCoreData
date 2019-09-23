import Foundation

protocol ProductListPresenterInput {
    var numberOfProducts: Int { get }
    func loadProducts()
    func product(forRow: Int) -> Product?
    func didTapRegisterAction(name: String, price: Int)
}

protocol ProductListPresenterOutput: AnyObject {
    func upadteProducts()
}

final class ProductListPresenter: ProductListPresenterInput {
    private(set) var products: [Product] = []

    private weak var view: ProductListPresenterOutput!
    private(set) var model: ProductListModelInput

    init(view: ProductListPresenterOutput, model: ProductListModelInput) {
        self.view = view
        self.model = model
    }

    var numberOfProducts: Int {
        products.count
    }

    func loadProducts() {
        model.fetchAllProducts { [weak self] products in
            self?.products = products ?? []
            self?.view.upadteProducts()
        }
    }

    func product(forRow row: Int) -> Product? {
        guard row < products.count else { return nil }
        return products[row]
    }

    func didTapRegisterAction(name: String, price: Int) {
//        let product = Product()
//        product.name = name       // ここでセレクタがないって言われる
//        product.price = Int64(price)

        model.registerProduct(name: name, price: price)
        model.fetchAllProducts { [weak self] products in
            self?.products = products ?? []
            self?.view.upadteProducts()
        }
    }
}
