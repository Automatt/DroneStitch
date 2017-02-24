//
//  SwViewController.swift
//  CVOpenStitch
//
//  Created by Foundry on 04/06/2014.
//  Copyright (c) 2014 Foundry. All rights reserved.
//

import UIKit

class SwViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var spinner:UIActivityIndicatorView!
    @IBOutlet var imageView:UIImageView?
    @IBOutlet var scrollView:UIScrollView!
    
    var assets: [PHAsset]?
    var stitchedImage: UIImage?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        stitch()

    }
    
    @IBAction func buttonShareAction(_ sender: Any) {
        if let image = self.stitchedImage {
            let vc = UIActivityViewController(activityItems: ["DroneStitch Image", image], applicationActivities: [])
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    func stitch() {
        
        var imgArray:[UIImage?] = []
        let ratio:CGFloat = 0.08
        if let assets = assets {
            for asset in assets {
                let img = self.compressToRatio(image: self.getAssetImage(asset: asset), ratio: ratio)
                imgArray.append(img)
            }
            
            if let inputImages = imgArray as? [UIImage] {
                
                self.stitchedImage = CVWrapper.process(with: inputImages) as UIImage
                
                DispatchQueue.main.async {
                    
                    self.spinner.startAnimating()

                    NSLog("stichedImage %@", self.stitchedImage ?? "no image")
                    
                    self.imageView = UIImageView.init(image: self.stitchedImage)
                    
                    self.scrollView.addSubview(self.imageView!)
                    self.scrollView.backgroundColor = UIColor.black
                    self.scrollView.contentSize = self.imageView!.bounds.size
                    self.scrollView.maximumZoomScale = 4.0
                    self.scrollView.minimumZoomScale = 1.0
                    self.scrollView.delegate = self
                    self.scrollView.contentOffset = CGPoint(x: -(self.scrollView.bounds.size.width - self.imageView!.bounds.size.width)/2.0, y: -(self.scrollView.bounds.size.height - self.imageView!.bounds.size.height)/2.0)
                    NSLog("scrollview \(self.scrollView.contentSize)")
                    
                    self.spinner.stopAnimating()
                }
            } else {
                self.spinner.stopAnimating()
                let alertController = UIAlertController(title: "Drone Stitch", message: "Sorry, but something went wrong while fetching images", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title:"Ok", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func getAssetImage(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            if let returnedImage = result {
                image = returnedImage
            }
        })
        return image
    }
    
    func compressToRatio(image:UIImage, ratio: CGFloat) -> UIImage? {
        let compressedSize:CGSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        UIGraphicsBeginImageContext(compressedSize)
        image.draw(in: CGRect(x:0, y:0, width: compressedSize.width, height: compressedSize.height))
        if let compressedImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return compressedImage
        }
        return nil
    }
    
    func flipV(im:UIImage)->UIImage {
        var newOrient:UIImageOrientation
        switch im.imageOrientation {
        case .up:
            newOrient = .downMirrored
        case .upMirrored:
            newOrient = .down
        case .down:
            newOrient = .upMirrored
        case .downMirrored:
            newOrient = .up
        case .left:
            newOrient = .leftMirrored
        case .leftMirrored:
            newOrient = .left
        case .right:
            newOrient = .rightMirrored
        case .rightMirrored:
            newOrient = .right
        }
        return UIImage(cgImage: im.cgImage!, scale: im.scale, orientation: newOrient)
    }
    
    func viewForZooming(in scrollView:UIScrollView) -> UIView? {
        return self.imageView!
    }
        
}
