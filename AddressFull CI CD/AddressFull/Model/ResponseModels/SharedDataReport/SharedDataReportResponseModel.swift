



import Foundation

struct SharedDataReportResponseModel : Codable {
    
    let link : String?

    enum CodingKeys: String, CodingKey {
        case link = "link"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.link = try values.decodeIfPresent(String.self, forKey: .link)
    }

}
