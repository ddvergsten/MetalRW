//
//  renderer.swift
//  testMetal
//
//  Created by David Dvergsten on 8/15/19.
//  Copyright © 2019 Rapid Imaging Tech. All rights reserved.
//

import Foundation
import MetalKit

class Renderer:NSObject {
    enum Colors{
        static let green = MTLClearColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
    }
    var device:MTLDevice!
    var commandQueue:MTLCommandQueue!
    var metalView: MTKView!
    func setMTKView(to mtkView:MTKView) {
    //func setMTKView(){
        metalView = mtkView
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device
        metalView.clearColor = Colors.green
        commandQueue = device.makeCommandQueue()
        metalView.delegate = self
    }
    override init() {
        print("initializing")
        //metalView = mtkView
        //metalView.device = MTLCreateSystemDefaultDevice()
    
        
    }
}

extension Renderer:MTKViewDelegate{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor else{
                return
        }
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
