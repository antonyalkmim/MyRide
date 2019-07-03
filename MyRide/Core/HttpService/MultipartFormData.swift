//
//  MultipartFormData.swift
//  MyRide
//
//  Created by Antony Alkmim on 01/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation

public struct MultipartFormData {
    let name: String
    let mimeType: String
    let filename: String
    let params: [String: Any]
    let fileData: Data?
    
    let boundary = "Boundary-\(UUID().uuidString)"
    
    var asData: Data? {
        return createBodyWithParameters(parameters: params,
                                        boundary: boundary,
                                        fileData: fileData,
                                        filePath: name)
    }
    
    private func createBodyWithParameters(parameters: [String: Any],
                                          boundary: String,
                                          fileData: Data?,
                                          filePath: String = "tmpfile") -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        if let fileData = fileData {
            let filename = "file.jpg"
            let mimetype = "image/jpg"
            
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(filePath)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            body.append(fileData)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        
        return body
    }
}

public extension Data {
    mutating func append(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true) ?? Data()
        append(data)
    }
}
