//
//  ViewController.swift
//  SeeFood
//
//  Created by AhmedZlazel on 6/27/18.
//  Copyright © 2018 AhmedZlazel. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else{
                fatalError("Could not convert UIImage to CIImage !")
            }
            detect(image: ciimage)
        }
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("Loading CoreML Failed!")
        }
        let request = VNCoreMLRequest(model: model) {
            (request,error) in
            guard let results = request.results as? [VNClassificationObservation]else{
                fatalError("Model failed to process!")
            }
           // print(result)
            if let firstResult = results.first{
                if firstResult.identifier.contains("car"){
                    self.navigationItem.title = "Car!"
                }else{
                    self.navigationItem.title = "Not a Car!"
                }
            }
            
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}

