import UIKit

class ProductCell: UITableViewCell {
    private(set) static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    func configure(product: Product) {
        productLabel.text = "\(product.name!) (\(product.price)円)"
        dateLabel.text = ProductCell.dateFormatter.string(from: product.createdAt!)
    }
}
