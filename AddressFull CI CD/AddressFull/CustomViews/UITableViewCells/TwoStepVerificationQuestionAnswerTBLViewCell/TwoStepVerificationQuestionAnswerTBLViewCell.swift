//
//  TwoStepVerificationQuestionAnswerTBLViewCell.swift
//  AddressFull
//
//  Created by MacBook Pro  on 22/11/23.
//

import UIKit

class TwoStepVerificationQuestionAnswerTBLViewCell: UITableViewCell {
    
    
    // MARK: OBJECTS & OUTLETS
    
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var lbl_question: AFLabelBold!
    @IBOutlet weak var lbl_answer: AFLabelRegular!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_delete: UIButton!
    
    var did_pressed_edit_block : (() -> Void)!
    var did_pressed_delete_block : (() -> Void)!
    
    // MARK: TABLE VIEW CELL SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: CUSTOM FUNCTIONS
    
    func setupUI() {
        self.selectionStyle = .none
        
        self.bg_view.setupLayer(borderColor: .clear, borderWidth: 0.0, cornerRadius: 14.0)
        self.bg_view.backgroundColor = .white
        self.btn_edit.removeText()
        self.btn_delete.removeText()
        
    }
    
    // MARK:  IBACTIONS
    
    @IBAction func btnEditPressed(_ sender: UIButton) {
        if self.did_pressed_edit_block != nil {
            self.did_pressed_edit_block()
        }
    }
    
    @IBAction func btnDeletePressed(_ sender: UIButton) {
        if self.did_pressed_delete_block != nil {
            self.did_pressed_delete_block()
        }
    }
}
