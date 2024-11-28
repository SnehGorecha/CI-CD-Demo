//
//  MyProfileAddInputFieldTblViewCell.swift
//  AddressFull
//
//  Created by MacBook Pro  on 02/11/23.
//

import UIKit

class MyProfileAddInputFieldTblViewCell: UITableViewCell {

    
    // MARK: OBJECTS & OUTLETS
    
    @IBOutlet weak var btn_add_another: BasePoppinsRegularButton!
    
    
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
        
        self.localTextSetup()
    }
    
    func localTextSetup() {
        self.btn_add_another.setTitle(LocalText.MyProfile().add_more(), for: .normal)
        self.btn_add_another.setStyle(bg_color : .clear,title_color: .black)
    }
}
