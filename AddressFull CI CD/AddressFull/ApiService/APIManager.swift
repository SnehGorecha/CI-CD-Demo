//
//  APIManager.swift
//  BaseProject
//
//  Created by MacBook Pro  on 05/10/23.
//

import Foundation
import Alamofire


enum APIError: Error {
    case request_failed
    case decode_failed
}

/// This struct will retrive base url from flavour config file
struct Environment {
    public func configuration() -> String {
        
        let base_url = "base_url"
        let network = "network"
        
        return "\(EnvironmentUtility().getUrlFromMainInfoDictionary(url_key: network))://\(EnvironmentUtility().getUrlFromMainInfoDictionary(url_key: base_url))"
    }
}

fileprivate struct EnvironmentUtility {
    
    fileprivate var info_dictionary: [String: Any] {
        return Bundle.main.infoDictionary ?? [String: Any]()
    }
    
    private func getValueFromMainInfoDictionary(key: String) -> String {
        return info_dictionary[key] as? String ?? ""
    }
    
    func getUrlFromMainInfoDictionary(url_key: String) -> String {
        
        let url_string = EnvironmentUtility().getValueFromMainInfoDictionary(key: url_key)
        
        if url_string.isEmpty {
            return String()
        }
        return url_string
    }
    
}

//MARK: - EnvironmentUtility Extension
extension EnvironmentUtility {
    func getValueFromMainInfoDictionary(key_name: String) -> String {
        return EnvironmentUtility().getValueFromMainInfoDictionary(key: key_name)
    }
}

class AlamofireAPICallManager {
    
    
    static let shared = AlamofireAPICallManager()
    
    /// Into this variable base url will be assigned
    private var base_url: URL {
        return URL(string: Environment().configuration())!
    }
    
