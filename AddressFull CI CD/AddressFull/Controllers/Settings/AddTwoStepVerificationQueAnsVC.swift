//
//  AddTwoStepVerificationQueAnsVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 22/11/23.
//

import UIKit


class AddTwoStepVerificationQueAnsVC: BaseViewController {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    var two_step_verification_question_answer_list = [
        LocalText.MyProfile().what_city_were_you_born_in(),
        LocalText.MyProfile().what_is_the_name_of_your_first_pet(),
        LocalText.MyProfile().what_is_your_favorite_book_or_movie(),
        LocalText.MyProfile().what_is_your_nick_name(),
        LocalText.MyProfile().what_is_your_favorite_food()
    ]
    
    var did_two_step_verification_question_answer_entered_block : (() -> Void)!
    let add_two_step_verification_view_model = AddTwoStepVerificationViewModel()
    var new_step_verification_question_list = [""]
    var two_step_verification_question_answer_model : TwoStepVerificationQuestionAnswerModel?
    var added_two_step_verfication_questions = [TwoStepVerificationQuestionAnswerModel]()
    
    @IBOutlet weak var img_drop_down: UIImageView!
    @IBOutlet weak var btn_save_from_complete_profile: BaseBoldButton!
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var lbl_title: AFLabelRegular!
    @IBOutlet weak var dropdown_select_question: BaseIOSDropDown!
    @IBOutlet weak var txt_answer: BasePoppinsRegularTextField!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        
        self.new_step_verification_question_list = []
        
        self.navigation_bar.navigationBarSetup(isWithBackOption: true)
                
        self.dropdown_select_question.setupLayer(borderColor: .clear, borderWidth: 1.0, cornerRadius: 14.0)
        self.dropdown_select_question.backgroundColor = .white
        self.txt_answer.setupUI()
        self.txt_answer.backgroundColor = .white
        self.dropdown_select_question.isSearchEnable = false
        self.btn_save_from_complete_profile.setStyle()
        self.questionDropdownSetup()
        self.localTextSetup()
    }
    
    func localTextSetup() {
        
        self.lbl_title.text = LocalText.MyProfile().question()
        self.dropdown_select_question.placeholder = LocalText.MyProfile().select_question()
        self.txt_answer.placeholder = LocalText.MyProfile().answer_here()
        self.btn_save_from_complete_profile.setTitle(LocalText.MyProfile().save(), for: .normal)
    }
    
    func questionDropdownSetup() {
        
        if self.added_two_step_verfication_questions.count > 0 {
            self.two_step_verification_question_answer_list.forEach { question in
                self.added_two_step_verfication_questions.forEach { addedModel in
                    if addedModel.question != question {
                        self.new_step_verification_question_list.append(question)
                    }
                }
            }
        }  else {
            self.new_step_verification_question_list = self.two_step_verification_question_answer_list
        }
        
        self.dropdown_select_question.optionArray = self.new_step_verification_question_list
        self.dropdown_select_question.isSearchEnable = false
        self.dropdown_select_question.clearsOnBeginEditing = false
        self.dropdown_select_question.checkMarkEnabled = false
        self.dropdown_select_question.selectedRowColor = .white
        
        self.dropdown_select_question.didSelect{(selectedText , index ,id) in
            self.dropdown_select_question.text = selectedText
        }
        
        if let model = self.two_step_verification_question_answer_model {
            self.dropdown_select_question.isUserInteractionEnabled = false
            self.img_drop_down.isHidden = true
            self.dropdown_select_question.text = model.question
            self.txt_answer.text = model.answer
            self.txt_answer.becomeFirstResponder()
        } else {
            self.dropdown_select_question.isUserInteractionEnabled = true
            self.img_drop_down.isHidden = false
        }
    }
    
    // MARK: - BUTTON'S ACTIONS
    
    @IBAction func btnSavePressed(_ sender: BaseBoldButton) {
        
        self.view.showProgressBar()
        
        let requestModel = AddTwoStepVerificationModel(selected_question: self.dropdown_select_question.text ?? "", answer: self.txt_answer.text ?? "")
        let validation = AddTwoStepVerificationViewModel().validate(requestModel: requestModel)
    
        if validation.is_success {
            if let model = two_step_verification_question_answer_model {
                
                UtilityManager().showToast(message: Message.two_step_verification_updated_successfully())
                
                let isDataUpdated = self.add_two_step_verification_view_model.updateTwoStepVerificationQuestionAnswer(userID: "\(UserDetailsModel.shared.country_code) \(UserDetailsModel.shared.mobile_number)", question: self.dropdown_select_question.text ?? "", answer: self.txt_answer.text ?? "", questionID: model.question_id)
                
                print("Is two step verification question answer updated - \(isDataUpdated)")
            } else {
                
                UtilityManager().showToast(message: Message.two_step_verification_added_successfully())
                
                let isDataAdded = self.add_two_step_verification_view_model.saveTwoStepVerificationQuestionAnswer(userID: "\(UserDetailsModel.shared.country_code) \(UserDetailsModel.shared.mobile_number)", question: self.dropdown_select_question.text ?? "", answer: self.txt_answer.text ?? "")
                
                print("Is two step verification question answer added - \(isDataAdded)")
            }
            
            if self.did_two_step_verification_question_answer_entered_block != nil {
                self.did_two_step_verification_question_answer_entered_block()
                DispatchQueue.main.async {
                    self.view.hideProgressBar()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        else {
            
            UtilityManager().showToast(message: validation.str_error_message ?? "")
            self.view.hideProgressBar()
        }
    }
   
}
