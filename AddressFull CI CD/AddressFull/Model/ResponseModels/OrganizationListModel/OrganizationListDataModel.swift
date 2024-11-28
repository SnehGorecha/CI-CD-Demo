

import Foundation

struct OrganizationListDataModel : Codable {

    let organization_list : [OrganizationListModel]?
    let request_count : Int?
    let shared_count : Int?
	let page_info : OrganizationListPageInfoModel?

	enum CodingKeys: String, CodingKey {

        case organization_list = "organization_list"
        case request_count = "request_count"
		case shared_count = "shared_count"
		case page_info = "page_info"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        organization_list = try values.decodeIfPresent([OrganizationListModel].self, forKey: .organization_list)
        request_count = try values.decodeIfPresent(Int.self, forKey: .request_count)
        shared_count = try values.decodeIfPresent(Int.self, forKey: .shared_count)
		page_info = try values.decodeIfPresent(OrganizationListPageInfoModel.self, forKey: .page_info)
	}
}
