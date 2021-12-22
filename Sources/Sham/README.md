# Sham (SpotHero API Mocker)
Sham is a library that can be used to mock HTTP requests and provides multiple ways to return custom API responses such as through local JSON files or custom `Encodable` types.

# Usage

## Introduction
The core of Sham is made up of two parts, a custom `URLProtocol` called `MockURLProtocol` and a `MockService` to help facilitate storage and retrieval of mocked network requests.

**MockURLProtocol** 
`MockURLProtocol` is a subclass of `[URLProtocol](https://developer.apple.com/documentation/foundation/urlprotocol)` and works by overriding `URLProtocol` methods `canInit(with task: URLSessionTask)` and `canInit(with request: URLRequest)` in order to check with the `MockService` to see if the given URLs have been mocked.   

Later, when `URLProtocol.startLoading()` is invoked, `MockURLProtocol` will then retrieve the mocked data from the `MockService` and provide it to the client.

**MockService**
The `MockService` is a singleton that provides access to a repository of mocked network requests. The `MockURLProtocol` subclass will talk to the `MockService` to match outgoing network requests with mocked responses, which can be set by calling `MockService.shared.stubbedDataCollection.stub(_:with:)`.

### Configuring A URLSession For Mocking
To begin mocking network requests, you'll need to register `MockURLProtocol` into your URL loading system. There are a couple ways to do this depending on your setup.

#### Configuring Individual URLSessions
In order to register `MockURLProtocol` for individual `URLSession`s, you'll need to create a custom `URLSessionConfiguration` and add the `MockURLProtocol` to the configuration's `protocolClasses` property.

```swift
let configuration: URLSessionConfiguration = .default
configuration.protocolClasses = [MockURLProtocol.self]
let urlSession = URLSession(configuration: configuration)
```

Public convenience extensions are provided on both `URLSession` and `URLSessionConfiguration` which provide a static `mocked` property that is preconfigured with the `MockURLProtocol`.

#### Configuring Globally
To register `MockURLProtocol` globally, you can use the following line:
```swift
URLProtocol.registerClass(MockURLProtocol.self)
``` 

## Mocking Individual Network Requests
The `StubbedDataCollection` class is the container for all your mocked network requests and can be accessed through the `MockService` by calling `MockService.shared.stubbedDataCollection`.

Mocking requests starts with a call to the `stub(_ request: StubRequest, with response: StubResponse)` method on `StubbedDataCollection`. As you'll see, there are two parts necessary to mocking requests, a `StubRequest` and a `StubResponse`.

### StubRequest
`StubRequest` is a class meant to mirror an outgoing HTTP request. When an outgoing request is detected, Sham will attempt to match this with a `StubRequest` and, if one is found, will mock the request with a paired `StubResponse`.

The most common way to initialize a new `StubRequest` will be through the `init(method: HTTPMethod, url: URLConvertible, queryMatchRule: QueryMatchRule)` method. As an example, the following would create a new `StubRequest` that would match any outgoing GET request made to the endpoint `"https://mycompany.com/api/v1/users/1"`:

```swift
let stubRequest = StubRequest(
    method: .get,
    url: "https://mycompany.com/api/v1/users/1"
)
```

### StubResponse 
`StubResponse` is a class meant to mirror an incoming HTTP response. Each `StubResponse` will be paired with a `StubRequest` and returned when an outgoing network request matches a `StubResponse`.

There are several ways to initialize a new `StubResponse` depending on how you'd like to provide the data.

#### Using JSON Files
To provide response data from JSON files there are a couple convenience methods provided.

The first option, `StubResponse.relativeFile(_:)`, takes a relative file path:
```swift
let stubResponse = StubResponse.relativeFile("./response.json")
```

The second option, `StubResponse.resource(_)`, takes a path resource and information about where that resource can be found. This can be useful if you store your mock data files in a separate Bundle:  
```swift
let stubResponse = StubResponse.resource(
    "MyMockData/response",
    fileExtension: "json",
    bundle: .myMockDataBundle
)
```

#### Using Encodable Objects
If you have objects conforming to the `Encodable` protocol, they can be used to mock a network response by using the `StubResponse.encodable(_:)` method:
```swift
let user = User(id: 1) // Conforms to Encodable
let stubResponse = StubResponse.encodable(user)
``` 

#### Using Raw Data
If you need to simulate a raw data response, you can use `StubResponse.data(_:)` method:
```swift
let data = Data()
let stubResponse = StubResponse.data(data)
```

#### Providing Empty Responses
If you're mocking a network request and expect an empty response, you can use the `StubResponse.http()` method:
```swift
let stubResponse = StubResponse.http(statusCode: .noContent)
```


