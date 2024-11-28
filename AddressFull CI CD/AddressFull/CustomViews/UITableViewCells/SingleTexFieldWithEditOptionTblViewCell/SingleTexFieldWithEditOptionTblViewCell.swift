//
//  SingleTexFieldWithEditOptionTblViewCell.swift
//  AddressFull
//
//  Created by MacBook Pro  on 06/11/23.
//

import UIKit

class SingleTexFieldWithEditOptionTblViewCell: UITableViewCell {
    
    
    // MARK: OBJECTS & OUTLETS
    
    @IBOutlet weak var lbl_placeholder: AFLabelRegular!
    @IBOutlet weak var txt_content: BasePoppinsRegularTextField!
    @IBOutlet weak var btn_edit: BasePoppinsRegularButton!
    
   
    
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
        self.btn_edit.removeText()
        self.btn_edit.setStyleWithout(border: true, backgroundColor: .clear)
        self.lbl_placeholder.textColor = AppColor.placeholder_text_color()
        self.txt_content.setupLayer(borderColor: AppColor.textfield_border_color(), borderWidth: 1.0, cornerRadius: 4.0)
    }
    
    
    //MARK: MY ACCOUNT DATA SETUP
    func dataSetup(model : MyAccountOtherDetailsModel) {
        self.lbl_placeholder.text = model.placeholder_title
        self.txt_content.placeholder = model.placeholder_title
        self.txt_content.text = model.content
        
        self.txt_content.keyboardType = model.is_mobile_number ? .numberPad : .default
    }
    
    
    //MARK: APP LOCK DATA SETUP
    func dataSetup(password: String, password_placeholder: String) {
        self.lbl_placeholder.text = password_placeholder
        self.txt_content.placeholder = password_placeholder
        self.txt_content.text = password

        self.txt_content.isSecureTextEntry = true
    }
    
    
    //MARK: IBACTIONS
    
    @IBAction func btnEditPressed(_ sender: BasePoppinsRegularButton) {
        
    }
}
