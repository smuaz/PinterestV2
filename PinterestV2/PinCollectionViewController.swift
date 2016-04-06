//
//  PinCollectionViewController.swift
//  PinterestV2
//
//  Created by Syed Muaz on 06/04/2016.
//  Copyright © 2016 smuaz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "pinCell"

class PinCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var pinArray = [Pin]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.redColor(), NSFontAttributeName: UIFont(name: "Zapfino", size: 20.0)! ]

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        SMNetwork.manager.downloadJSONFile("https://api.pinterest.com/v3/pidgets/boards/designquixotic/vintage-luggage/pins/") { (json) in
            print(json)
            
            let data = json!["data"]!            
            let pins = data["pins"]!
            
            for i in 0..<pins!.count {
                var caption: String?
                var imageStr: String?
                
                if let item = pins![i] as? [String: AnyObject] {
                    let desc = item["description"] as? String
                    caption = "\(desc!)"
                    if let image = item["images"] as? [String: AnyObject] {
                        if let sizing = image["237x"] as? [String: AnyObject] {
                            let url = sizing["url"]!
                            imageStr = url as? String
                        }
                    }
                }
                
                let pin = Pin.init(caption: "\(caption!)", imageStr: "\(imageStr!)")
                self.pinArray.append(pin)
            }
            
            
//            for var i = 0; i < pins?.count; i += 1 {
//                var caption: String?
//                var imageStr: String?
//                
//                if let item = pins![i] as? [String: AnyObject] {
//                    let desc = item["description"] as? String
//                    caption = "\(desc!)"
//                    if let image = item["images"] as? [String: AnyObject] {
//                        if let sizing = image["237x"] as? [String: AnyObject] {
//                            let url = sizing["url"]!
//                            imageStr = url as? String
//                        }
//                    }
//                }
//                
//                let pin = Pin.init(caption: "\(caption!)", imageStr: "\(imageStr!)")
//                self.pinArray.append(pin)
//                
//            }
            self.collectionView?.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.activityIndicator.stopAnimating()

        }

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pinArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PinCollectionViewCell
    
        let pin = self.pinArray[indexPath.row]
        
        SMNetwork.manager.downloadImage("\(pin.imageStr)", completionHandler:{(image: UIImage?, url: String) in
            cell.pinImageView.image = image
        })
        
        cell.pinLabel.text = "\(pin.caption)"
        
        return cell
    }
    
    
    

}
