//
//  TwoStepVerificationTblViewCell.swift
//  AddressFull
//
//  Created by MacBook Pro  on 06/11/23.
//

import UIKit

class TwoStepVerificationTblViewCell: UITableViewCell {
    
    
    // MARK: OBJECTS & OUTLETS
    
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var lbl_index: AFLabelRegular!
    @IBOutlet weak var lbl_question: AFLabelRegular!
    @IBOutlet weak var lbl_answer: AFLabelRegular!
    @IBOutlet weak var btn_checkmark: BasePoppinsRegularButton!
   
    
    //MARK: TABLE VIEW CELL SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    
    //MARK: CUSTOM FUNCTIONS
    
    func setupUI() {
        self.selectionStyle = .none
        
        self.btn_checkmark.removeText()
        self.btn_checkmark.setStyleWithout(border: true, backgroundColor: .clear)
        self.bg_view.setupLayer(borderColor: .black, borderWidth: 1.0, cornerRadius: 4.0)
    }
    
    func dataSetup(index: Int, model: MyAccountTowStepVerificartionQuestionModel) {
        self.lbl_index.text = "\(index + 1)"
        self.lbl_question.text = model.question
        self.lbl_answer.text = model.answer
    }
    
    
    //MARK: IBACTIONS
    
    @IBAction func btn_checkmarkPressed(_ sender: BasePoppinsRegularButton) {
        sender.is_button_selected = !sender.is_button_selected
        sender.setImage(UIImage(named: sender.is_button_selected ? AssetsImage.rounded_green_checked : AssetsImage.rounded_unchecked), for: .normal)
    }
}
