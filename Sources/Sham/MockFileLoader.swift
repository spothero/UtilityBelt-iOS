// Copyright © 2019 SpotHero, Inc. All rights reserved.

//// Copyright © 2019 SpotHero, Inc. All rights reserved.
//
// import Foundation
//
// public class MockFileLoader {
//    // MARK: - Enums
//
//    public enum MockFileError: Error, LocalizedError {
//        case invaldURL(_ url: URL)
//        case unableToParseURL(_ urlString: String)
//        case pathNotFound(_ url: URL)
//        case resourceNotFound(_ path: String)
//        case routeNotFound
//
//        public var errorDescription: String? {
//            switch self {
//            case let .unableToParseURL(urlString):
//                return "Unable to parse '\(urlString)' into URL."
//            case let .invaldURL(url):
//                return "Invalid URL '\(url.absoluteString)'."
//            case let .pathNotFound(url):
//                return "Path not found in URL '\(url.absoluteString)'."
//            case let .resourceNotFound(path):
//                return "Resource not found at path '\(path)'."
//            case .routeNotFound:
//                return "Route not found."
//            }
//        }
//    }
//
//    // MARK: - Static Instance
//
//    public static let shared = MockFileLoader()
//
//    // MARK: - Properties
//
//    private static let defaultFileExtension = "json"
//    private static let defaultSubdirectory = "Data/spots"
//    private static let baseURL = URL(string: "https://spothero.local")!
//
//    // MARK: - Methods
//
//    // MARK: Initializers
//
//    private init() {}
//
//    // MARK: Loading
//
//    public func load(fromURLString urlString: String) throws -> Data? {
//        // Attempt to convert the string into a URL
//        guard let url = URL(string: urlString) else {
//            throw MockFileError.unableToParseURL(urlString)
//        }
//
//        return try self.load(fromURL: url)
//    }
//
//    public func load(fromURL url: URL) throws -> Data? {
//        // If there is a scheme and host, we need to evaluate it
//        guard let scheme = url.scheme, let host = url.host else {
//            // If there's no scheme and no host, attempt to load based on the path
//            // If the path is empty, it will still be evaluated properly.
//            return try self.load(fromRoute: url.path)
//        }
//
//        // Ensure that the incoming url matches the base cache URL
//        guard scheme == MockFileLoader.baseURL.scheme, host == MockFileLoader.baseURL.host else {
//            throw MockFileError.invaldURL(url)
//        }
//
//        do {
//            return try self.load(fromRoute: url.path)
//        } catch MockFileError.routeNotFound {
//            throw MockFileError.pathNotFound(url)
//        } catch {
//            throw error
//        }
//    }
//
//    public func load(fromRoute route: String?) throws -> Data? {
//        // Trim any leading or trailing slashes from the route and ensure it isn't nil or empty
//        guard var route = route?.trimmingCharacters(in: .init(charactersIn: "/")), !route.isEmpty else {
//            throw MockFileError.routeNotFound
//        }
//
//        // Convert any slashes in the route into underscores
//        route = route.replacingOccurrences(of: "/", with: "_")
//
//        return try self.load(fromResourcePath: route, withExtension: MockFileLoader.defaultFileExtension, subdirectory: MockFileLoader.defaultSubdirectory)
//    }
//
//    private func load(fromResourcePath path: String, withExtension fileExtension: String? = nil, subdirectory: String? = nil) throws -> Data {
//        // Attempt to get the resource URL for the JSON file that matches the route
//        guard let resourceURL = Bundle(for: type(of: self)).url(forResource: path, withExtension: fileExtension, subdirectory: subdirectory) else {
//            var fullPath = ""
//
//            // If subdirectory was passed in, add it to the full path
//            if let subdirectory = subdirectory {
//                fullPath += "\(subdirectory)/"
//            }
//
//            // Add the path
//            fullPath += path
//
//            // If the fileExtension was passed in, add it to the full path
//            if let fileExtension = fileExtension {
//                fullPath += ".\(fileExtension)"
//            }
//
//            throw MockFileError.resourceNotFound(fullPath)
//        }
//
//        return try Data(contentsOf: resourceURL)
//    }
// }
