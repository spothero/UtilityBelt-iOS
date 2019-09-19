
import Foundation

public class ShamURLProtocol: URLProtocol {
    public enum Error: Swift.Error {
        case invalidRequestURL
        case noResponse
    }
    
    override public class func canInit(with task: URLSessionTask) -> Bool {
        return MockService.shared.canMockData(for: task.currentRequest?.url)
    }
    
    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override public func startLoading() {
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: ShamURLProtocol.Error.invalidRequestURL)
            return
        }
        
        let stubbedResponse = MockService.shared.getResponse(for: request.url)
        
        let httpResponse = HTTPURLResponse(url: url,
                                           statusCode: stubbedResponse?.statusCode.rawValue ?? 400,
                                           httpVersion: nil,
                                           headerFields: stubbedResponse?.headers)
        
        guard let response = httpResponse else {
            client?.urlProtocol(self, didFailWithError: ShamURLProtocol.Error.noResponse)
            return
        }
        
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let data = stubbedResponse?.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override public func stopLoading() {
        // This is called if the request gets canceled or completed.
    }
}
