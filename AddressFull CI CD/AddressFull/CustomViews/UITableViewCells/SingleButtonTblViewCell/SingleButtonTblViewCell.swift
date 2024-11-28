//
//  SingleButtonTblViewCell.swift
//  AddressFull
//
//  Created by MacBook Pro  on 03/11/23.
//

import UIKit

class SingleButtonTblViewCell: UITableViewCell {

    
    // MARK: OBJECTS & OUTLETS
    
    var didButtonSignlePressedBlock : ((_ row: Int, _ section: Int) -> Void)!
    
    @IBOutlet weak var btn_single: BaseBoldButton!
    
    
    //MARK: TABLE VIEW SETUP
    
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
        self.btn_single.setStyle()
        self.localTextSetup()
    }
    
    func localTextSetup() {
        self.btn_single.setTitle(LocalText.OrganizationProfile().share_data(), for: .normal)
    }
    
    
    //MARK: IBACTIONS
    
    @IBAction func btnSinglePressed(_ sender: BaseBoldButton) {
        
        if self.didButtonSignlePressedBlock != nil {
            self.didButtonSignlePressedBlock(sender.row, sender.section)
        }
    }
}
