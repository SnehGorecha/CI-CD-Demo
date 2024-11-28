//
//  TwoFectorTblView.swift
//  AddressFull
//
//  Created by Sneh on 24/12/23.
//

import Foundation
import UIKit

class TwoFectorTblView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    let k_select_two_step_verification_question_tbl_view_cell = SelectTwoStepVerificationQuestionTBLViewCell.identifier
    let k_two_step_verification_question_answer_tbl_view_cell = TwoStepVerificationQuestionAnswerTBLViewCell.identifier
    
    var two_step_verification_question_answer_list = [TwoStepVerificationQuestionAnswerModel]()

    var did_two_step_verification_question_selection_button_pressed_block : ((TwoStepVerificationQuestionAnswerModel?) -> Void)!
    var delete_two_step_verification_block : ((String) -> Void)!
    
    
    // MARK: - TABLE VIEW SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        
        self.delegate = self
        self.dataSource = self
        
        self.estimatedRowHeight = 100.0
        self.rowHeight = UITableView.automaticDimension
        
        self.removeHeaderTopPadding()
        
        self.register(UINib(nibName: self.k_select_two_step_verification_question_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_select_two_step_verification_question_tbl_view_cell)
        
        self.register(UINib(nibName: self.k_two_step_verification_question_answer_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_two_step_verification_question_answer_tbl_view_cell)
    }
    
    
    // MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.two_step_verification_question_answer_list.count
        return count < 2 ? count + 1 : count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed(SingleLabelTblViewHeader.identifier, owner: self)![0] as! SingleLabelTblViewHeader
        headerView.setupData(title: LocalText.TwoStepVerification().security_questions(),background_color: .clear)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 && self.two_step_verification_question_answer_list.count < 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.k_select_two_step_verification_question_tbl_view_cell) as! SelectTwoStepVerificationQuestionTBLViewCell
            
            cell.did_pressed_selection_block = {
                if let did_two_step_verification_question_selection_button_pressed_block = self.did_two_step_verification_question_selection_button_pressed_block {
                    did_two_step_verification_question_selection_button_pressed_block(nil)
                }
            }

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.k_two_step_verification_question_answer_tbl_view_cell) as! TwoStepVerificationQuestionAnswerTBLViewCell
            
            let count = self.two_step_verification_question_answer_list.count
            let model = self.two_step_verification_question_answer_list[indexPath.row - (count < 2 ? 1 : 0)]
            
            cell.lbl_question.text = model.question
            
            cell.did_pressed_edit_block = {
                self.did_two_step_verification_question_selection_button_pressed_block(model)
            }
            
            cell.did_pressed_delete_block = {
                if let delete_two_step_verification_block = self.delete_two_step_verification_block {
                    delete_two_step_verification_block(model.question_id)
                }
            }
            
            return cell
        }
    }

}

