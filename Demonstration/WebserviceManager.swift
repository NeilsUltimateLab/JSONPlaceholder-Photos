//
//  WebserviceManager.swift
//  Demonstration
//
//  Created by Neil on 26/01/17.
//  Copyright © 2017 Neil's Ultimate Lab. All rights reserved.
//

import Foundation
import UIKit

class WebserviceManager: NSObject {
    
    let imageCache = NSCache<NSString, UIImage>()
    var url: String!
    
    func getImage(from url: String, for indexPath: IndexPath, completion:((UIImage)->())?) {
        let cacheKey = "\(indexPath.row)"
        self.url = url
        if let image = imageCache.object(forKey: cacheKey as NSString) {
            if url == self.url {
                completion?(image)
            }
        }else {
            if let url = URL(string: url) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if error != nil {
                        return
                    }
                    if let data = data {
                        if url.absoluteString == self.url {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.imageCache.setObject(image, forKey: cacheKey as NSString)
                                completion?(image)
                            }
                        }
                        }
                    }
                }).resume()
            }
        }
    }
    
    
    func callGetWebservice(for url: String, completion: (([Album])->())?) {
        var albums = [Album]()
        if let url = URL(string: url) {
            let urlRequest = URLRequest(url: url)
            URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if error != nil {
                    return
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        if let responseArray = json as? NSArray {
                            for responseDic in responseArray {
                                if let responses = responseDic as? NSDictionary {
            
                                    var album = Album()
                                    if let albumId = responses["albumId"] as? Int {
                                        album.albumId = albumId
                                    }
                                    if let id = responses["id"] as? Int {
                                        album.id = id
                                    }
                                    if let thumbUrl = responses["thumbnailUrl"] as? String {
                                        album.thumbnailUrl = thumbUrl
                                    }
                                    if let title = responses["title"] as? String {
                                        album.title = title
                                    }
                                    if let url = responses["url"] as? String {
                                        album.url = url
                                    }
                                    albums.append(album)
                                }
                            }
                            DispatchQueue.main.async {
                                completion?(albums)
                            }
                            
                        }
                        
                    } catch {
                        
                    }
                }
                
            }).resume()
        }
    }
    
    func callWebservice(for urlString: String, completionHandler: ((NSDictionary)->())?) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    return
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        if let responseDict = json as? NSDictionary {
                            DispatchQueue.main.async {
                                completionHandler?(responseDict)
                            }
                            
                        }
                        
                    }catch {}
                    
                }
            }).resume()
        }
    }
    
}
