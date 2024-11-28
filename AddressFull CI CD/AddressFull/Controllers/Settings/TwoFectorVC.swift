//
//  TwoFectorVC.swift
//  AddressFull
//
//  Created by Sneh on 24/12/23.
//

import UIKit

class TwoFectorVC: BaseViewController {
    
    // MARK: - OBJECTS & OUTLETS
    
    @IBOutlet weak var btn_submit: BaseBoldButton!
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var tbl_view_two_fector: TwoFectorTblView!
    
    let add_two_step_verification_view_model = AddTwoStepVerificationViewModel()
    var added_two_step_verfication_questions = [TwoStepVerificationQuestionAnswerModel]()
    
   
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
   
    // MARK: - CUSTOM FUNCTION
    
    func setup() {
        self.navigation_bar.navigationBarSetup(isWithBackOption: true)
        
        self.btn_submit.setStyle()
        self.btn_submit.setTitle(LocalText.MyProfile().save_now(), for: .normal)
        self.retriveTwoStepVerificationData()
        self.tblViewTwoFectorSetup()
    }
    
    
    // MARK: - TABLE VIEW SET UP
    
    func tblViewTwoFectorSetup() {
        
        // ADD TWO STEP VERIFICATION CODE AND RELOAD TABLE VIEW
        self.tbl_view_two_fector.did_two_step_verification_question_selection_button_pressed_block = { model in
            let vc = self.getController(from: .settings, controller: .add_two_step_question_vc) as! AddTwoStepVerificationQueAnsVC
            
            vc.two_step_verification_question_answer_model = model
            vc.added_two_step_verfication_questions = self.added_two_step_verfication_questions
            
            vc.did_two_step_verification_question_answer_entered_block = { () in
                self.retriveTwoStepVerificationData()
            }
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        // DELETE TWO STEP VERIFICATION CODE AND RELOAD TABLE VIEW
        self.tbl_view_two_fector.delete_two_step_verification_block = { question_id in
            self.popupAlert(title: AppInfo.app_name, message: Message.two_step_verification_delete_message(), alertStyle: .alert, actionTitles: [LocalText.AlertButton().no(),LocalText.AlertButton().yes()]) { index, title, textFieldText in
                if index == 1 {
                    
                    UtilityManager().showToast(message: Message.two_step_verification_deleted_suucessfully())
                    
                    self.view.showProgressBar()
                    
                    let isDataDeleted = AddTwoStepVerificationViewModel().deleteTwoStepVerificationQuestionAnswer(userID: "\(UserDetailsModel.shared.country_code) \(UserDetailsModel.shared.mobile_number)", questionID: question_id)
                    
                    print("Is two step verification question answer deleted - \(isDataDeleted)")
                    self.retriveTwoStepVerificationData()
                    
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    func retriveTwoStepVerificationData() {
        if let data = self.add_two_step_verification_view_model.retrieveTwoStepVerificationQuestionAnswer(userID: "\(UserDetailsModel.shared.country_code) \(UserDetailsModel.shared.mobile_number)") {
            self.tbl_view_two_fector.two_step_verification_question_answer_list = data
            self.added_two_step_verfication_questions = data
        } else {
            self.added_two_step_verfication_questions = []
            self.tbl_view_two_fector.two_step_verification_question_answer_list = []
        }
        
        DispatchQueue.main.async {
            self.tbl_view_two_fector.reloadData()
            self.view.hideProgressBar()
        }
    }
    
    // MARK: BUTTON'S ACTIONS
    
    @IBAction func btnSubmitPressed(_ sender: BaseBoldButton) {
        if self.added_two_step_verfication_questions.count == 0 {
            UtilityManager().showToast(message: ValidationMessage.please_add_two_step_verification_question())
        } else {
            let tabBarController = UIStoryboard().main().instantiateViewController(identifier: "TabBarController") as! TabBarController
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(tabBarController, animated: true)
            }
        }
    }
    
}
