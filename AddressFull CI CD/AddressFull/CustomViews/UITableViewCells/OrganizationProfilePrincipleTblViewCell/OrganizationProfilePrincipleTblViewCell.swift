//
//  OrganizationProfilePrincipleTblViewCell.swift
//  AddressFull
//
//  Created by Sneh on 20/05/24.
//

import UIKit

class OrganizationProfilePrincipleTblViewCell: UITableViewCell {
    
    @IBOutlet weak var lblPrinciple: AFLabelRegular!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupData(organization_model : OrganizationListModel) {
        let consenting_text = "\(LocalText.OrganizationProfile().please_select_check_box_and_share_your_data()) \(organization_model.organization_name ?? "") in compliance with \(organization_model.privacy_policy?.rule ?? "") regulations, which adhere to principles of \(organization_model.privacy_policy?.sub_rules?.first ?? "")"
        
        self.lblPrinciple.setAttributedString(str: consenting_text,
                                              attributedStr: [
                                                organization_model.organization_name ?? "",
                                                organization_model.privacy_policy?.rule ?? "",
                                                organization_model.privacy_policy?.sub_rules?.first ?? ""
                                              ],
                                              font: AppFont.helvetica_bold,
                                              size: 16)
    }
    
}
