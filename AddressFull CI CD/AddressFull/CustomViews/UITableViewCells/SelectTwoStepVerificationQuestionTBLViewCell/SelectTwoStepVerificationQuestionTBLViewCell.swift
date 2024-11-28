//
//  SelectTwoStepVerificationQuestionTBLViewCell.swift
//  AddressFull
//
//  Created by MacBook Pro  on 22/11/23.
//

import UIKit

class SelectTwoStepVerificationQuestionTBLViewCell: UITableViewCell {

    
    // MARK: OBJECTS & OUTLETS
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lbl_title: AFLabelRegular!
    @IBOutlet weak var btn_selection: UIButton!
    
    var did_pressed_selection_block : (() -> Void)?
    
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
        
        self.bgView.setupLayer(borderColor: .clear, borderWidth: 0.0, cornerRadius: 14.0)
        self.bgView.backgroundColor = .white
        
        self.btn_selection.removeText()
        self.localTextSetup()
    }
    
    func localTextSetup() {
        self.lbl_title.text = LocalText.MyProfile().select_question()
    }
    
    // MARK:  IBACTIONS
    
    @IBAction func btnSelectionPressed(_ sender: UIButton) {
        if let did_pressed_selection_block = self.did_pressed_selection_block {
            did_pressed_selection_block()
        }
    }
}
