//
//  FirebaseTextProcess.swift
//  Cosmetic
//
//  Created by Omp on 19/9/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import Foundation
import FirebaseMLVision

public protocol FirebaseTextProcessProtocol: class {
    func onSuccessRecognize(resultText: String)
    func onFailedRecognize()
}

class FirebaseTextProcess {
    
    weak var callback: FirebaseTextProcessProtocol?
    
    func textRecognise(sampleBuffer: CMSampleBuffer) {
        
        self.callback?.onFailedRecognize()
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        //let cameraPosition = AVCaptureDevice.Position.back
        let metadata = VisionImageMetadata()
//        metadata.orientation = imageOrientation(
//            deviceOrientation: UIDevice.current.orientation,
//            cameraPosition: cameraPosition
//        )
        let image = VisionImage(buffer: sampleBuffer)
        image.metadata = metadata
        

        textRecognizer.process(image) { result, error in
            guard error == nil, let result = result else {
                
                return
            }

            //let resultText = result.text
            for block in result.blocks{
                for line in block.lines{
                    for element in line.elements{
                        print(element.text)
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                        })
                    }
                }
                
            }
            
            
        }
        
    }
}
