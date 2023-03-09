//
//  APIManager.swift
//  FetchMeals
//
//  Created by Ayesha Shaikh on 3/7/23.
//

import Foundation
import UIKit
import Network

/**
 Possible errors for the API request
 */
enum APIError: Error {
    case invalidResponse
    case invalidData
    case invalidDecoding
    case invalidRequest
    case noInternetConnection
    
    var message: String {
        switch self {
        case .invalidResponse:
            return "Invalid response from Server"
        case .invalidData:
            return "Data is invalid"
        case .invalidDecoding:
            return "Erroe decoding the data"
        case .invalidRequest:
            return "The request is not valid"
        case .noInternetConnection:
            return "No internet connection"
        }
    }
}

/**
 Return urls
 */
struct EndPoint {
    let scheme = "https"
    let host = "themealdb.com"
    let pathPrefix = "/api/json/v1/1"
    
    func urlFor(category: String) -> URL? {
        let queryItems = [URLQueryItem(name: "c", value: category)]
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = "\(pathPrefix)/filter.php"
        components.queryItems = queryItems
        return components.url
    }
    
    func urlFor(recipe: String) -> URL? {
        let queryItems = [URLQueryItem(name: "i", value: recipe)]
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = "\(pathPrefix)/lookup.php"
        components.queryItems = queryItems
        return components.url
    }
}

/**
 Make network calls
 */
class APIManager {
    
    let monitor = NWPathMonitor()
    
    func fetch<T: Decodable>(from url: URL, of type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                completion(.failure(.noInternetConnection))
                return
            }
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalidRequest))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            if url.path.contains("lookup") {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    guard let json = json else {
                        completion(.failure(.invalidData))
                        return
                    }
                    completion(.success(Recipe(from: json) as! T))
                
                } catch {
                    completion(.failure(.invalidData))
                }

            } else {
                do {
                    let json = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(json))
            
                } catch {
                    completion(.failure(.invalidDecoding))
                }
            }
        }.resume()
    }
    
    func downloadImage(from url: String, completion: @escaping (Result<UIImage, APIError>) -> Void) {
        guard let imageUrl = URL(string: url) else {
            preconditionFailure("Url is not valid")
        }
        URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
            guard error == nil else {
                completion(.failure(.invalidRequest))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            if let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: url as NSString)
                completion(.success(image))
            }
        }).resume()
    }
}


