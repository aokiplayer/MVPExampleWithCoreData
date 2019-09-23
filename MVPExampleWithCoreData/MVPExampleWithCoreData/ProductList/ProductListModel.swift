import Foundation
import CoreData

protocol ProductListModelInput {
    func fetchAllProducts(completion: @escaping ([Product]?) -> ())
    func registerProduct(name: String, price: Int)
}

final class ProductListModel: ProductListModelInput {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func fetchAllProducts(completion: @escaping ([Product]?) -> ()) {
        let moc = coreDataStack.persistentContainer.viewContext

        let request = NSFetchRequest<Product>(entityName: "Product")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Product.createdAt, ascending: true)
        ]

        if let products = try? moc.fetch(request) {
            completion(products)
        } else {
            completion(nil)
        }
    }

    func registerProduct(name: String, price: Int) {
        let moc = coreDataStack.persistentContainer.viewContext
        let product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: moc) as! Product
        product.name = name
        product.price = Int64(price)

        coreDataStack.saveContext()
    }
}
