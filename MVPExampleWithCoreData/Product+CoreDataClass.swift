import Foundation
import CoreData

@objc(Product)
public class Product: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()

        createdAt = Date()
    }
}
