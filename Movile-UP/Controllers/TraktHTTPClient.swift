//
//  TraktHTTPClient.swift
//  Movile-UP
//
//  Created by iOS on 7/22/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import Foundation
import Result
import Alamofire
import TraktModels

class TraktHTTPClient {
    
    private lazy var manager: Alamofire.Manager = {
        let configuration: NSURLSessionConfiguration = {
            var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    
            var headers = Alamofire.Manager.defaultHTTPHeaders
            headers["Accept-Encoding"] = "gzip"
            headers["Content-Type"] = "application/json"
            headers["trakt-api-version"] = "2"
            headers["trakt-api-key"] = "45914f927051fa175dc8e5feb57387eb32b37195ad56133e2cbc97c75562503d"
    
            configuration.HTTPAdditionalHeaders = headers
        
        return configuration
        }()
        
    return Manager(configuration: configuration)
    }()

    private enum Router: URLRequestConvertible {
        static let baseURLString = "https://api-v2launch.trakt.tv/"
        
        case Show(String)
        case Episode(String,Int,Int)
        
        // MARK: URLRequestConvertible
            var URLRequest: NSURLRequest {
                let (path: String, parameters: [String: AnyObject]?, method: Alamofire.Method) = {
                switch self {
                case .Show(let id):
                    return ("shows/\(id)", ["extended": "images,full"], .GET)
                case .Episode(let showId, let season, let episodeNumber):
                    return ("shows/\(showId)/seasons/\(season)/episodes/\(episodeNumber)", ["extended": "images,full"], .GET)
                }
                }()
                
                let URL = NSURL(string: Router.baseURLString)!
                let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
                URLRequest.HTTPMethod = method.rawValue
        
                let encoding = Alamofire.ParameterEncoding.URL
        
                return encoding.encode(URLRequest, parameters: parameters).0
            }
                
    }

    func getShow(id: String, completion: ((Result<Show, NSError?>) -> Void)?) {
            
        manager.request(Router.Show(id)).validate().responseJSON { (_, _, responseObject, error) -> Void in
            if let json = responseObject as? NSDictionary {
        
                if let show = Show.decode(json) {
                    completion?(Result.success(show))
                } else {
                    completion?(Result.failure(nil))
                }
        
            } else {
                completion?(Result.failure(error))
            }
        }
            
    }
    
    func getEpisode(showId: String, season: Int, episodeNumber: Int, completion: ((Result<Episode, NSError?>) -> Void)?) {
                    
        manager.request(Router.Episode(showId, season, episodeNumber)).validate().responseJSON { (_, _, responseObject, error)  in
            if let json = responseObject as? NSDictionary {
            
                if let episode = Episode.decode(json) {
                    completion?(Result.success(episode))
                } else {
                    completion?(Result.failure(nil))
                    }
                } else {
                    completion?(Result.failure(error))
                }
            }
    }
    
}