    /// API header will set using this variable
    var header: [String : Any]?
    
    
    /// To call api except multipart (get, post, delete, put, connect, query, etc...) use this function and it will return status with data model
    func apiCall<T: Decodable>(_ decoder: T.Type,
                               to endpoint: Endpoint,
                               with parameters: [String: Any]?,
                               view_for_progress_indicator: UIView?,
                               is_pull_to_refresh: Bool = false,
                               progress: ((Progress) -> Void)? = nil,
                               encryptedRequest : String? = nil,
                               pass_param_in_url_with_question_mark : Bool? = nil,
                               organization_id: String? = nil,
                               completion: @escaping (_ isSuccess: Bool, T?, _ errorMessage: String?,_ encryptedResponse: String?) -> Void) {
        
        guard ReachabilityManager.shared.isNetworkAvailable else {
            
            completion(false, nil, Message.network_not_available(),nil)
            return
        }
        
        if !is_pull_to_refresh && endpoint != .refresh_token && endpoint != .force_update {
            view_for_progress_indicator?.showProgressBar()
        }
        
        
        // PARAMETERS
        let param = (encryptedRequest != nil) 
                        ? (encryptedRequest ?? "").data(using: .utf8) 
                            : (parameters ?? [:]).toData()
            
        
        // URL
        let apiUrl = "\(self.base_url)\(endpoint.url)"
        
        
        // HEADER
        var header : HTTPHeaders?
        header = self.createApiHeader(userDefinedHeader: self.header)
        
        
        var url = URL(string: apiUrl)
        
        var apiStringForOrganizationProfile = ""
        if endpoint == .organization_profile, let organization_id = organization_id {
            apiStringForOrganizationProfile = "\(apiUrl)/\(organization_id)"
        }
        
        
        if let pass_param_in_url_with_question_mark = pass_param_in_url_with_question_mark , parameters != nil {
            if pass_param_in_url_with_question_mark {
                let queryParameter =  self.convertDictionaryToQueryString((parameters ?? [:])) 
                if endpoint == .organization_profile {
                    url = URL(string: "\(apiStringForOrganizationProfile)?\(queryParameter)")
                } else {
                    url = URL(string: "\(apiUrl)?\(queryParameter)")
                }
            } else {
                if let value = parameters?.values.first {
                    url = URL(string: "\(apiUrl)/\(value)")
                }
            }
        }
        
        // IF GET METHOD
        if endpoint.method == .get {
            
            print("************************************************************************************************")
            print("API call\nURL - \(url?.absoluteString ?? "")\nHeader - \(String(describing: header))\nParameters - Normal - \((parameters ?? [:]).toJson() ?? "") || Encrypted - \(String(describing: encryptedRequest))\nMethod - \(endpoint.method)")
            print("************************************************************************************************")
            
            AF.request(url!, method: .get, encoding: URLEncoding.default, headers: header).validate().response { response in
                
                AlamofireAPICallManager.shared.header = nil
                
                view_for_progress_indicator?.hideProgressBar()
                
                // SUCCESS
                if response.response?.statusCode == 200 {
                    if let responseData = response.data {
                        let json = String(data: responseData, encoding: String.Encoding.utf8)
                        let responseJSON = json
                        
                        print("URL - \(self.base_url)\(endpoint.url)\nJSON RESPONSE: \(responseJSON ?? "")\n")
                        
                        // IF NORMAL RESOPONSE RECEIVED
                        if let data = responseJSON?.data(using: String.Encoding.utf8) {
                            do {
                                let object = try JSONDecoder().decode(decoder, from: data)
                                print("URL - \(self.base_url)\(endpoint.url)\nNORMAL RESPONSE:",object)
                                
                                let dictData = (responseJSON ?? "").toDictionary()
                                let message = dictData?["message"] as? String
                                
                                if let status = dictData?["status"] as? Int, status == 200 {
                                    completion(true, object, message ?? "",nil)
                                }
                                else {
                                    completion(false, object, message ?? Message.something_went_wrong(),nil)
                                }
                            }
                            catch(let err) {
                                
                                // IF ENCRYPTED RESOPONSE RECEIVED
                                if responseJSON != "" {
                                    print("URL - \(self.base_url)\(endpoint.url)\nENCRYPTED RESPONSE:",responseJSON ?? "")
                                    completion(true, nil, Message.something_went_wrong(),responseJSON)
                                } else {
                                    print("URL - \(self.base_url)\(endpoint.url)\nERROR:",err.localizedDescription)
                                    completion(false, nil, Message.something_went_wrong(),nil)
                                }
                            }
                        } else {
                            completion(false, nil, Message.something_went_wrong(),nil)
                        }
                    }
                }
                
                // FAILURE
                else {
                    
                    if response.result == .failure(.explicitlyCancelled) {
                        
                        completion(false,nil,AFError.explicitlyCancelled.errorDescription,nil)
                        
                    } else {
                        
                        if let data = response.data {
                            let json = String(data: data, encoding: String.Encoding.utf8)
                            let responseJSON = json
                            
                            // IF NORMAL RESOPONSE RECEIVED
                            if let data = responseJSON?.data(using: String.Encoding.utf8) {
                                do {
                                    let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                                    if let myDict = dictionary {
                                        print("************************************************************************************************")
                                        print("API call\nURL - \(apiUrl)\nResponse - \(myDict)")
                                        print("************************************************************************************************")
                                        
                                        if response.response?.statusCode == 401 && (endpoint != .login) && (endpoint != .signup) && (endpoint != .verify_otp) {
                                            BaseViewController().logoutUser(message: (myDict["message"] as? String))
                                        }
                                        
                                        completion(false, nil, (myDict["message"] as? String) ?? Message.something_went_wrong(),nil)
                                    }
                                }
                                catch(let err) {
                                    
                                    // IF ENCRYPTED RESOPONSE RECEIVED
                                    if responseJSON != "" {
                                        completion(true, nil, Message.something_went_wrong(),responseJSON)
                                        print("URL - \(self.base_url)\(endpoint.url)\nENCRYPTED RESPONSE:",responseJSON as Any)
                                    } else {
                                        print("URL - \(self.base_url)\(endpoint.url)\nERROR:",err.localizedDescription)
                                        completion(false, nil, Message.something_went_wrong(),nil)
                                    }
                                }
                            } else {
                                completion(false, nil, Message.something_went_wrong(),nil)
                            }
                            
                        } else {
                            completion(false, nil, Message.something_went_wrong(),nil)
                        }
                    }
                }
            }
        }
        
        // IF NOT GET METHOD
        else {
            
            print("************************************************************************************************")
            print("API call\nURL - \(url?.absoluteString ?? "")\nParameters - Normal - \((parameters ?? [:]).toJson() ?? "") || Encrypted - \(String(describing: encryptedRequest))\nHeader - \(String(describing: header))\nMethod - \(endpoint.method)")
            print("************************************************************************************************")
            
            AF.upload(param!, to: url!, method: endpoint.method, headers: header)
                .responseData { response in
                    
                    AlamofireAPICallManager.shared.header = nil
                    
                    view_for_progress_indicator?.hideProgressBar()
                    
                    // SUCCESS
                    if response.response?.statusCode == 200 {
                        if let responseData = response.data {
                            let json = String(data: responseData, encoding: String.Encoding.utf8)
                            let responseJSON = json
                            
                            print("URL - \(self.base_url)\(endpoint.url)\nJSON RESPONSE: \(responseJSON ?? "")\n")
                            
                            // IF NORMAL RESOPONSE RECEIVED
                            if let data = responseJSON?.data(using: String.Encoding.utf8) {
                                do {
                                    let object = try JSONDecoder().decode(decoder, from: data)
                                    print("URL - \(self.base_url)\(endpoint.url)\nNORMAL RESPONSE:",object)
                                    
                                    let dictData = (responseJSON ?? "").toDictionary()
                                    let message = dictData?["message"] as? String
                                    print("dictData", dictData as Any)
                                    if let status = dictData?["status"] as? Int, status == 200 {
                                        completion(true, object, message ?? "",nil)
                                    }
                                    else {
                                        completion(false, object, message ?? Message.something_went_wrong(),nil)
                                    }
                                }
                                catch(let err) {
                                    
                                    // IF ENCRYPTED RESOPONSE RECEIVED
                                    if responseJSON != "" {
                                        completion(true, nil, Message.something_went_wrong(),responseJSON)
                                        print("URL - \(self.base_url)\(endpoint.url)\nENCRYPTED RESPONSE:",responseJSON as Any)
                                    } else {
                                        print("URL - \(self.base_url)\(endpoint.url)\nERROR:",err.localizedDescription)
                                        completion(false, nil, Message.something_went_wrong(),nil)
                                    }
                                }
                            } else {
                                completion(false, nil, Message.something_went_wrong(),nil)
                            }
                        }
                    }
                    
                    // FAILURE
                    else {
                        
                        if let data = response.data {
                            let json = String(data: data, encoding: String.Encoding.utf8)
                            let responseJSON = json
                            
                            // IF NORMAL RESOPONSE RECEIVED
                            if let data = responseJSON?.data(using: String.Encoding.utf8) {
                                do {
                                    let object = try JSONDecoder().decode(decoder, from: data)
                                    let dictData = (responseJSON ?? "").toDictionary()
                                    let message = dictData?["message"] as? String
                                    
                                    let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                                    
                                    if let myDict = dictionary {
                                        print("************************************************************************************************")
                                        print("API call\nURL - \(apiUrl)\nResponse - \(myDict)")
                                        print("************************************************************************************************")
                                        
                                        if response.response?.statusCode == 401 && (endpoint != .login) && (endpoint != .signup) && (endpoint != .verify_otp) {
                                            BaseViewController().logoutUser(message: message)
                                        }
                                        
                                        completion(false, object, message ?? Message.something_went_wrong(),nil)
                                    }
                                }
                                catch(let err) {
                                    
                                    // IF ENCRYPTED RESOPONSE RECEIVED
                                    if responseJSON != "" {
                                        completion(true, nil, Message.something_went_wrong(),responseJSON)
                                        print("URL - \(self.base_url)\(endpoint.url)\nENCRYPTED RESPONSE:",responseJSON as Any)
                                    } else {
                                        print("URL - \(self.base_url)\(endpoint.url)\nERROR:",err.localizedDescription)
                                        completion(false, nil, Message.something_went_wrong(),nil)
                                    }
                                }
                            } else {
                                completion(false, nil, Message.something_went_wrong(),nil)
                            }
                        } else {
                            completion(false, nil, Message.something_went_wrong(),nil)
                        }
                    }
                }
        }
    }
    
