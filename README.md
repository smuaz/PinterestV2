# SMNetwork

SMNetwork is a small helper library to help user download images from URL asynchronously. Used NSCache to cache the images and the remote resources URL. Also, a utility function to download JSON and XML file.

Also, there is a sample project PinterestV2.xcodeproj included with the library

### Version
1.0

### Installation

Just drag the SMNetwork.swift file and copy into your XCode project

### Usage

To download images asynchrously, just use this example code below: 

```
SMNetwork.manager.downloadImage("http://yourapi.com/image.jpg", completionHandler:{(image: UIImage?, url: String) in
  self.imageView.image = image
})
```
To download JSON file asynchrously, just use this example code below and it will return json as NSDictionary: 

```
SMNetwork.manager.downloadJSONFile("https://api.yoursite.com/api/file.json") { (json) in
    print(json)
}
```

To download XML file asynchrously, just use this example code below and it will return NSXMLParser: 

```
SMNetwork.manager.downloadXMLFile("https://api.yoursite.com/api/file.xml") { (xml) in
    print(xml)
}
```

License
----

MIT
