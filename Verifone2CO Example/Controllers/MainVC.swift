//
//  ViewController.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 03.01.2023.
//

import UIKit
import Verifone2CO

class MainVC: UIViewController {

    // MARK: - PROPERTIES
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var productImageView: ImageLoaderView!
    private var buttonConstraints = [NSLayoutConstraint]()

    var viewModel = MainViewModel()
    var verifon2coTheme: Verifone2CO.Theme = .defaultTheme
    private var currency: String = "USD" {
        didSet {
            guard let price = price else { return }
            self.payButton.setTitle("Pay \(price) \(currency)", for: .normal)
        }
    }
    private var price: Double! {
        didSet {
            self.payButton.setTitle("Pay \(price!) \(currency)", for: .normal)
        }
    }
    private var product: Product!
    private var isPaymentInProgress: Bool = false {
        didSet {
            self.payButton.startAnimating(isPaymentInProgress, originalConstraints: self.buttonConstraints)
        }
    }
    private(set) var missingParams: String = "Missing required parameters for"
    var orderResponseTest: OrderResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        getProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Product Details"
        if self.buttonConstraints.isEmpty {
            self.buttonConstraints = self.payButton.constraints
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchSettingsBundleParams), name: UserDefaultsChangeNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func fetchSettingsBundleParams() {
        if let (_, err) = self.viewModel.isTestModeParamsOk(),
            err != nil && err == AppError.testModeEnabledUrlInvalid {
            self.alert(title: "You have enabled test mode, but the URL is incorrect")
        }
    }