    fileprivate func convertDictionaryToQueryString(_ parameters: [String: Any]) -> String {
        var queryItems: [URLQueryItem] = []
        
        for (key, value) in parameters {
            let stringValue = "\(value)"
            let queryItem = URLQueryItem(name: key, value: stringValue)
            queryItems.append(queryItem)
        }
        
        var components = URLComponents()
        components.queryItems = queryItems
        
        if let queryString = components.percentEncodedQuery {
            return queryString
        }
        
        return ""
    }
    
    
    fileprivate func upload<T: Codable>(
        decoder: T.Type,
        endpoint: Endpoint,
        method: HTTPMethod = .post,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        data: [FormDataMultipart],
        completion: @escaping (AFDataResponse<T>) -> Void
    ) {
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters ?? [:] {
                    if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
                for formItem in data {
                    multipartFormData.append(formItem.data, withName: formItem.name, fileName: formItem.fileName, mimeType: formItem.mimeType.rawValue)
                }
            },
            to: "\(self.base_url)\(endpoint.url)",
            method: endpoint.method,
            headers: headers
        )
        .validate().responseDecodable(completionHandler: completion)
    }
    
    /// To call multipart api (get, post, delete, put, connect, query, etc...) use this function and it will return status with data model
    func callMultipartApi<T: Codable>(
        decoder: T.Type,
        endpoint: Endpoint,
        method: HTTPMethod = .post,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        data: [FormDataMultipart],
        completion: @escaping (_ isSuccess: Bool, T?, _ errorMessage: String?) -> Void
    ) {
        
        AlamofireAPICallManager.shared.upload(decoder: decoder, endpoint: endpoint, data: data) { response in
            
            if response.response?.statusCode == 403 || response.response?.statusCode == 401 || response.response?.statusCode == 400 {
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    let response = json
                    var dictionary:NSDictionary?
                    if let data = response?.data(using: String.Encoding.utf8) {
                        do {
                            dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                            if let my_dict = dictionary {
                                completion(false, nil, (my_dict["message"] as? String) ?? Message.something_went_wrong())
                            }
                        } catch let error as NSError {
                            print("\nError : ",error,"\n")
                            completion(false, nil, Message.something_went_wrong())
                        }
                    } else {
                        completion(false, nil, Message.something_went_wrong())
                    }
                } else {
                    completion(false, nil, Message.something_went_wrong())
                }
            } else {
                if let responseData = response.data {
                    let json = String(data: responseData, encoding: String.Encoding.utf8)
                    let responseJson = json
                    
                    if let data = responseJson?.data(using: String.Encoding.utf8) {
                        do {
                            let object = try JSONDecoder().decode(decoder, from: data)
                            print("URL - \(self.base_url)\(endpoint.url)\nRESPONSE:",object)
                            completion(true, object, "")
                        }
                        catch(let err) {
                            print("URL - \(self.base_url)\(endpoint.url)\nERROR:",err.localizedDescription)
                            completion(false, nil, Message.something_went_wrong())
                        }
                    } else {
                        completion(false, nil, Message.something_went_wrong())
                    }
                }
            }
        }
    }
    
    fileprivate func createApiHeader(userDefinedHeader: [String : Any]?) -> HTTPHeaders {
        
        var api_header = HTTPHeaders()
        api_header.add(name: "Content-Type", value: "application/json")
        
        if UserDetailsModel.shared.token != "" {
            api_header.add(name: "token", value: "Bearer \(UserDetailsModel.shared.token)")
        }
        
        if let header = userDefinedHeader {
            let keys = Array(header.keys)
            for (_, key) in keys.enumerated() {
                api_header.add(name: key, value: userDefinedHeader?[key] as? String ?? "")
            }
            return api_header
        }
        return api_header
    }
    
    
    /// To disconnect all api request
    func disconnectAllApi() {
        AF.cancelAllRequests()
    }
    
}


