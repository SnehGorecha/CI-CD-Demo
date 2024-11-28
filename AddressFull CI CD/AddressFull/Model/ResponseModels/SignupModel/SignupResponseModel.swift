


import Foundation

struct SignupResponseModel : Codable {
    
	let status : Int?
    let message : String?
	let isCronService : Bool?

	enum CodingKeys: String, CodingKey {

		case status = "status"
        case message = "message"
		case isCronService = "isCronService"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
        self.status = try values.decodeIfPresent(Int.self, forKey: .status)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.isCronService = try values.decodeIfPresent(Bool.self, forKey: .isCronService)
	}

}
