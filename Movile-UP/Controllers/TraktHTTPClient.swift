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
        case PopularShows
        case Seasons(String)
        case Episodes(String,Int)
        
        // MARK: URLRequestConvertible
            var URLRequest: NSURLRequest {
                let (path: String, parameters: [String: AnyObject]?, method: Alamofire.Method) = {
                switch self {
                case .Show(let id):
                    return ("shows/\(id)", ["extended": "images,full"], .GET)
                case .Episode(let showId, let season, let episodeNumber):
                    return ("shows/\(showId)/seasons/\(season)/episodes/\(episodeNumber)", ["extended": "images,full"], .GET)
                case .PopularShows:
                    return ("shows/popular", ["limit": 50, "extended": "images"], .GET)
                case .Seasons(let showId):
                    return("shows/\(showId)/seasons", ["extended": "images,full"], .GET)
                case .Episodes(let showId, let season):
                    return("shows/\(showId)/seasons/\(season)", ["extended": "images,full"], .GET)
                }
                }()
                
                let URL = NSURL(string: Router.baseURLString)!
                let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
                URLRequest.HTTPMethod = method.rawValue
        
                let encoding = Alamofire.ParameterEncoding.URL
        
                return encoding.encode(URLRequest, parameters: parameters).0
            }
                
    }
    
    private func getJSONElement<T: JSONDecodable>(router: Router, completion: ((Result<T, NSError?>) -> Void)?) {
        
        manager.request(router).validate().responseJSON { (_, _, responseObject, error)  in
        
            if let json = responseObject as? NSDictionary {
        
                if let value = T.decode(json) {
                    completion?(Result.success(value))
                } else {
                    completion?(Result.failure(nil))
                }
                } else {
                    completion?(Result.failure(error))
                }
        }
    }

    func getShow(id: String, completion: ((Result<Show, NSError?>) -> Void)?) {
                    
        getJSONElement(Router.Show(id), completion: completion)
    
    }
    
    func getShowOld(id: String, completion: ((Result<Show, NSError?>) -> Void)?) {
            
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
        
        //let router = Router.Episode(showId, season, episodeNumber)
        getJSONElement(Router.Episode(showId, season, episodeNumber), completion: completion)
        
    }
    
    func getEpisodeOld(showId: String, season: Int, episodeNumber: Int, completion: ((Result<Episode, NSError?>) -> Void)?) {
                    
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
    
    func getPopularShows(completion: ((Result<[Show], NSError?>) -> Void)?) {
        
        getJSONElement(Router.PopularShows, completion: completion)
        manager.request(Router.PopularShows).validate().responseJSON { (_,_, responseObject, error) in
                
            var result: [Show] = []
            if let json = responseObject as? NSDictionary {
                
                for show in json {
                    if let show = Show.decode(json) {
                        result.append(show)
                    } else {
                        completion?(Result.failure(nil))
                    }
                }
                
            } else {
                completion?(Result.failure(error))
            }
            
            completion?(Result.success(result))
        }
    }
    
    func getSeasons(showId: String, completion: ((Result<[Season], NSError?>) -> Void)?) {
    
        manager.request(Router.Seasons(showId)).validate().responseJSON { (_,_, responseObject, error) in
                        
            var result: [Season] = []
            if let json = responseObject as? NSDictionary {
                            
                for show in json {
                    if let show = Season.decode(json) {
                        result.append(show)
                    } else {
                        completion?(Result.failure(nil))
                    }
                }
                            
            } else {
                completion?(Result.failure(error))
            }
                        
            completion?(Result.success(result))
        }
                    
    }
    
    func getEpisodes(showId: String, season: Int, completion: ((Result<[Episode], NSError?>) -> Void)?) {

        manager.request(Router.Episodes(showId, season)).validate().responseJSON { (_,_, responseObject, error) in
            
            var result: [Episode] = []
            if let json = responseObject as? NSDictionary {
                
                for show in json {
                    if let show = Episode.decode(json) {
                        result.append(show)
                    } else {
                        completion?(Result.failure(nil))
                    }
                }
                
            } else {
                completion?(Result.failure(error))
            }
            
            completion?(Result.success(result))
        }
        

    }
    
}













