//
//  ImageLoader.swift
//  Stabl
//
//  Created by Mijin Cho on 02/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

import UIKit

@objc class ImageLoader:NSObject {
    var cache = NSCache()
    class var sharedLoader: ImageLoader {
        struct Singleton {
            static let instance = ImageLoader()
        }
        return Singleton.instance
    }
    
    // the sharedInstance class method can be reached from ObjC
    class func sharedInstance() -> ImageLoader {
        return ImageLoader.sharedLoader
    }
    /*
    class var sharedLoader:ImageLoader {
        struct Static
        {
             static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }*/
 
    
    func cachedImage(urlString: String) -> UIImage{
        
        let data: NSData? = self.cache.objectForKey(urlString) as? NSData
        
        let image = UIImage(data: data!)
          
        return image!
    
    }
    
    func imageForUrl(urlString: String, completionHandler:(image: UIImage?, url: String) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
            var data: NSData? = self.cache.objectForKey(urlString) as? NSData
            
            if let goodData = data {
                let image = UIImage(data: goodData)
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: image, url: urlString)
                })
                return
            }
            
            
            let endpoint : NSURL = NSURL(string: urlString)!
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithURL(endpoint) {
                (data:NSData?, response:NSURLResponse?, error:NSError?) in
                
                if (error != nil) {
                    completionHandler(image: nil, url: urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data!)
                    self.cache.setObject(data!, forKey: urlString)
                    dispatch_async(dispatch_get_main_queue(), {() in
                        completionHandler(image: image, url: urlString)
                    })
                    return
                }
            }
            
            task.resume()
            
            
        })
        
    }

}

/*
ImageLoader.sharedLoader.imageForUrl("", completionHandler:{(image: UIImage?, url: String) in
    self.myImage.image = image
})*/
