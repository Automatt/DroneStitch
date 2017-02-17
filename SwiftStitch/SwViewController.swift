//
//  SwViewController.swift
//  CVOpenStitch
//
//  Created by Foundry on 04/06/2014.
//  Copyright (c) 2014 Foundry. All rights reserved.
//

import UIKit
import CTAssetsPickerController

class SwViewController: UIViewController, UIScrollViewDelegate, CTAssetsPickerControllerDelegate {
    
    @IBOutlet var spinner:UIActivityIndicatorView!
    @IBOutlet var imageView:UIImageView?
    @IBOutlet var scrollView:UIScrollView!
    
    var picked: Bool = false
    
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
        
        if !picked {
            pick()
        }
        //stitch()
    }
    
    func pick() {
        let picker: CTAssetsPickerController = CTAssetsPickerController()
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
    
    func assetsPickerControllerDidCancel(_ picker: CTAssetsPickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func assetsPickerController(_ picker: CTAssetsPickerController, didFinishPicking assets: [PHAsset]) {
        
        picked = true
        self.spinner.startAnimating()

        picker.dismiss(animated: true) {
            var imgArray:[UIImage?] = []
            let ratio:CGFloat = 0.10

            for asset in assets {
                let img = self.compressToRatio(image: self.getAssetImageThumbnail(asset: asset), ratio: ratio)
                imgArray.append(img)
            }
            
            
            let stitchedImage:UIImage = CVWrapper.process(with: imgArray as! [UIImage]) as UIImage

            DispatchQueue.main.async {
                NSLog("stichedImage %@", stitchedImage)
            
                self.imageView = UIImageView.init(image: stitchedImage)
                
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
        }

    }
    
    func getAssetImageThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
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
