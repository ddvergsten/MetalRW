//
//  Texturable.swift
//  testMetal
//
//  Created by David Dvergsten on 8/19/19.
//  Copyright © 2019 Rapid Imaging Tech. All rights reserved.
//

import MetalKit

protocol  Texturable {
    var texture: MTLTexture? { get set }
}

extension Texturable{
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture?{
        let textureLoader = MTKTextureLoader(device: device)
        
        var texture: MTLTexture? = nil
        let textureLoaderOptions: [MTKTextureLoader.Option: Any]
        if #available(iOS 10.0, *){
            //MTKTextureLoader.Origin.bottomLeft
            //let origin = NSString(string: MTKTextureLoader.Origin.bottomLeft.rawValue)
            textureLoaderOptions = [.origin: MTKTextureLoader.Origin.bottomLeft]
        }
        else{
            textureLoaderOptions = [:]
        }
        
        if let textureURL = Bundle.main.url(forResource: imageName, withExtension: nil){
            do{
                texture = try textureLoader.newTexture(URL: textureURL, options: textureLoaderOptions)
                
            }catch{
                print("texture not created")
            }
        }
        return  texture
    }
}
