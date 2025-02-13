

import Foundation


struct SignupResponseDataModel : Codable {
    
    var token : String?

	enum CodingKeys: String, CodingKey {
        case token = "token"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try values.decodeIfPresent(String.self, forKey: .token)
	}
}
