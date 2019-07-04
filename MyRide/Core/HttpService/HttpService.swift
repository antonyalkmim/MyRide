//
//  HttpService.swift
//  MyRide
//
//  Created by Antony Alkmim on 01/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation

enum TargetTypeTask {
    case requestPlain
}

protocol TargetType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var task: TargetTypeTask { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
    var sampleData: Data { get }
}

extension TargetType {
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
        
        /// request body
        request.httpBody = self.body
        
        /// headers
        self.headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return request
    }
    
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol HttpServiceType: class {
    associatedtype Target: TargetType
    var session: URLSession { get }
    func request(_ endpoint: Target, responseData: @escaping (Result<Data, HttpError>) -> Void) -> URLSessionDataTask?
}

class HttpService<Target: TargetType>: HttpServiceType {
    
    typealias RequestClosure = (Target) -> URLRequest
    typealias ResponseClosure = (HTTPURLResponse?, Data?) -> Void
    
    private var requestClosure: RequestClosure
    private var responseClosure: ResponseClosure
    public let session: URLSession
    private var returnSampleData: Bool
    
    // MARK: - Initializer
    
    init(urlSession: URLSession? = nil,
         requestClosure: @escaping RequestClosure = { $0.urlRequest() },
         responseClosure: @escaping ResponseClosure = { _, _ in },
         returnSampleData: Bool = false) {
        
        self.session = urlSession ?? URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: HttpServiceSessionDelegate(),
            delegateQueue: nil
        )
        self.requestClosure = requestClosure
        self.returnSampleData = returnSampleData
        self.responseClosure = responseClosure
    }
    
    @discardableResult
    func request(_ endpoint: Target, responseData: @escaping (Result<Data, HttpError>) -> Void) -> URLSessionDataTask? {
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

// MARK: - SSL Pinning

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
