// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
import UtilityBeltNetworking

/// A response with stubbed properties meant to mirror an HTTPResponse.
public struct StubResponse {
    // MARK: - Properties
    
    /// The raw data to be returned in the response.
    public var data: Data?
    
    /// The error to be returned in the response.
    public var error: Error?
    
    /// The status code of the response.
    public var statusCode: HTTPStatusCode
    
    /// A dictionary of headers to be returned in the response.
    public var headers: [String: String]
    
    // MARK: - Methods
    
    // MARK: Initializers
    
    /// Initializes a StubResponse.
    /// - Parameter data: The raw data to be returned in the response.
    /// - Parameter error: The error to be returned in the response.
    /// - Parameter statusCode: The status code of the response.
    /// - Parameter headers: A dictionary of headers to be returned in the response.
    public init(data: Data? = nil, error: Error? = nil, statusCode: HTTPStatusCode = .ok, headers: [String: String] = [:]) {
        self.data = data
        self.error = error
        self.statusCode = statusCode
        self.headers = headers
    }
}

// MARK: - Extensions

// MARK: - Codable

extension StubResponse: Codable {
    // TODO: Figure out how to encode the error object.
    enum Key: String, CodingKey {
        case data
        case statusCode
        case headers
    }
    
    /// Enables a StubResponse object to be encoded. This has been customized to handle not encoding the error property.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(self.data, forKey: .data)
        try container.encode(self.statusCode, forKey: .statusCode)
        try container.encode(self.headers, forKey: .headers)
    }
    
    /// Enables a StubResponse object to be decoded. This has been customized to handle not decoding the error property.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.data = try container.decode(Data.self, forKey: .data)
        self.statusCode = try container.decode(HTTPStatusCode.self, forKey: .statusCode)
        self.headers = try container.decode([String: String].self, forKey: .headers)
    }
}

// MARK: Static Convenience Initializers

public extension StubResponse {
    /// Initializes a StubResponse with raw data.
    /// - Parameter data: The raw data to be returned in the response.
    /// - Parameter statusCode: The status code of the response.
    /// - Parameter headers: A dictionary of headers to be returned in the response.
    static func data(_ data: Data, statusCode: HTTPStatusCode = .ok, headers: [String: String] = [:]) -> StubResponse {
        return self.init(data: data, statusCode: statusCode, headers: headers)
    }
    
    /// Initializes a StubResponse by encoding an Encodable Swift class into JSON data.
    /// - Parameter encodable: The Encodable Swift class to encode.
    /// - Parameter statusCode: The status code of the response.
    /// - Parameter headers: A dictionary of headers to be returned in the response.
    static func encodable<T>(_ encodable: T,
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
    
    /// Initializes a StubResponse with an error and no data.
    /// - Parameter error: The error to be returned in the response.
    /// - Parameter statusCode: The status code of the response. Defaults to `Internal Server Error` (`500`).
    /// - Parameter headers: A dictionary of headers to be returned in the response.
    static func error(_ error: Error, statusCode: HTTPStatusCode = .internalServerError, headers: [String: String] = [:]) -> StubResponse {
        return self.init(error: error, statusCode: statusCode, headers: headers)
    }
    
    /// Initializes a StubResponse without any data.
    /// - Parameter statusCode: The status code of the response.
    /// - Parameter headers: A dictionary of headers to be returned in the response.
    static func http(statusCode: HTTPStatusCode = .ok, headers: [String: String] = [:]) -> StubResponse {
        return self.init(statusCode: statusCode, headers: headers)
    }
    
    /// Initializes a StubResponse by getting data from the contents of a file relative to the source file path.
    /// - Parameter relativeFilePath: The path to the file, relative to the file of the class calling this method.
    /// - Parameter statusCode: The status code of the response.
    /// - Parameter headers: A dictionary of headers to be returned in the response.
    /// - Parameter sourceFile: The file of the class calling this method. Automatically populated.
    static func relativeFile(_ relativeFilePath: String,
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
    
    /// Initializes a StubResponse by getting data from the contents of a resource.
    /// - Parameter path: The path to the resource. May included subdirectories and file extensions.
    /// - Parameter fileExtension: The file extension for the resource. If this is included in `path`, this should not be passed in.
    /// - Parameter subdirectory: The bundle subdirectory for the resource. If this is included in `path`, this should not be passed in.
    /// - Parameter bundle: The resource bundle to get the resource from.
    /// - Parameter statusCode: The status code of the response.
    /// - Parameter headers: A dictionary of headers to be returned in the response.
    static func resource(_ path: String,
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
