//
//  ProfileVC+ Contact card Extension.swift
//  AddressFull
//
//  Created by Sneh on 20/03/24.
//

import Foundation
import ContactsUI

extension ProfileVC {
    
    func fetchContactDetails() {
        
        self.view.showProgressBar()
        
        // CONTACT CARD COMPLETION
        ContactManager.shared.did_fetch_complete_profile = { is_success in
            
            DispatchQueue.main.async {
                self.view.hideProgressBar()
            }
            
            if is_success {
                self.tblViewMyProfileDetailsSetup()
            } else {
                if let data = self.my_profile_view_model.retrieveLoggedUserPersonalDetails(country_code: UserDetailsModel.shared.country_code, mobile_number: UserDetailsModel.shared.mobile_number) {
                    self.my_profile_model = data
                }
                self.tblViewMyProfileDetailsSetup()
            }
        }
        
        // CONTACT CARD FIRST NAME, LAST NAME, PHOTO
        ContactManager.shared.did_fetch_first_name_last_name_profile_photo = { first_name,last_name,profile_photo in
            self.my_profile_model.first_name.value = first_name
            self.my_profile_model.last_name.value = last_name
            self.my_profile_model.image = profile_photo
        }
        
        
        // CONTACT CARD MOBILE NUMEBERS
        ContactManager.shared.did_fetch_mobile_numbers = { mobile_numbers in
            if let mobile_numbers = mobile_numbers, mobile_numbers.count > 0 {
                let _ = mobile_numbers.map { mobile_number in
                    self.my_profile_model.arr_mobile_numbers.append(ProfileDataModel(type_of_field: LocalText.PersonalDetails().mobile_number(), type_of_value: LocalText.PersonalDetails().primary(), value: mobile_number,country_code: Country.getCurrentCountry()?.code))
                }
            }
        }
        
        
        // CONTACT CARD EMAILS
        ContactManager.shared.did_fetch_emails = { emails in
            if let emails = emails, emails.count > 0 {
                self.my_profile_model.arr_email.removeFirst()
                let _ = emails.map { email in
                    self.my_profile_model.arr_email.append(ProfileDataModel(type_of_field: LocalText.PersonalDetails().email(), type_of_value: LocalText.PersonalDetails().primary(), value: email))
                }
            }
        }
        
        
        // CONTACT CARD ADDRESSES
        ContactManager.shared.did_fetch_addresses = { addresses in
            if let addresses = addresses, addresses.count > 0 {
                self.my_profile_model.arr_address.removeFirst()
                let _ = addresses.map { address in
                    self.my_profile_model.arr_address.append(ProfileDataModel(type_of_field: LocalText.PersonalDetails().address(), type_of_value: LocalText.PersonalDetails().home(), value: address))
                }
            }
        }
        
        
        // CONTACT CARD SOCIAL LINKS
        ContactManager.shared.did_fetch_social_links = { social_links in
            if let social_links = social_links, social_links.count > 0 {
                let _ = social_links.map { social_link in
                    if social_link.key == LocalText.PersonalDetails().linkedin() {
                        self.my_profile_model.arr_social_links[0] = ProfileDataModel(type_of_field: LocalText.MyProfile().social(),type_of_value: social_link.key,value: social_link.value)
                    } else if social_link.key == LocalText.PersonalDetails().twitter() {
                        self.my_profile_model.arr_social_links[1] = ProfileDataModel(type_of_field: LocalText.MyProfile().social(),type_of_value: social_link.key,value: social_link.value)
                    }
                }
            }
        }
        
        
        // GET CONTACT CARD DETAILS
        ContactManager.shared.getDetails(top_vc: self)
    }
    
}
