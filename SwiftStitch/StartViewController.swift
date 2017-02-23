//
//  StartViewController.swift
//  DroneStitch
//
//  Created by Mathew Spolin on 2/22/17.
//  Copyright © 2017 ellipsis.com. All rights reserved.
//

import UIKit
import CTAssetsPickerController

class StartViewController: UIViewController, CTAssetsPickerControllerDelegate {

    var assetsPicked: [PHAsset]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonChooseAction(_ sender: Any) {
        
        pick()
        
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
        
        self.assetsPicked = assets
        
        picker.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "stitchSegue", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? SwViewController {
            if let assets = self.assetsPicked {
                vc.assets = assets
            }
        }
        
    }


}
