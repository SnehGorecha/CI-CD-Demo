//
//  SignUpVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 31/10/23.
//

import UIKit
import FirebaseMessaging
//import UniformTypeIdentifiers

@available(iOS 16.0, *)
class SignUpVC: BaseViewController {
    
    
    // MARK: - OBJECTS & OUTLETS
    var is_for_login = false
    var is_gdpr_agreed = false
    var sign_up_view_model = SignUpViewModel()
    var country_code = Country.getCurrentCountry()?.dialCode
    var country_iso_code = Country.getCurrentCountry()?.code
    
//    @IBOutlet weak var lbl_unique_identifier: AFLabelRegular!
    @IBOutlet weak var view_country_code: UIView!
    @IBOutlet weak var img_country: UIImageView!
    @IBOutlet weak var btn_country_code: UIButton!
    @IBOutlet weak var lbl_title: AFLabelBold!
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var lbl_description: AFLabelRegular!
//    @IBOutlet weak var lbl_mobile_number_title: AFLabelRegular!
    @IBOutlet weak var txt_mobile_number: BaseTextfield!
    @IBOutlet weak var btn_send_otp: BaseBoldButton!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
//        let pasteControl = UIPasteControl()
//        pasteControl.translatesAutoresizingMaskIntoConstraints = false
//        self.pasteView.addSubview(pasteControl)
//        // Set acceptable paste configuration for text
//               pasteControl.pasteConfiguration = UIPasteConfiguration(forAccepting: String.self)
//
//               // Add constraints to the paste control
//               NSLayoutConstraint.activate([
//                   pasteControl.centerXAnchor.constraint(equalTo: self.pasteView.centerXAnchor),
//                   pasteControl.centerYAnchor.constraint(equalTo: self.pasteView.centerYAnchor),
//                   pasteControl.widthAnchor.constraint(equalToConstant: 150),
//                   pasteControl.heightAnchor.constraint(equalToConstant: 50)
//               ])
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        
        self.navigation_bar.navigationBarSetup(isWithBackOption: true,
                                               isWithRightOption: false,
                                               isWithQROption: false)
        
        let onboarding_vc = self.getController(from: .onboarding, controller: .onboarding_vc(scroll_to_at: 0)) as! OnboardingVC
        onboarding_vc.scroll_to_at = onboarding_vc.arr_button_titles.count
        self.navigationController?.setViewControllers([onboarding_vc, self], animated: true)
        
        self.localTextSetup()
        
        self.txt_mobile_number.setupUI()
        
        self.view_country_code.setupLayer(borderColor: .clear, borderWidth: 1, cornerRadius: 14)
        self.view_country_code.backgroundColor = AppColor.light_gray()
        self.lbl_description.textColor = AppColor.text_grey_color()
        self.view.backgroundColor = .white
        
        self.btn_send_otp.setStyle()
        self.btn_country_code.tintColor = .black
        self.img_country.clipsToBounds = true
        self.lbl_description.isHidden = self.is_for_login
//        self.lbl_mobile_number_title.isHidden = true
        
        
        if let current_country = Country.getCurrentCountry() {
            self.btn_country_code.setTitle("\(current_country.flag)  \(current_country.dialCode ?? "")", for: .normal)
        }
    }
    
    func localTextSetup() {
        self.lbl_title.text = is_for_login ? LocalText.BioMetricAuthentication().login() : LocalText.SignUpScreen().sign_up()
        self.lbl_description.text = LocalText.SignUpScreen().select_mobile_number_and_continue()
//        self.lbl_mobile_number_title.text = LocalText.SignUpScreen().mobile_number()
        self.txt_mobile_number.placeholder = LocalText.SignUpScreen().select_mobile_number()
        self.txt_mobile_number.max_text_limit = 15
        self.btn_send_otp.setTitle(LocalText.SignUpScreen().send_otp(), for: .normal)
    }
    
    
    // MARK: - API CALL
    
    func signupApiCall() {
        let signup_request_model = SignupRequestModel(country_code: self.country_code?.removePlusFromBegin() ?? "91",
                                                      mobile_number: self.txt_mobile_number.text ?? "",
                                                      device_id: GlobalVariables.shared.device_id,
                                                      device_token: GlobalVariables.shared.fcm_token)
        
        let validation = self.sign_up_view_model.validateSignup(requestModel: signup_request_model)
        
        if validation.is_success {
            
            self.sign_up_view_model.sendOtpApiCall(signup_request_model:signup_request_model,
                                                   is_for_login: self.is_for_login,
                                                   view_for_progress_indicator: self.view)
            { is_success, model  in
                
                if is_success {
                    
                    UtilityManager().showToast(message: model?.message ?? "")
                    self.navigateTo(.signup_otp_vc(country_code: self.country_code ?? "+91",
                                                   country_iso_code: self.country_iso_code ?? "",
                                                   mobile_number: self.txt_mobile_number.text ?? ""))
                    
                } else if model?.message == Message.unregistered_user_need_to_signup_first() || model?.message == Message.an_account_already_exists() {
                    
                    UtilityManager().showToast(message: model?.message ?? "")
                    
                } else {
                    self.showPopupAlert(title: AppInfo.app_name,
                                        message: model?.message ?? "",
                                        leftTitle: nil,
                                        rightTitle: LocalText.AlertButton().ok(),
                                        close_button_hidden: true,
                                        didPressedLeftButton: nil,
                                        didPressedRightButton: nil)
                }
            }
            
        } else {
            UtilityManager().showToast(message: validation.str_error_message ?? "")
        }
    }
    
    
    // MARK: - BUTTON'S ACTIONS
    
    @IBAction func btnCountryCodePressed(_ sender: UIButton) {
                
        let controller = DialCountriesController(locale: Locale(identifier: Locale.current.identifier))
        controller.delegate = self
        
        DispatchQueue.main.async {
            controller.show(vc: self)
        }
        
    }
    
    @IBAction func btnSendOtpPressed(_ sender: UIButton) {
//        print("Paste : \n",UIPasteboard.general.string ?? "")
        // GENERATE FCM TOEKN IF REQUIRED
        if GlobalVariables.shared.fcm_token == "" {
            Messaging.messaging().token { token, error in
                if let error = error {
                    UtilityManager().showToast(message:  "\(error.localizedDescription)")
                    
                } else if let token = token {
                    print("\nFCM TOKEN from didRegisterForRemoteNotifications : \(token)\n")
                    GlobalVariables.shared.fcm_token = token
                    self.signupApiCall()
                }
            }
        } else {
            self.signupApiCall()
        }
    }
}


// MARK: - EXTENSION COUNTRY CODE
@available(iOS 16.0, *)
extension SignUpVC : DialCountriesControllerDelegate {
    
    func didSelected(with country: Country) {
        DispatchQueue.main.async {
            self.btn_country_code.setTitle("\(country.flag)  \(country.dialCode ?? "")", for: .normal)
            self.country_code = country.dialCode
            self.country_iso_code = country.code
        }
    }
}


@available(iOS 16.0, *)
extension SignUpVC {
    override func paste(itemProviders: [NSItemProvider]) {
            for item in itemProviders {
                if item.canLoadObject(ofClass: String.self) {
                    item.loadObject(ofClass: String.self) { [weak self] (pastedText, error) in
                        guard let self = self, let text = pastedText as? String, error == nil else {
                            return
                        }
                        DispatchQueue.main.async {
                            print("Pasted Text: \(text)")
                        }
                    }
                }
            }
        }
}
