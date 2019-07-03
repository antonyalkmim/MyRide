//
//  HttpError.swift
//  MyRide
//
//  Created by Antony Alkmim on 01/07/19.
//  Copyright © 2019 Antony Alkmim. All rights reserved.
//

import Foundation

enum HttpError: Swift.Error {
    case unknow(Error)
    case jsonMapping(Error?)
    case noInternetConnection
    case connectionError
    case unauthorized
}

extension HttpError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noInternetConnection: return L10n.HttpError.noInternetConnection
        case .jsonMapping: return L10n.HttpError.jsonMapping
        case .connectionError: return L10n.HttpError.connectionError
        case .unauthorized: return L10n.HttpError.unauthorized
        case .unknow: return L10n.HttpError.unknow
        }
    }
}
