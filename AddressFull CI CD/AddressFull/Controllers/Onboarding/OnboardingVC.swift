//
//  OnboardingVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 31/10/23.
//

import UIKit


class OnboardingVC: BaseViewController {
    
    // MARK: - OBJECTS & OUTLETS
    
    var scroll_to_at: Int? = nil
    var new_scroll_to_at = 0
    var timer = Timer()
    
    var arr_segment_images = [AssetsImage.onboard_slider_one,
                              AssetsImage.onboard_slider_two,
                              AssetsImage.onboard_slider_three,
                              AssetsImage.onboard_slider_four]
    
    var arr_button_titles = [LocalText.Onboarding().get_started(),
                             LocalText.Onboarding().get_started(),
                             LocalText.Onboarding().next(),
                             LocalText.Onboarding().done()]
    
    
    @IBOutlet weak var img_page_control: UIImageView!
    @IBOutlet weak var btn_next: BaseBoldButton!
    @IBOutlet weak var btn_login: BaseBoldButton!
    @IBOutlet weak var view_page_control: UIView!
    @IBOutlet weak var cv_onboarding: OnboardingCV!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationBar()
        
        let onboarding_list = [
            OnboardingModel(current_index: 0, image: AssetsImage.onboarding_one, title: LocalText.Onboarding().onboarding_one_title(), description: LocalText.Onboarding().onboarding_one_desc(), last_button_title: LocalText.Onboarding().get_started(), segment_image: AssetsImage.onboard_slider_one),
            
            OnboardingModel(current_index: 1, image: AssetsImage.onboarding_two, title: LocalText.Onboarding().onboarding_two_title(), description: LocalText.Onboarding().onboarding_two_desc(), last_button_title: LocalText.Onboarding().next(), segment_image: AssetsImage.onboard_slider_two),
            
            OnboardingModel(current_index: 2, image: AssetsImage.onboarding_three, title: LocalText.Onboarding().onboarding_three_title(), description: LocalText.Onboarding().onboarding_three_desc(), last_button_title: LocalText.Onboarding().next(), segment_image: AssetsImage.onboard_slider_three),
            
            OnboardingModel(current_index: 3, image: AssetsImage.onboarding_four, title: LocalText.Onboarding().onboarding_four_title(), description: LocalText.Onboarding().onboarding_one_desc(), last_button_title: LocalText.Onboarding().done(), segment_image: AssetsImage.onboard_slider_four),
            
            //            OnboardingModel(current_index: 4, image: AssetsImage.app_logo_green, title: "", description: "", first_button_title: LocalText.BioMetricAuthentication().login(), last_button_title: LocalText.SignUpScreen().sign_up(), is_next_redirection_enabled: false, segment_image: nil)
        ]
        
        
        self.view_page_control.isHidden = false
        
        self.img_page_control.image = UIImage(named: self.arr_segment_images[0])
        self.btn_next.setTitle(self.arr_button_titles[0], for: .normal)
        self.btn_login.setTitle(LocalText.BioMetricAuthentication().login(), for: .normal)
        
        self.btn_next.setStyle()
        self.btn_login.setStyle(withClearBackground: true)
        
        self.cv_onboarding.onboarding_list = onboarding_list
        self.cv_onboarding.setupUI()
        
        self.cv_onboarding.did_tap_login_button = {
            self.navigateTo(.signup_vc(is_for_login: true))
        }
        self.cv_onboarding.did_tap_signup_button = {
            self.navigateTo(.gdpr_compliance_vc(is_from_login: true))
        }
        
        self.cv_onboarding.didOnboardingScrolledBlock = { index in
            
            self.timer.invalidate()
            
            self.new_scroll_to_at = index
            DispatchQueue.main.async {
                
                if self.new_scroll_to_at < self.arr_button_titles.count {
                    self.img_page_control.image = UIImage(named: self.arr_segment_images[self.new_scroll_to_at])
                    self.btn_next.setTitle(self.arr_button_titles[self.new_scroll_to_at], for: .normal)
                    
                    self.timer = Timer.scheduledTimer(timeInterval: OnboardingScreenAutoScroll().time, target: self, selector: #selector(self.scrollCollectionView), userInfo: nil, repeats: true)
                    self.timer.fire()
                    
                    self.scroll_to_at = self.new_scroll_to_at
                } else if self.new_scroll_to_at >= self.arr_button_titles.count {
                    UserDefaults.standard.set(true, forKey: UserDefaultsKey.is_onboarding_finished)
                    self.btn_next.isHidden = true
                    self.cv_onboarding.isScrollEnabled = false
                    self.view_page_control.isHidden = true
                    self.timer.invalidate()
                }
            }
        }
        
        self.cv_onboarding.reloadData()
        self.view.backgroundColor = AppColor.primary_light_gray()
        
        if let scrollIndex = self.scroll_to_at {
            DispatchQueue.main.async {
                self.view_page_control.isHidden = true
                self.cv_onboarding.isScrollEnabled = false
                self.btn_next.isHidden = true
                self.cv_onboarding.scrollToItem(at: IndexPath(row: scrollIndex, section: 0), at: .centeredHorizontally, animated: false)
            }
        } else {
            self.timer = Timer.scheduledTimer(timeInterval: OnboardingScreenAutoScroll().time, target: self, selector: #selector(scrollCollectionView), userInfo: nil, repeats: true)
            self.timer.fire()
        }
    }
    
    // MARK: - OBJC FUNCTIONS
    
    @objc func scrollCollectionView() {
        if self.new_scroll_to_at != self.arr_button_titles.count {
            DispatchQueue.main.async {
                self.btn_next.isHidden = self.new_scroll_to_at != self.arr_button_titles.count - 1
                self.cv_onboarding.scrollToItem(at: IndexPath(row: self.new_scroll_to_at, section: 0), at: .centeredHorizontally, animated: true)
                self.img_page_control.image = UIImage(named: self.arr_segment_images[self.new_scroll_to_at])
                self.btn_next.setTitle(self.arr_button_titles[self.new_scroll_to_at], for: .normal)
                self.scroll_to_at = self.new_scroll_to_at
                self.new_scroll_to_at += 1
            }
        } else {
            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: UserDefaultsKey.is_onboarding_finished)
                self.cv_onboarding.scrollToItem(at: IndexPath(row: self.new_scroll_to_at, section: 0), at: .centeredHorizontally, animated: true)
                self.scroll_to_at = self.new_scroll_to_at
                self.btn_next.isHidden = true
                self.view_page_control.isHidden = true
                self.cv_onboarding.isScrollEnabled = false
                self.timer.invalidate()
            }
        }
    }
    
    // MARK: - BUTTON'S ACTIONS
    
    @IBAction func btnLoginClicked(_ sender: BasePoppinsRegularButton) {
        self.navigateTo(.signup_vc(is_for_login: true))
    }
    
    @IBAction func btnNextClicked(_ sender: BaseBoldButton) {
        self.timer.invalidate()
        DispatchQueue.main.async {
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.is_onboarding_finished)
            self.cv_onboarding.scrollToItem(at: IndexPath(row: self.cv_onboarding.onboarding_list.count, section: 0), at: .centeredHorizontally, animated: true)
            self.cv_onboarding.isScrollEnabled = false
            self.btn_next.isHidden = true
            self.view_page_control.isHidden = true
        }
        
    }
}
