// Copyright © 2021 SpotHero, Inc. All rights reserved.

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
    
    /// The mime type of the response
    public var mimeType: MimeType?
    
    // MARK: - Methods
    
    // MARK: Initializers
    
    /// Initializes a StubResponse.
    /// - Parameter data: The raw data to be returned in the response.
    /// - Parameter error: The error to be returned in the response.
    /// - Parameter statusCode: The status code of the response.
    /// - Parameter headers: A dictionary of headers to be returned in the response.
    /// - Parameter mimeType: The mime type of the response
    public init(data: Data? = nil,
                error: Error? = nil,
                statusCode: HTTPStatusCode = .ok,
                headers: [String: String] = [:],
                mimeType: MimeType? = nil) {
        self.data = data
        self.error = error
        self.statusCode = statusCode
        self.headers = headers
        self.mimeType = mimeType
    }
}

// MARK: - Extensions

// MARK: - Codable

extension StubResponse: Codable {
    // TODO: Figure out how to encode the error object.
    private enum CodingKeys: String, CodingKey {
        case data
        case headers
        case mimeType
        case statusCode
    }
    
    /// Enables a StubResponse object to be encoded. This has been customized to handle not encoding the error property.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.data, forKey: .data)
        try container.encode(self.headers, forKey: .headers)
        try container.encodeIfPresent(self.mimeType, forKey: .mimeType)
        try container.encode(self.statusCode, forKey: .statusCode)
    }
    
    /// Enables a StubResponse object to be decoded. This has been customized to handle not decoding the error property.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent(Data.self, forKey: .data)
        self.headers = try container.decode([String: String].self, forKey: .headers)
        self.mimeType = try container.decodeIfPresent(MimeType.self, forKey: .mimeType)
        self.statusCode = try container.decode(HTTPStatusCode.self, forKey: .statusCode)
    }
}

// MARK: Static Convenience Initializers

public extension StubResponse {
    /// Initializes a StubResponse with raw data.
    /// - Parameter data: The raw data to be returned in the response.
    /// - Parameter statusCode: The status code of the response.
    /// - Parameter headers: A dictionary of headers to be returned in the response.
    /// - Parameter mimeType: The mime type of the response
    static func data(_ data: Data,
                     statusCode: HTTPStatusCode = .ok,
                     headers: [String: String] = [:],
                     mimeType: MimeType? = nil) -> StubResponse {
        return self.init(data: data, statusCode: statusCode, headers: headers, mimeType: mimeType)
    }
    
    /// Initializes a StubResponse by encoding an Encodable Swift class into JSON data.
    /// - Parameter encodable: The Encodable Swift class to encode.
    /// - Parameter statusCode: The status code of the response.
    /// - Parameter headers: A dictionary of headers to be returned in the response.
    /// - Parameter mimeType: The mime type of the response
    static func encodable<T>(_ encodable: T,
                             statusCode: HTTPStatusCode = .ok,
                             headers: [String: String] = [:],
                             mimeType: MimeType? = .json) -> StubResponse where T: Encodable {
        do {
            let data = try JSONEncoder().encode(encodable)
            return self.init(data: data, statusCode: statusCode, headers: headers, mimeType: mimeType)
        } catch {
            assertionFailure("Unable to encode type \(String(describing: T.self)) for stubbing.")
            return self.init(data: nil, statusCode: statusCode, headers: headers, mimeType: mimeType)
        }
    }
    
    /// Initializes a StubResponse with an error and no data.
    /// - Parameter error: The error to be returned in the response.
    /// - Parameter statusCode: The status code of the response. Defaults to `Internal Server Error` (`500`).
    /// - Parameter headers: A dictionary of headers to be returned in the response.
    /// - Parameter mimeType: The mime type of the response
    static func error(_ error: Error,
                      statusCode: HTTPStatusCode = .internalServerError,
                      headers: [String: String] = [:],
                      mimeType: MimeType? = nil) -> StubResponse {
        return self.init(error: error, statusCode: statusCode, headers: headers, mimeType: mimeType)
    }
    
    /// Initializes a StubResponse without any data.
    /// - Parameter statusCode: The status code of the response.
    /// - Parameter headers: A dictionary of headers to be returned in the response.
    /// - Parameter mimeType: The mime type of the response
    static func http(statusCode: HTTPStatusCode = .ok,
                     headers: [String: String] = [:],
                     mimeType: MimeType? = nil) -> StubResponse {
        return self.init(statusCode: statusCode, headers: headers, mimeType: mimeType)
    }
    
    /// Initializes a StubResponse by getting data from the contents of a file relative to the source file path.
    /// - Parameter relativeFilePath: The path to the file, relative to the file of the class calling this method.
    /// - Parameter statusCode: The status code of the response.
    /// - Parameter headers: A dictionary of headers to be returned in the response.
    /// - Parameter sourceFile: The file of the class calling this method. Automatically populated.
    static func relativeFile(_ relativeFilePath: String,
                             statusCode: HTTPStatusCode = .ok,
                             headers: [String: String] = [:],
                             mimeType: MimeType? = nil,
                             sourceFile: StaticString = #file) -> StubResponse {
        let sourceFileURL = URL(fileURLWithPath: "\(sourceFile)", isDirectory: false)
        let sourceFileDirectory = sourceFileURL.deletingLastPathComponent()
        let filePath = "\(sourceFileDirectory.path)/\(relativeFilePath)"
        
        // Verify that file exists at the relative path
        guard FileManager.default.fileExists(atPath: filePath) else {
            assertionFailure("Unable to find file: '\(filePath)'.")
            return self.init(data: nil, statusCode: statusCode, headers: headers, mimeType: mimeType)
        }
        
        let data = FileManager.default.contents(atPath: filePath)
        return self.init(data: data, statusCode: statusCode, headers: headers, mimeType: mimeType)
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
                         headers: [String: String] = [:],
                         mimeType: MimeType? = nil) -> StubResponse {
        let bundle = bundle ?? MockService.shared.defaultBundle
        
        guard let resourceURL = bundle.url(forResource: path, withExtension: fileExtension, subdirectory: subdirectory) else {
            assertionFailure("Unable to find resource: '\(path)'.")
            return self.init(data: nil)
        }
        
        do {
            let data = try Data(contentsOf: resourceURL)
            return self.init(data: data, statusCode: statusCode, headers: headers, mimeType: mimeType)
        } catch {
            assertionFailure("Unable to get data from resource: '\(path)'.")
            return self.init(data: nil, statusCode: statusCode, headers: headers, mimeType: mimeType)
        }
    }
}
