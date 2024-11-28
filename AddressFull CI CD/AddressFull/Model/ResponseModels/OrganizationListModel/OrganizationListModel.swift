

import Foundation


struct OrganizationListModel : Codable {
    
    var id : String?
    var organizationId : String?
    var organization_profile_image : String?
    var organization_name : String?
    var organization_website : String?
    var shared_data_count : Int?
    var is_trusted : Bool?
    var email_id, mobile_number : [String]?
    var address : String?
    var shared_email_address, shared_mobile_number, shared_address : [Int]?
    var shared_social_data : SharedSocialDataModel?
    var shared_data_timestamp : String?
    var privacy_policy : OrganizationPrivacyPolicyModel?
    var blocked_date_time : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case organizationId = "organizationId"
        case organization_profile_image = "organization_profile_image"
        case organization_name = "organization_name"
        case organization_website = "organization_website"
        case shared_data_count = "shared_data_count"
        case is_trusted = "is_trusted"
        case email_id = "email_id"
        case mobile_number = "mobile_number"
        case address = "address"
        case shared_email_address = "shared_email_address"
        case shared_mobile_number = "shared_mobile_number"
        case shared_address = "shared_address"
        case shared_social_data = "shared_social_data"
        case shared_data_timestamp = "shared_data_timestamp"
        case privacy_policy = "privacy_policy"
        case blocked_date_time = "blocked_date_time"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        organizationId = try values.decodeIfPresent(String.self, forKey: .organizationId)
        organization_profile_image = try values.decodeIfPresent(String.self, forKey: .organization_profile_image)
        organization_name = try values.decodeIfPresent(String.self, forKey: .organization_name)
        organization_website = try values.decodeIfPresent(String.self, forKey: .organization_website)
        shared_data_count = try values.decodeIfPresent(Int.self, forKey: .shared_data_count)
        is_trusted = try values.decodeIfPresent(Bool.self, forKey: .is_trusted)
        email_id = try values.decodeIfPresent([String].self, forKey: .email_id)
        mobile_number = try values.decodeIfPresent([String].self, forKey: .mobile_number)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        shared_email_address = try values.decodeIfPresent([Int].self, forKey: .shared_email_address)
        shared_mobile_number = try values.decodeIfPresent([Int].self, forKey: .shared_mobile_number)
        shared_address = try values.decodeIfPresent([Int].self, forKey: .shared_address)
        shared_social_data = try values.decodeIfPresent(SharedSocialDataModel.self, forKey: .shared_social_data)
        shared_data_timestamp = try values.decodeIfPresent(String.self, forKey: .shared_data_timestamp)
        privacy_policy = try values.decodeIfPresent(OrganizationPrivacyPolicyModel.self, forKey: .privacy_policy)
        blocked_date_time = try values.decodeIfPresent(String.self, forKey: .blocked_date_time)
    }
    
}
