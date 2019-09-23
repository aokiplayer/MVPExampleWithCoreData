import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private(set) var presenter: ProductListPresenterInput!
    func inject(presenter: ProductListPresenterInput) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")

        tableView.dataSource = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addBarButtonTapped))

        presenter.loadProducts()
    }

    @objc private func addBarButtonTapped() {
        let alert = UIAlertController(title: "新規登録",
                                      message: "商品の情報を入力してね",
                                      preferredStyle: .alert)
        let registerAction = UIAlertAction(
            title: "登録",
            style: .default) { [weak self] action in
                let name = alert.textFields![0].text!
                guard let price = Int(alert.textFields![1].text!) else { return }

                self?.presenter.didTapRegisterAction(name: name, price: price)
        }
        alert.addAction(registerAction)
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true, completion: nil)
    }
}

extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfProducts
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell

        if let product = presenter.product(forRow: indexPath.row) {
            cell.configure(product: product)
        }

        return cell
    }
}

extension ProductListViewController: ProductListPresenterOutput {
    func upadteProducts() {
        tableView.reloadData()
    }
}
