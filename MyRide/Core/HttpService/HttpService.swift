//
//  HttpService.swift
//  MyRide
//
//  Created by Antony Alkmim on 01/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation

public enum TargetTypeTask {
    case request
    case upload(multipartFormData: MultipartFormData)
}

public protocol TargetType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var task: TargetTypeTask { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
    var sampleData: Data { get }
}

public extension TargetType {
    func urlRequest() -> URLRequest {
        
        // generate url
        let pathComponents = path.split(separator: "?")
        let pathQueries = pathComponents
            .dropFirst()
            .joined(separator: "?")
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let pathFormatted = String(pathComponents.first ?? "")
            .appending("?")
            .appending(pathQueries ?? "")
        
        guard let url = URLComponents(string: "\(baseURL.absoluteString)\(pathFormatted)")?.url else {
            fatalError("invalid URL")
        }
        
        var request = URLRequest(url: url)
        
        /// http method
        request.httpMethod = self.method.rawValue
        
        /// body
        if case let TargetTypeTask.upload(multipartFormData) = self.task {
            request.httpBody = multipartFormData.asData
            request.setValue("multipart/form-data; boundary=\(multipartFormData.boundary)", forHTTPHeaderField: "Content-Type")
        } else {
            request.httpBody = self.body
        }
        
        /// headers
        self.headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return request
    }
    
}

public enum Result {
    case failure(Error)
    case success(Data)
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol HttpServiceType: class {
    associatedtype Target: TargetType
    var session: URLSession { get }
    func request(_ endpoint: Target, responseData: @escaping (Result) -> Void) -> URLSessionDataTask?
}

public class HttpService<Target: TargetType>: HttpServiceType {
    
    private var requestClosure: (Target) -> URLRequest
    private var responseClosure: (HTTPURLResponse?, Data?) -> Void
    public let session: URLSession
    private var returnSampleData: Bool
    
    // MARK: - Initializer
    public init(urlSession: URLSession? = nil,
         requestClosure: @escaping ((Target) -> URLRequest) = { $0.urlRequest() },
         responseClosure: @escaping ((HTTPURLResponse?, Data?) -> Void) = { _, _ in },
         returnSampleData: Bool = false) {
        self.session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: HttpServiceSessionDelegate(),
            delegateQueue: nil
        )
        self.requestClosure = requestClosure
        self.returnSampleData = returnSampleData
        self.responseClosure = responseClosure
    }
    
    @discardableResult
    public func request(_ endpoint: Target, responseData: @escaping (Result) -> Void) -> URLSessionDataTask? {
        //1 - pass through interceptors
        let request = requestClosure(endpoint)
        
        //2 - execute task
        
        // sample data
        if returnSampleData {
            responseData(Result.success(endpoint.sampleData))
            return nil
        }
        
        // reachability
        if !Reachability.isConnectedToNetwork {
            responseData(Result.failure(HttpError.noInternetConnection))
            return nil
        }
        
        // real request
        let task = self.session.dataTask(with: request) { [weak self] data, response, error in
            
            if let err = error {
                responseData(Result.failure(HttpError.unknow(err)))
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            self?.responseClosure(httpResponse, data)
            
            guard let data = data else {
                responseData(Result.failure(HttpError.connectionError))
                return
            }
            responseData(Result.success(data))
        }
        task.resume()
        
        //3 - return task
        return task
    }
    
}

public class HttpServiceSessionDelegate: NSObject, URLSessionDelegate {
    
    public func urlSession(_ session: URLSession,
                           didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.previousFailureCount > 0 {
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        } else if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
        } else {
            print("unknown state. error: ")
        }
    }
}