    // CONFIGURE NAV BAR BUTTONS
    private func configureNavigation() {
        payButton.layer.cornerRadius = 6
        let currencyButton = UIBarButtonItem(
            image: UIImage(named: "ic_currency"),
            style: .plain, target: self,
            action: #selector(changeCurrency))
        let settingsButton = UIBarButtonItem(
            image: UIImage(named: "ic_setting"),
            style: .plain, target: self,
            action: #selector(gotoSettings))
        self.navigationItem.leftBarButtonItems = [currencyButton]
        self.navigationItem.rightBarButtonItems = [settingsButton]
    }

    // PRESENT CURRENCY LIST
    @objc func changeCurrency() {
        let currencyListVC = DropDownVC(items: MerchantAppConfig.shared.currencies, dropDownType: .currency)
        currencyListVC.selectedItem = {[weak self] currency in
            self?.currency = currency
        }
        present(currencyListVC, animated: true, completion: nil)
    }

    // OPEN SETTING PAGE
    @objc func gotoSettings() {
        let vc = SettingsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // FETCH LOCAL PRODUCTS
    private func getProducts() {
        showLoadingView()
        self.currency = viewModel.currency
        viewModel.getRandomProduct { [weak self] product, _ in
            self!.setProduct(product: product)
            self!.dismissLoadingView()
        }
    }

    private func setProduct(product: Product?) {
        guard let product = product else {
            return
        }
        let price = Double(String(format: "%.2f", product.price/100))!
        self.product = product
        self.product.price = price
        self.price = price
        self.titleLabel.fadeTransition(0.4)
        self.titleLabel.text = product.title
        self.descriptionLabel.fadeTransition(0.2)
        self.descriptionLabel.text = product.productDescription
        self.payButton!.titleLabel!.fadeTransition(0.4)
        self.payButton.setTitle("Pay \(self.product.price) \(self.currency)", for: .normal)
        self.productImageView.downloadImage(from: MerchantAppConfig.shared.randomImageUrl)
    }
    
    @IBAction func payPressed(_ sender: UIButton) {
        self.payButton.startAnimating(originalConstraints: sender.constraints)
        presentPaymentForm()
    }

    @IBAction func reloadProduct(_ sender: Any) {
        getProducts()
    }

    // MARK: PRESENT PAYMENT FORM
    private func presentPaymentForm() {
        configureCardFormColors()
        let allowedPaymentOptions = MerchantAppConfig.shared.allowedPaymentOptions
        if allowedPaymentOptions.isEmpty {
            self.alert(title: "No payment methods are enabled")
            self.payButton.startAnimating(false, originalConstraints: self.buttonConstraints)
            return
        }
        let paymentConfiguration: Verifone2CO.PaymentConfiguration = Verifone2CO.PaymentConfiguration(
            delegate: self,
            merchantCode: Parameters.creditCard?.merchantCode ?? "",
            paymentPanelStoreTitle: "Store",
            totalAmount: "\(price!) \(currency)",
            allowedPaymentMethods: allowedPaymentOptions,
            showCardSaveSwitch: MerchantAppConfig.shared.showCardSaveButton,
            theme: verifon2coTheme)
        Verifone2CO.locale = MerchantAppConfig.shared.getLang()
        Verifone2COPaymentForm.present(with: paymentConfiguration, from: self)
    }
}

extension MainVC: VF2COAuthorizePaymentControllerDelegate {
    func authorizePaymentViewController(didCompleteAuthorizing result: PaymentAuthorizingResult) {
        guard let refNo = result.queryStringDictionary?["REFNO".lowercased()] as? String else { return }
        getOrder(refNo: refNo, paymentMethod: .paypal)
    }

    func authorizePaymentViewControllerDidCancel() {
        handleResult(responseItem: nil, error: AppError.canceledError("Payment canceled"))
    }
}

// MARK: - PAYMENT FLOW DELEGATES
extension MainVC: PaymentFlowSessionDelegate {
    func paymentFormComplete(_ result: Result<PaymentFormResult, Error>) {
        switch result {
        case .success(let result):
            /// result.isCardSaveOn: String
            /// result.token: String
            /// result.cardHolder: String?
            self.placeOrder(paymentMethod: result.paymentMethod, cardHolder: result.cardHolder, token: result.token)
        case .failure(let error):
            isPaymentInProgress = false
            /// SHOW RELEVANT ERROR PAGE OR ALERT
            if case Verifone2CoError.requiredParams = error {
                self.alert(title: "\(missingParams) credit card")
            } else {
                self.handleResult(responseItem: nil, error: error)
            }
        }
    }

    func paymentFormWillShow() {
        print("paymentFormWillShow")
    }

    func paymentFormWillClose() {
        print("paymentFormWillClose")
        if !isPaymentInProgress {
            self.payButton.startAnimating(false, originalConstraints: self.buttonConstraints)
        }
    }

    func paymentMethodSelected(_ paymentMethod: PaymentMethodType) {
        print("Payment Method Selected \(paymentMethod)")
    }

    // MARK: - PLACE 2CO ORDER
    private func placeOrder(paymentMethod: AppPaymentMethodType, cardHolder: String?, token: String?) {
        isPaymentInProgress = true
        var orderData = OrderData.creditCard
        guard Parameters.creditCard != nil else {
            self.alert(title: "Missing required parameters for create order")
            isPaymentInProgress = false
            return
        }
        switch paymentMethod {
        case .creditCard:
            orderData.setupCreditCard(with: token!,
                                      paymentDetailsType: UserDefaults.standard.string(forKey: Keys.paymentDetailsType) ?? Keys.paymentDetailsType,
                                      product: self.product,
                                      currency: self.currency, cardHolder: cardHolder)
        case .paypal:
            orderData.setupPaypal(product: self.product, currency: self.currency)
        }
        self.placeOrderNetworkCall(with: orderData, paymentMethod: paymentMethod)
    }

    // MARK: - PLACE ORDER NETWORK CALL
    private func placeOrderNetworkCall(with orderData: OrderData, paymentMethod: AppPaymentMethodType) {
        viewModel.createOrder(orderData: orderData) { [weak self] orderResponse, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if error != nil { self.handleResult(responseItem: nil, error: error); return }
                switch paymentMethod {
                case .creditCard:
                    if let paymentDetails = orderResponse?.paymentDetails, paymentDetails.paymentMethod != nil && paymentDetails.paymentMethod?.authorize3DS != nil {
                        Verifone2COPaymentForm.authorizePayment(webConfig: self.viewModel.get3DSWebConfig(paymentDetails: paymentDetails),
                                                                delegate: self, from: self)
                        return
                    }
                case .paypal:
                    if let paymentDetails = orderResponse?.paymentDetails, paymentDetails.paymentMethod != nil && paymentDetails.paymentMethod?.redirectURL != nil {
                        Verifone2COPaymentForm.authorizePayment(webConfig: self.viewModel.getPaypalAuthWebConfig(paymentDetails: paymentDetails),
                                                                delegate: self, from: self)
                        return
                    }
                }
                self.handleResult(responseItem: orderResponse, error: error)
            }
        }
    }

    // MARK: - GET ORDER BY REF NUMBER
    private func getOrder(refNo: String, paymentMethod: AppPaymentMethodType) {
        viewModel.getOrder(refNo: refNo, paymentMethod: paymentMethod) { [weak self] orderResponse, error in
            guard let self = self else { return }
            if error != nil { self.handleResult(responseItem: nil, error: error); return }
            DispatchQueue.main.async {
                if orderResponse?.status == "PENDING" {
                    self.handleResult(responseItem: nil, error: AppError.invalidResponse("The order status is \(orderResponse!.status!)"))
                } else {
                    self.handleResult(responseItem: orderResponse, error: nil)
                }
            }
        }
    }

    // MARK: - HANDLE PAYMENT FORM RESULT
    private func handleResult(responseItem: Any?, error: Error?) {
        self.isPaymentInProgress = false
        showResultPage(item: viewModel.getResultSection(responseItem: responseItem, error: error, currency: currency, price: price!))
    }

    // MARK: - SHOW RESULT PAGE
    func showResultPage(item: ResultSection) {
        let resultVC = ResultVC()
        resultVC.items = [item]
        self.present(resultVC, animated: true)
    }
}
