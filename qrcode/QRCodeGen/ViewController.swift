//
//  ViewController.swift
//  QRCodeGen
//
//  Created by Clinton de Sá Barreto Maciel on 23/08/16.
//  Copyright © 2016 clintonsbm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var logo: UIImageView!
    
    var qrcodeImage: CIImage!
    
    
    //qrcodegen://mypath?Yuri&Renan&Matheus
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.displayLaunchDetails), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        self.slider.isHidden = true
        self.logo.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayLaunchDetails() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.query != nil {
            self.textField.text = appDelegate.query
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    @IBAction func performButtonAction(_ sender: AnyObject) {
        if self.qrcodeImage == nil {
            if self.textField.text != "" {
                
                let text = "qrcodegen://mypath?" + self.textField.text!
                
                let data = text.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
                
                let filter = CIFilter(name: "CIQRCodeGenerator")
                
                filter?.setValue(data, forKey: "inputMessage")
                filter?.setValue("Q", forKey: "inputCorrectionLevel")
                
                self.qrcodeImage = filter?.outputImage
                
                self.displayQRCodeImage()
                
                self.textField.resignFirstResponder()
                
                self.btnAction.setTitle("Clear", for: UIControlState())
                
                self.textField.isEnabled = !self.textField.isEnabled
                self.slider.isHidden = !self.slider.isHidden
                self.logo.isHidden = !self.logo.isHidden
            }
        } else {
            self.imgQRCode.image = nil
            self.qrcodeImage = nil
            self.btnAction.setTitle("Generate", for: UIControlState())
            
            self.textField.isEnabled = !self.textField.isEnabled
            self.slider.isHidden = !self.slider.isHidden
            self.logo.isHidden = !self.logo.isHidden
        }
        
//        self.textField.enabled = !self.textField.enabled
//        self.slider.hidden = !self.slider.hidden

    }
    
    
    @IBAction func changeImageViewScale(_ sender: AnyObject) {
        self.imgQRCode.transform = CGAffineTransform(scaleX: CGFloat(self.slider.value), y: CGFloat(self.slider.value))
        
        self.logo.transform = CGAffineTransform(scaleX: CGFloat(self.slider.value), y: CGFloat(self.slider.value))
    }
    
    func displayQRCodeImage() {
        let scaleX = self.imgQRCode.frame.size.width / self.qrcodeImage.extent.size.width
        let scaleY = self.imgQRCode.frame.size.height / self.qrcodeImage.extent.size.height
        
        let transformedImage = self.qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        self.imgQRCode.image = UIImage(ciImage: transformedImage)
    }


}



















