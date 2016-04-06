//
//  SMNetwork.swift
//  PinterestV2
//
//  Created by Syed Muaz on 06/04/2016.
//  Copyright © 2016 smuaz. All rights reserved.
//

import UIKit
import Foundation


class SMNetwork {
    
    let cache = NSCache()
    
    class var manager : SMNetwork {
        struct Static {
            static let instance : SMNetwork = SMNetwork()
            static var download : NSURLSessionDownloadTask?
        }
        return Static.instance
    }
    
    //Function to download JSON file
    
    func downloadJSONFile(urlString:String, completionHandler:(json: NSDictionary?)-> Void)
    {
        let requestURL: NSURL = NSURL(string: urlString)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        urlRequest.cachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    completionHandler(json: json as? NSDictionary)
         
                }catch {
                    print("Error with Json: \(error)")
                    
                }
                
            }
            
        }
        
        task.resume()
    }
    
    //Function to download XML file
    
    func downloadXMLFile(urlString:String, completionHandler:(xml: NSXMLParser?)-> Void)
    {
        let requestURL: NSURL = NSURL(string: urlString)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        urlRequest.cachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                let xml = NSXMLParser(data: data!)
                completionHandler(xml: xml)
            }
            
        }
        
        task.resume()
    }
    
    //Function to download image file

    func downloadImage(urlString: String, completionHandler:(image: UIImage?, url: String) -> ()) {
        let session = NSURLSession.sharedSession()
        
        let data: NSData? = self.cache.objectForKey(urlString) as? NSData
        
        if let goodData = data {
            let image = UIImage(data: goodData)
            dispatch_async(dispatch_get_main_queue(), {() in
                completionHandler(image: image, url: urlString)
            })
            return
        }
        
        let task = session.dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                if (error != nil) {
                    dispatch_async(dispatch_get_main_queue(), {() in
                        completionHandler(image: nil, url: urlString)
                    })
                    return
                }
                
                if let data = data {
                    let image = UIImage(data: data)
                    self.cache.setObject(data, forKey: urlString)
                    dispatch_async(dispatch_get_main_queue(), {() in
                        completionHandler(image: image, url: urlString)
                    })
                    return
                }
            }
        })
        task.resume()
        

    }
    

    
    
}
