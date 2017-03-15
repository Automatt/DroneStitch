//
//  PanoViewController.swift
//  DroneStitch
//
//  Created by Mathew Spolin on 3/14/17.
//  Copyright © 2017 ellipsis.com. All rights reserved.
//

import UIKit
import CTPanoramaView

class PanoViewController: UIViewController {
    
    @IBOutlet weak var panoView: CTPanoramaView!
    var panoImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let image = panoImage {
            self.panoView.image = image
            self.panoView.controlMethod = .motion
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
