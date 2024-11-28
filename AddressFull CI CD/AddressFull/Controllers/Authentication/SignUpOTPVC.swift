//
//  SignUpOTPVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 31/10/23.
//

import UIKit


class SignUpOTPVC: BaseViewController {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    var has_entered_otp = false
    var country_code = ""
    var country_iso_code = ""
    var mobile_number = ""
    var otp = ""
    var sign_up_otp_view_model = SignUpOTPViewModel()
    var timer: Timer?
    var count_down_time: Int = 60
    var otp_resent_count = 0
    
    @IBOutlet weak var lbl_timer: AFLabelRegular!
    @IBOutlet weak var lbl_title: AFLabelBold!
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var lbl_description: AFLabelRegular!
    @IBOutlet weak var lbl_mobile_number: AFLabelBold!
    @IBOutlet weak var otp_view: OTPFieldView!
    @IBOutlet weak var btn_resend_otp: BasePoppinsRegularButton!
    @IBOutlet weak var btn_submit: BaseBoldButton!
    
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.navigation_bar.navigationBarSetup(isWithBackOption: true,
                                               isWithRightOption: false,
                                               isWithQROption: false)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        self.timer?.fire()
        
        self.view.backgroundColor = .white
        
        self.localTextSetup()
        self.otpBoxSetupUI()
        self.lbl_description.textColor = AppColor.text_grey_color()
        
        self.btn_submit.setStyle(withClearBackground: true)
        self.btn_submit.isEnabled = false
        
        if let otp_resent_count = UserDefaults.standard.value(forKey: UserDefaultsKey.otp_resent_count) as? Int {
            self.otp_resent_count = otp_resent_count
        }
        
    }
    
    func localTextSetup() {
        self.lbl_title.text = LocalText.SignUpOtp().sms_verification()
        self.lbl_description.text = LocalText.SignUpOtp().we_wanted_to_verify()
        self.lbl_mobile_number.text = LocalText.SignUpOtp().code()
        
        self.btn_resend_otp.setTitle(LocalText.SignUpOtp().resend_sms_verification_code(), for: .normal)
        self.btn_submit.setTitle(LocalText.SignUpOtp().verify(), for: .normal)
    }
    
    func otpBoxSetupUI() {
        self.otp_view.fieldsCount = ValaidationLength().otp
        self.otp_view.fieldFont = UIFont(name: AppFont.helvetica_bold, size: 18) ?? .systemFont(ofSize: 18)
        self.otp_view.fieldBorderWidth = 0
        self.otp_view.defaultBorderColor = .clear
        self.otp_view.filledBorderColor = .clear
        self.otp_view.cursorColor = .black
        self.otp_view.displayType = .roundedCorner
        self.otp_view.defaultBackgroundColor = AppColor.primary_gray()
        self.otp_view.filledBackgroundColor = AppColor.primary_gray()
        self.otp_view.fieldSize = self.otp_view.frame.size.height - 5
        self.otp_view.separatorSpace = 32
        self.otp_view.cornerRadius = 14
        self.otp_view.shouldAllowIntermediateEditing = false
        self.otp_view.delegate = self
        self.otp_view.initializeUI()
        self.otp_view.secureEntry = true
    }
    
    func updateButtonTitle() {
        let minutes = self.count_down_time / 60
        let seconds = self.count_down_time % 60
        let title = String(format: "%02d:%02d", minutes, seconds)
        DispatchQueue.main.async {
            self.lbl_timer.isHidden = false
            self.btn_resend_otp.setStyle(withGrayBackground: true)
            self.btn_resend_otp.isHidden = true
            self.lbl_timer.text = "\(LocalText.SignUpOtp().resend_in()) \(title)"
        }
    }
    
    // MARK: - OBJC METHODS
    
    @objc func updateTimer() {
        if self.count_down_time > 0 {
            self.count_down_time -= 1
            self.updateButtonTitle()
        } else {
            self.timer?.invalidate()
            self.timer = nil
            self.btn_resend_otp.isHidden = false
            self.btn_resend_otp.setStyle(withClearBackground: true)
            self.lbl_timer.isHidden = true
        }
    }
    
    // MARK: - API CALL
    
    func callResentOTPApi() {
        self.sign_up_otp_view_model.resendOtpApiCall(country_code: self.country_code.removePlusFromBegin(),
                                                     mobile_number: self.mobile_number,
                                                     view_for_progress_indicator: self.view)
    }
    
    func callVerifyOTPApi() {
        self.sign_up_otp_view_model.submitOtpApiCall(has_entered_otp: self.has_entered_otp, 
                                                     country_code: self.country_code.removePlusFromBegin(), 
                                                     country_iso_code: self.country_iso_code,
                                                     mobile_number: self.mobile_number,
                                                     otp: self.otp,
                                                     view_for_progress_indicator: self.view) { is_success, model in
            
            if is_success {
                
                ProfileViewModel().retriveSavedLoggedUserDetails(country_code: self.country_iso_code,
                                                                 mobile_number: self.mobile_number)
                ProfileViewModel().retrieveLoggedUserPersonalDetails(country_code: self.country_iso_code,
                                                                     mobile_number: self.mobile_number)
                
                if UserDetailsModel.shared.first_name == "" && UserDetailsModel.shared.last_name == "" {
                    self.navigateTo(.profile_vc(is_from_login: true))
                } else {
                    LockManager.shared.askForAuthentication(top_vc: self)
                }
            }
        }
    }
    
    
    // MARK: - BUTTON'S ACTIONS
    
    @IBAction func btnResendOtpPressed(_ sender: BasePoppinsRegularButton) {        
        self.otp_resent_count += 1
        UserDefaults.standard.set(otp_resent_count, forKey: UserDefaultsKey.otp_resent_count)
        if self.otp_resent_count <= 5 {
            
            self.count_down_time = 60
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            self.timer?.fire()
            
            self.callResentOTPApi()
            
        } else {
            self.temporaryLockTheApp()
        }
    }
    
    @IBAction func btnSubmitPressed(_ sender: BasePoppinsRegularButton) {
        self.callVerifyOTPApi()
    }
}


// MARK: - EXTENSION OTP VIEW

extension SignUpOTPVC: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        self.has_entered_otp = hasEntered
        self.btn_submit.isEnabled = hasEntered
        self.btn_submit.setStyle(withClearBackground: !hasEntered)
        if hasEntered {
            self.callVerifyOTPApi()
        }
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        self.otp = otpString
    }
}
