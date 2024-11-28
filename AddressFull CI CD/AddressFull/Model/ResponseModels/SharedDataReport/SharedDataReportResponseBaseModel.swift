



import Foundation

struct SharedDataReportResponseBaseModel : Codable {
    
    let status : Int?
    let data : SharedDataReportResponseModel?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.status = try values.decodeIfPresent(Int.self, forKey: .status)
        self.data = try values.decodeIfPresent(SharedDataReportResponseModel.self, forKey: .data)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
