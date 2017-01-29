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
    
    
    func callWebservice(for urlString: String, completionHandler: ((AnyObject)->())?) {
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
                        else if let responseDict = json as? NSArray {
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
