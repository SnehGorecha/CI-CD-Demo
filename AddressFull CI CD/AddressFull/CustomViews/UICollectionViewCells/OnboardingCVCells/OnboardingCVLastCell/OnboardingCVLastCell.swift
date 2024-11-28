//
//  OnboardingCVLastCell.swift
//  AddressFull
//
//  Created by Sneh on 16/05/24.
//

import UIKit

class OnboardingCVLastCell: UICollectionViewCell {

    @IBOutlet weak var img_view: UIImageView!
    @IBOutlet weak var btn_sign_up: BaseBoldButton!
    @IBOutlet weak var btn_login: BaseBoldButton!
    
    var did_tap_login_button : (() -> Void)?
    var did_tap_signup_button : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpData(img: String) {
        self.img_view.image = UIImage(named: img) 
        self.btn_login.setTitle(LocalText.BioMetricAuthentication().login(), for: .normal)
        self.btn_sign_up.setTitle(LocalText.SignUpScreen().sign_up(), for: .normal)
        
        self.btn_sign_up.setStyle()
        self.btn_login.setStyle(withClearBackground: true)
    }
    
    @IBAction func btnLoginPressed(_ sender: BaseBoldButton) {
        if let did_tap_login_button = self.did_tap_login_button {
            did_tap_login_button()
        }
    }
    
    @IBAction func btnSignUpPressed(_ sender: BaseBoldButton) {
        if let did_tap_signup_button = self.did_tap_signup_button {
            did_tap_signup_button()
        }
    }
    
}
