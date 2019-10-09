// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import UtilityBeltNetworking

public struct StubResponse {
    public var data: Data?
    public var error: Error?
    public var statusCode: HTTPStatusCode = .ok
    public var headers: [String: String] = [:]

    public init(data: Data? = nil, error: Error? = nil, statusCode: HTTPStatusCode = .ok, headers: [String: String] = [:]) {
        self.data = data
        self.error = error
        self.statusCode = statusCode
        self.headers = headers
    }

    public static func data(_ data: Data, statusCode: HTTPStatusCode = .ok, headers: [String: String] = [:]) -> StubResponse {
        return self.init(data: data, statusCode: statusCode, headers: headers)
    }

    public static func encodable<T>(_ encodable: T,
                                    statusCode: HTTPStatusCode = .ok,
                                    headers: [String: String] = [:]) -> StubResponse where T: Encodable {
        do {
            let data = try JSONEncoder().encode(encodable)
            return self.init(data: data, statusCode: statusCode, headers: headers)
        } catch {
            assertionFailure("Unable to encode type \(String(describing: T.self)) for stubbing.")
            return self.init(data: nil, statusCode: statusCode, headers: headers)
        }
    }

    public static func error(_ error: Error, statusCode: HTTPStatusCode = .internalServerError, headers: [String: String] = [:]) -> StubResponse {
        return self.init(error: error, statusCode: statusCode, headers: headers)
    }

    public static func http(statusCode: HTTPStatusCode = .ok, headers: [String: String] = [:]) -> StubResponse {
        return self.init(statusCode: statusCode, headers: headers)
    }

    public static func relativeFile(_ relativeFilePath: String,
                                    statusCode: HTTPStatusCode = .ok,
                                    headers: [String: String] = [:],
                                    sourceFile: StaticString = #file) -> StubResponse {
        let sourceFileURL = URL(fileURLWithPath: "\(sourceFile)", isDirectory: false)
        let sourceFileDirectory = sourceFileURL.deletingLastPathComponent()
        let filePath = "\(sourceFileDirectory.path)/\(relativeFilePath)"

        // Verify that file exists at the relative path
        guard FileManager.default.fileExists(atPath: filePath) else {
            assertionFailure("Unable to find file: '\(filePath)'.")
            return self.init(data: nil, statusCode: statusCode, headers: headers)
        }

        let data = FileManager.default.contents(atPath: filePath)
        return self.init(data: data, statusCode: statusCode, headers: headers)
    }

    public static func resource(_ path: String,
                                fileExtension: String? = nil,
                                subdirectory: String? = nil,
                                bundle: Bundle? = nil,
                                statusCode: HTTPStatusCode = .ok,
                                headers: [String: String] = [:]) -> StubResponse {
        let bundle = bundle ?? MockService.shared.defaultBundle

        guard let resourceURL = bundle.url(forResource: path, withExtension: fileExtension, subdirectory: subdirectory) else {
            assertionFailure("Unable to find resource: '\(path)'.")
            return self.init(data: nil)
        }

        do {
            let data = try Data(contentsOf: resourceURL)
            return self.init(data: data, statusCode: statusCode, headers: headers)
        } catch {
            assertionFailure("Unable to get data from resource: '\(path)'.")
            return self.init(data: nil, statusCode: statusCode, headers: headers)
        }
    }
}
