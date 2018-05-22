//
//  ViewController.swift
//  SeeFood
//
//  Created by Sam on 5/19/18.
//  Copyright © 2018 Sam. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    let imagePicker = UIImagePickerController();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self;
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = true;
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //down cast dictionary value to UIimage
        // mainImageView image property can only be set to an UIImage type
        if let userImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            mainImageView.image = userImage;
            guard let ciIamge = CIImage(image: userImage) else {
                fatalError("Could not convert to ci Iamge");
            }
            
            detect(image: userImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        // attempt to perform this operation that might error
        // if it succeeds then result is wrapped as optional
        
        //if model is nil , trigger else statement that throws fatal error
        
        //VNCoreModel comes from vision framework
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Failed to load CoreML Model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Failed to retrieve CoreML request results")
            }
            
            print(results)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

