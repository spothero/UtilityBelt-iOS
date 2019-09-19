
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
        
        let response: HTTPURLResponse?
        let data = MockService.shared.getData(for: request.url)
        
        if data != nil {
            response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        } else {
            response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        }
        
        guard let unwrappedResponse = response else {
            client?.urlProtocol(self, didFailWithError: ShamURLProtocol.Error.noResponse)
            return
        }
        
        client?.urlProtocol(self, didReceive: unwrappedResponse, cacheStoragePolicy: .notAllowed)
        
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override public func stopLoading() {
        // This is called if the request gets canceled or completed.
    }
}
