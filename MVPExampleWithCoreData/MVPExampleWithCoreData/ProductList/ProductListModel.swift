import Foundation
import CoreData

protocol ProductListModelInput {
    func fetchAllProducts(completion: @escaping ([Product]?) -> ())
    func registerProduct(name: String, price: Int)
}

final class ProductListModel: ProductListModelInput {
    private let moContext: NSManagedObjectContext

    init(moContext: NSManagedObjectContext) {
        self.moContext = moContext
    }

    func fetchAllProducts(completion: @escaping ([Product]?) -> ()) {
        let request = NSFetchRequest<Product>(entityName: "Product")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Product.createdAt, ascending: true)
        ]

        if let products = try? moContext.fetch(request) {
            completion(products)
        } else {
            completion(nil)
        }
    }

    func registerProduct(name: String, price: Int) {
        let product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: moContext) as! Product
        product.name = name
        product.price = Int64(price)

        if moContext.hasChanges {
            do {
                try moContext.save()
            } catch let error as NSError {
                print("Core Data Error: \(error), \(error.userInfo)")
            }
        }
    }
}
