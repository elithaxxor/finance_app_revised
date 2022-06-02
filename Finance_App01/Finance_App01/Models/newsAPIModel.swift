//
//  newsAPIModel.swift
//  Finance_App01
//
//  Created by a-robota on 6/2/22.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newsAPIModel = try? newJSONDecoder().decode(NewsAPIModel.self, from: jsonData)

//
// To read values from URLs:
//

import Foundation

// MARK: - NewsAPIModel
struct NewsAPIModel: Codable {
    var count: Int
    var nextURL: String
    var requestID: String
    var newsResults: [newsResults]
    var status: String

    enum CodingKeys: String, CodingKey {
        case count
        case nextURL
        case requestID
        case newsResults, status
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.resultTask(with: url) { result, response, error in
//     if let result = result {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Result
struct newsResults: Codable {
    var ampURL, articleURL: String
    var author, resultDescription, id: String
    var imageURL: String
    var keywords: [String]
    var publishedUTC: Date
    var publisher: Publisher
    var tickers: [String]
    var title: String

    enum CodingKeys: String, CodingKey {
        case ampURL
        case articleURL
        case author
        case resultDescription
        case id
        case imageURL
        case keywords
        case publishedUTC
        case publisher, tickers, title
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.publisherTask(with: url) { publisher, response, error in
//     if let publisher = publisher {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Publisher
struct Publisher: Codable {
    var faviconURL: String
    var homepageURL: String
    var logoURL: String
    var name: String

    enum CodingKeys: String, CodingKey {
        case faviconURL
        case homepageURL
        case logoURL
        case name
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func newsAPIModelTask(with url: URL, completionHandler: @escaping (NewsAPIModel?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
