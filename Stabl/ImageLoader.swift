//
//  ImageLoader.swift
//  Stabl
//
//  Created by Mijin Cho on 02/01/2016.
//  Copyright © 2016 Mijin Cho. All rights reserved.
//

import UIKit

@objc class ImageLoader:NSObject {
    var cache = NSCache<AnyObject, AnyObject>()
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
 
    
    func cachedImage(_ urlString: String) -> UIImage{
        
        let data: Data? = self.cache.object(forKey: urlString as AnyObject) as? Data
        
        let image = UIImage(data: data!)
          
        return image!
    
    }
    
    func imageForUrl(_ urlString: String, completionHandler:@escaping (_ image: UIImage?, _ url: String) -> ()) {
        
        
        DispatchQueue.global().async {
            var data: NSData? = self.cache.object(forKey: urlString as AnyObject) as? NSData
            
            if let goodData = data {
                let image = UIImage(data: goodData as Data)
                
                DispatchQueue.main.async {
                    
                    completionHandler(image, urlString)
                    
                }
                return
            }
            
            
            let endpoint : NSURL = NSURL(string: urlString)!
            let session = URLSession.shared
            
            
            let task = session.dataTask(with: endpoint as URL) { data, response, error in
                if (error != nil) {
                    completionHandler(nil, urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data!)
                    self.cache.setObject(data! as AnyObject, forKey: urlString as AnyObject)
                    DispatchQueue.main.async {
                        
                        completionHandler(image, urlString)
                        
                    }
                    return
                }
            }
            
          
            
            task.resume()
        }
       
        
    }

}

/*
ImageLoader.sharedLoader.imageForUrl("", completionHandler:{(image: UIImage?, url: String) in
    self.myImage.image = image
})*/
