//
//  OnboardingCV.swift
//  AddressFull
//
//  Created by MacBook Pro  on 31/10/23.
//

import UIKit

class OnboardingCV: UICollectionView {
    
    let k_onboarding_cv_cell_indentifier = OnboardingCVCell.identifier
    let k_onboarding_cv_last_cell_indentifier = OnboardingCVLastCell.identifier
    var onboarding_list = [OnboardingModel]()
    
    var didOnboardingScrolledBlock : ((_ atIndex: Int) -> Void)!
    var didOnboardingLoginButtonPressedBlock : (() -> Void)!
    var didOnboardingSignUpButtonPressedScrolledBlock : (() -> Void)!
    var did_tap_login_button : (() -> Void)?
    var did_tap_signup_button : (() -> Void)?
    
    var lastContentOffset: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI() {
        
        self.delegate = self
        self.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionViewLayout = layout
        
        self.backgroundColor = .clear
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.register(UINib(nibName: self.k_onboarding_cv_cell_indentifier, bundle: nil), forCellWithReuseIdentifier: self.k_onboarding_cv_cell_indentifier)
        self.register(UINib(nibName: self.k_onboarding_cv_last_cell_indentifier, bundle: nil), forCellWithReuseIdentifier: self.k_onboarding_cv_last_cell_indentifier)
    }
}


// MARK: - UICollectionViewDataSource
extension OnboardingCV: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.onboarding_list.count + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == onboarding_list.count {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.k_onboarding_cv_last_cell_indentifier, for: indexPath) as! OnboardingCVLastCell
            
            cell.setUpData(img: AssetsImage.app_logo_green)
            
            cell.did_tap_login_button = {
                if let did_tap_login_button = self.did_tap_login_button {
                    did_tap_login_button()
                }
            }
            
            cell.did_tap_signup_button = {
                if let did_tap_signup_button = self.did_tap_signup_button {
                    did_tap_signup_button()
                }
            }
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.k_onboarding_cv_cell_indentifier, for: indexPath) as! OnboardingCVCell
            
            cell.setupData(model: self.onboarding_list[indexPath.row])
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension OnboardingCV: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UIScrollViewDelegate
extension OnboardingCV: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Calculate the currently fully visible cell index when scrolling ends
        
        let visibleRect = CGRect(origin: self.contentOffset, size: self.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let indexPath = self.indexPathForItem(at: visiblePoint) {
            let currentIndex = indexPath.item
            if self.didOnboardingScrolledBlock != nil {
                self.didOnboardingScrolledBlock(currentIndex)
            }
        }
    }
}