/// This structure will used to create multipart object to upload data with multipart api
struct FormDataMultipart {
    var data: Data
    var name: String
    var fileName: String
    var mimeType: MimeType
}


/// This enum is containg almost all types of mime type which can used while to upload data to server with mutipart api
enum MimeType: String {
    case html = "text/html"
    case css = "text/css"
    case xml = "text/xml"
    case gif = "image/gif"
    case jpeg = "image/jpeg"
    case js = "application/javascript"
    case atom = "application/atom+xml"
    case rss = "application/rss+xml"
    case mml = "text/mathml"
    case txt = "text/plain"
    case jad = "text/vnd.sun.j2me.app-descriptor"
    case wml = "text/vnd.wap.wml"
    case htc = "text/x-component"
    case png = "image/png"
    case tif = "image/tiff"
    case wbmp = "image/vnd.wap.wbmp"
    case ico = "image/x-icon"
    case jng = "image/x-jng"
    case bmp = "image/x-ms-bmp"
    case svg_svgz = "image/svg+xml"
    case webp = "image/webp"
    case woff = "application/font-woff"
    case jar_war_war = "application/java-archive"
    case json = "application/json"
    case hqx = "application/mac-binhex40"
    case doc = "application/msword"
    case pdf = "application/pdf"
    case ps_eps_ai = "application/postscript"
    case rtf = "application/rtf"
    case m3u8 = "application/vnd.apple.mpegurl"
    case xls = "application/vnd.ms-excel"
    case eot = "application/vnd.ms-fontobject"
    case ppt = "application/vnd.ms-powerpoint"
    case wmlc = "application/vnd.wap.wmlc"
    case kml = "application/vnd.google-earth.kml+xml"
    case kmz = "application/vnd.google-earth.kmz"
    case seven_z = "application/x-7z-compressed"
    case cco = "application/x-cocoa"
    case jardiff = "application/x-java-archive-diff"
    case jnlp = "application/x-java-jnlp-file"
    case run = "application/x-makeself"
    case pl_pm = "application/x-perl"
    case prc_pdb = "application/x-pilot"
    case rar = "application/x-rar-compressed"
    case rpm = "application/x-redhat-package-manager"
    case sea = "application/x-sea"
    case swf = "application/x-shockwave-flash"
    case sit = "application/x-stuffit"
    case tcl_tk = "application/x-tcl"
    case der_pem_crt = "application/x-x509-ca-cert"
    case xpi = "application/x-xpinstall"
    case xhtml = "application/xhtml+xml"
    case xspf = "application/xspf+xml"
    case zip = "application/zip"
    case epub = "application/epub+zip"
    case docx = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    case xlsx = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    case pptx = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    case mid_midi_kar = "audio/midi"
    case mp3 = "audio/mpeg"
    case ogg = "audio/ogg"
    case m4a = "audio/x-m4a"
    case ra = "audio/x-realaudio"
    case tree_gpp_tree_gp = "video/3gpp"
    case ts = "video/mp2t"
    case mp4 = "video/mp4"
    case mpeg_mpg = "video/mpeg"
    case mov = "video/quicktime"
    case webm = "video/webm"
    case flv = "video/x-flv"
    case m4v = "video/x-m4v"
    case mng = "video/x-mng"
    case asx_asf = "video/x-ms-asf"
    case wmv = "video/x-ms-wmv"
    case avi = "video/x-msvideo"
}



extension AFError: Equatable {
    public static func == (lhs: AFError, rhs: AFError) -> Bool {
        return lhs.responseCode == rhs.responseCode
    }
}
