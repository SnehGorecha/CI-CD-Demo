//
//  LoginWithSecurityQuestionVC.swift
//  AddressFull
//
//  Created by Sneh on 11/24/23.
//

import UIKit

class LoginWithSecurityQuestionVC: BaseViewController {

    // MARK: - OBJECTS & OUTLETS
    
    let add_two_step_verification_view_model = AddTwoStepVerificationViewModel()
    var did_two_step_verification_question_answer_entered_block : (() -> Void)!
    var two_step_verification_question_answer_list = [TwoStepVerificationQuestionAnswerModel]()
    var selectedQuestionIndex = 0
    var is_from_splash_screen = false
    let maxAttempts = 5
    var remainingAttempts = 0
    var timer: Timer?
    var remainingTime = 0
    
    @IBOutlet weak var lbl_description: AFLabelLight!
    @IBOutlet weak var lbl_attempts_remaining: AFLabelRegular!
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var lbl_title: AFLabelRegular!
    @IBOutlet weak var dropdown_select_question: BaseIOSDropDown!
    @IBOutlet weak var txt_answer: BasePoppinsRegularTextField!
    @IBOutlet weak var lbl_security_question: AFLabelRegular!
    @IBOutlet weak var btn_submit: BaseBoldButton!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        GlobalVariables.shared.asked_for_password = true

        self.navigation_bar.navigationBarSetup(isWithRightOption: false,isWithQROption: false)
        
        self.dropdown_select_question.setupLayer(borderColor: .clear, borderWidth: 1.0, cornerRadius: 14.0)
        self.view.backgroundColor = .white
        self.dropdown_select_question.backgroundColor = AppColor.light_gray()
        self.txt_answer.setupUI()
        self.dropdown_select_question.isSearchEnable = false
        self.localTextSetup()
        self.questionDropdownSetup()
        self.btn_submit.setStyle()
        self.checkAttempts()
    }
    
    func localTextSetup() {
        
        self.lbl_title.text = LocalText.BioMetricAuthentication().welcome_back()
        self.lbl_security_question.text = LocalText.MyProfile().question()
        self.lbl_description.text = LocalText.MyProfile().answer_the_security_question()
        self.dropdown_select_question.placeholder = LocalText.MyProfile().select_question()
        self.txt_answer.placeholder = LocalText.MyProfile().answer_here()
        self.btn_submit.setTitle(LocalText.SignUpOtp().submit(), for: .normal)
    }
    
    func questionDropdownSetup() {
        self.two_step_verification_question_answer_list.forEach { model in
            self.dropdown_select_question.optionArray.append(model.question)
        }
        self.dropdown_select_question.clearsOnBeginEditing = false
        self.dropdown_select_question.checkMarkEnabled = false
        self.dropdown_select_question.selectedRowColor = .white
        
        self.dropdown_select_question.didSelect{(selectedText , index ,id) in
            self.dropdown_select_question.text = selectedText
            self.selectedQuestionIndex = index
        }
    }

    func checkAttempts() {
        if let attempts = UserDefaults.standard.value(forKey: UserDefaultsKey.password_attempts) as? Int {
            self.remainingAttempts = attempts
        } else {
            self.remainingAttempts = 5
        }
        
        DispatchQueue.main.async {
            self.lbl_attempts_remaining.text = "\(LocalText.LoginWithSecurityQuestion().attempts_remaining()) \(self.remainingAttempts)"
        }
    }
    
    // MARK: - BUTTON'S ACTIONS
    
    @IBAction func btnSubmitPressed(_ sender: BasePoppinsRegularButton) {
        let requestModel = AddTwoStepVerificationModel(selected_question: self.dropdown_select_question.text ?? "", answer: self.txt_answer.text ?? "")
        let validation = AddTwoStepVerificationViewModel().validate(requestModel: requestModel)
        
        if validation.is_success {
            let correct_answer = two_step_verification_question_answer_list[selectedQuestionIndex].answer
            
            print("Two step Selected question - \(self.dropdown_select_question.text ?? "")")
            print("Two step Correct answer - \(correct_answer)")
            print("Two step User answer - \(self.txt_answer.text ?? "")")
            
            if let user_answer = self.txt_answer.text, correct_answer == user_answer {
                
                // CORRECT ANSWER
                if !is_from_splash_screen {
                    DispatchQueue.main.async {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            GlobalVariables.shared.is_app_launched = true
                            GlobalVariables.shared.asked_for_password = false
                        })
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    UserDefaults.standard.setValue(self.maxAttempts, forKey: UserDefaultsKey.password_attempts)
                    
                    let tabBarController = UIStoryboard().main().instantiateViewController(identifier: "TabBarController") as! TabBarController
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(tabBarController, animated: true)
                    }
                }
            } else {

                // WRONG ANSWER
                self.remainingAttempts -= 1
                UserDefaults.standard.setValue(self.remainingAttempts, forKey: UserDefaultsKey.password_attempts)
                
                // CHECK REMAINING COUNTS
                if self.remainingAttempts <= 0 {
                    self.temporaryLockTheApp()
                } else {
                    
                    self.lbl_attempts_remaining.text = "\(LocalText.LoginWithSecurityQuestion().attempts_remaining()) \(self.remainingAttempts)"
                    UtilityManager().showToast(message: Message.two_step_verification_wrong_answer())
                }
            }
        }
        else {
            UtilityManager().showToast(message: validation.str_error_message ?? "")
        }
    }
}
