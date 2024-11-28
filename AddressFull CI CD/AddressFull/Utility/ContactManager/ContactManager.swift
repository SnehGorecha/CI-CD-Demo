//
//  ContactManager.swift
//  AddressFull
//
//  Created by Sneh on 20/12/23.
//

import Foundation
import ContactsUI


/// Use this class to get details from my card from contacts. Use did_fetch blocks to get fetched details.
class ContactManager {
    
    static let shared = ContactManager()
    
    /// Use this function to check if successfully fetched details or not
    var did_fetch_complete_profile : ((Bool) -> Void)?
    
    /// Use this function to get first name, last name and profile photo
    var did_fetch_first_name_last_name_profile_photo : ((String,String,Data) -> Void)?
    
    /// Use this function to get mobile numbers
    var did_fetch_mobile_numbers : (([String]?) -> Void)?
    
    /// Use this function to get emails
    var did_fetch_emails : (([String]?) -> Void)?
    
    /// Use this function to get addresses
    var did_fetch_addresses : (([String]?) -> Void)?
    
    /// Use this function to get social links
    var did_fetch_social_links : (([String:String]?) -> Void)?
    
    
    /// Use this function to get contact card details
    func getDetails(top_vc: UIViewController) {
        if #available(iOS 14, *) {
            PermissionManager.shared.checkPermission(for: [.contact], parentController: top_vc) {
                DispatchQueue.main.async {
                    self.retrieveMyCard()
                }
            } NotAllowed: {
                if let did_fetch_complete_profile = self.did_fetch_complete_profile {
                    did_fetch_complete_profile(false)
                }
            }
        } else {
            
            top_vc.showPopupAlert(title: AppInfo.app_name,
                                message: Message.upgrade_your_os_version(),
                                leftTitle: nil,
                                rightTitle: LocalText.AlertButton().ok(),
                                close_button_hidden: true,
                                didPressedLeftButton: nil,
                                didPressedRightButton: nil)
        }
    }
    
    
    /// Use this function to retrive my card from contact
    fileprivate func retrieveMyCard() {
        do {
            let contactStore = CNContactStore()
            
            let keysToFetch = [CNContactGivenNameKey,
                               CNContactFamilyNameKey,
                               CNContactImageDataKey,
                               CNContactEmailAddressesKey,
                               CNContactPhoneNumbersKey,
                               CNContactPostalAddressesKey,
                               CNContactSocialProfilesKey]
                        
            
            let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: UserDetailsModel.shared.mobile_number))
            
            let cards = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
            
            if let my_card = cards.first {
                
                // FETCH FIRST NAME, LAST NAME AND PROFILE PHOTO
                UserDetailsModel.shared.first_name = my_card.givenName
                UserDetailsModel.shared.last_name = my_card.familyName
                UserDetailsModel.shared.image = my_card.imageData ?? Data()
                
                if let did_fetch_first_name_last_name_profile_photo = self.did_fetch_first_name_last_name_profile_photo {
                    did_fetch_first_name_last_name_profile_photo(my_card.givenName,my_card.familyName,my_card.imageData ?? Data())
                }
                
                
                // FETCH EMAILS
                if let did_fetch_emails = self.did_fetch_emails {
                    var emails = [String]()
                    
                    let fetched_emails = my_card.emailAddresses
                    if fetched_emails.count > 0 {
                        let _ = fetched_emails.map { email in
                            emails.append(email.value as String)
                        }
                        did_fetch_emails(emails)
                    } else {
                        did_fetch_emails(nil)
                    }
                }
                
                
                // FETCH MOBILE NUMBERS
                if let did_fetch_mobile_numbers = self.did_fetch_mobile_numbers {
                    var phone_numbers = [String]()
                    
                    let fetched_phone_numbers = my_card.phoneNumbers
                    if fetched_phone_numbers.count > 0 {
                        let _ = fetched_phone_numbers.map { phone in
                            var new_phone_number = phone.value.stringValue
                            let charactersToRemove = CharacterSet(charactersIn: "0123456789").inverted
                            new_phone_number = new_phone_number.components(separatedBy: charactersToRemove).joined(separator: "")
                            if new_phone_number != UserDetailsModel.shared.mobile_number {
                                phone_numbers.append(new_phone_number)
                            }
                        }
                        did_fetch_mobile_numbers(phone_numbers)
                    } else {
                        did_fetch_mobile_numbers(nil)
                    }
                }
                
                
                // FETCH ADDRESSES
                if let did_fetch_addresses = self.did_fetch_addresses {
                    var addresses = [String]()
                    
                    let fetched_addresses = my_card.postalAddresses
                    if fetched_addresses.count > 0 {
                        let _ = fetched_addresses.map { address in
                            let street = address.value.street
                            let city = address.value.city
                            let state = address.value.state
                            let country = address.value.country
                            let fullAddress = "\(street) \(city) \(state) \(country)"
                            addresses.append(fullAddress)
                        }
                        did_fetch_addresses(addresses)
                    } else {
                        did_fetch_addresses(nil)
                    }
                }
                
                
                // FETCH SOCIAL LINKS
                if let did_fetch_social_links = self.did_fetch_social_links {
                    var social_links : [String:String] = [:]
                    
                    let fetched_social_links = my_card.socialProfiles
                    if fetched_social_links.count > 0 {
                        let _ = fetched_social_links.map { profile in
                            
                            let account_type = profile.value.service
                            let url_string = profile.value.username
                            
                            if account_type == LocalText.PersonalDetails().twitter() {
                                social_links[LocalText.PersonalDetails().twitter()] = url_string
                            } else if account_type == LocalText.PersonalDetails().linkedin() {
                                social_links[LocalText.PersonalDetails().linkedin()] = url_string
                            }
                            
                        }
                        did_fetch_social_links(social_links)
                    } else {
                        did_fetch_social_links(nil)
                    }
                }
                
                
                // SUCCESS COMPLETION FOR FETCHED ALL DETAILS
                if let did_fetch_complete_profile = self.did_fetch_complete_profile {
                    did_fetch_complete_profile(true)
                }
                
            } else {
                if let did_fetch_complete_profile = self.did_fetch_complete_profile {
                    did_fetch_complete_profile(false)
                }
            }
        } catch(let err) {
            if let did_fetch_complete_profile = self.did_fetch_complete_profile {
                did_fetch_complete_profile(false)
            }
            print("\nError in getting details from My card - \(err.localizedDescription)")
        }
    }
    
}
