//
//  RequestManager.swift
//  WaveForm
//
//  Created by Doctor Kocte on 5.06.23.
//

import Alamofire
import Foundation

public typealias RequestManagerResult<T: Decodable> = Result<T, Error>
public typealias ParameterEncoding = Alamofire.ParameterEncoding

// swiftlint:disable all
protocol RequestManagerProtocol: AnyObject {
    func upload(url: URL, completion: @escaping (String) -> Void)
    func downloadImage(url: URL, completion: @escaping (String) -> Void)
}

public enum Task {
    case requestPlain
    
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)

    case requestCompositeData(bodyData: Data, urlParameters: [String: Any])
}

public enum RequestMethod: HTTPMethod.RawValue {
    case get
    case post
    case put
    case delete
}

//enum BaseURLs {
//    case users
//
//    var getURL: String {
//        switch self {
//        case .users:
//            return "https://super-mybg.onrender.com/auth/users"
//        }
//    }
//}

public protocol TargetType {
    var baseURL: URL { get }

    var method: RequestMethod { get }

    var task: Task { get }

    var headers: [String: String]? { get }
}

struct BaseTargetType: TargetType {
    var baseURL: URL
    var method: RequestMethod
    var task: Task
    var headers: [String: String]?
}

final class RequestManager: RequestManagerProtocol {
    private let decoder = JSONDecoder()
    
    private func httpMethod(method: RequestMethod) -> HTTPMethod {
        switch method {
        case .get:
            return HTTPMethod.get

        case .post:
            return HTTPMethod.post

        case .put:
            return HTTPMethod.put

        case .delete:
            return HTTPMethod.delete
        }
    }
    
    func request<ResultType: Decodable>(
        baseURL: String,
        headers: HTTPHeaders? = nil,
        parameters: [String: Any]? = nil,
        body: [String: Any]? = [:],
        method: RequestMethod,
        encoding: ParameterEncoding = URLEncoding.default,
        completion: @escaping (Result<ResultType, UIError>) -> Void
    ) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(UIError.wrongUrl))
            return
        }
        
        var task = Task.requestPlain

        if let parameters = parameters, !parameters.isEmpty {
            task = Task.requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }

        if
            let body = body, !body.isEmpty,
            let theJSONData = try? JSONSerialization.data(withJSONObject: body, options: []) {
            task = Task.requestCompositeData(bodyData: theJSONData, urlParameters: parameters ?? [:])
        }
                
        let request = AF.request(
            url,
            method: httpMethod(method: method),
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )

        request.response { response in
            do {
                guard let data = response.data else {
                    completion(.failure(.noData))
                    return
                }
                let result = try self.decoder.decode(ResultType.self, from: data)
                
                if let wrappedSuccessResult = try? self.decoder.decode(SuccessResponseDTO.self, from: data) {
                    if wrappedSuccessResult.success {
                        DispatchQueue.main.async {
                            completion(.success(result))
                        }
                    } else {
                        completion(.failure(.unknown))
                    }
                }
            } catch {
                completion(.failure(.notParsableData))
            }
        }
    }
    
    func downloadImage(url: URL, completion: @escaping (String) -> Void) {
        guard let folder = try? FileManager.default
            .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("images")
        else {
            completion(UIError.wrongUrl.description)
            return
        }
        
        let destination: DownloadRequest.Destination = { _, _ in
            let fileURL = folder.appendingPathComponent(url.lastPathComponent)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(url, to: destination).response { responseData in
            switch responseData.result {
            case .success(let value):
                guard let imagePath = value?.path else {
                    completion(UIError.emptyPath.description)
                    return
                }
                completion(imagePath)
                
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func upload(url: URL, completion: @escaping (String) -> Void) {
        let image = UIImage(named: "image")!
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        AF.upload(
            multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            },
            to: "https://httpbin.org/anything",
            method: .post
        ).uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
        }
        .responseJSON { response in
            print(response)
            guard let error = response.error else {
                completion("success upload")
                return
            }
            completion(error.localizedDescription)
        }
    }
}

