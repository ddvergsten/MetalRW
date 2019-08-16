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
    var vertices:[Float] = [
    0,1,0,
    -1,-1,0,
    1,-1,0
    ]
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer:MTLBuffer?
    var commandQueue:MTLCommandQueue!
    var metalView: MTKView!
    private func BuildModel(){
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])
    }
    func setMTKView(to mtkView:MTKView) {
    //func setMTKView(){
        metalView = mtkView
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device
        metalView.clearColor = Colors.green
        commandQueue = device.makeCommandQueue()
        metalView.delegate = self
        BuildModel()
        BuildPipelineState()
    }
    private func BuildPipelineState(){
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "fragment_shader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do{
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            
        }
        catch let error as NSError{
            print("error: \(error.localizedDescription)")
        }

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
            let pipelineState = pipelineState,
            let descriptor = view.currentRenderPassDescriptor else{
                return
        }
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        commandEncoder?.setRenderPipelineState(pipelineState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()//draw at the gpu
    }
}
