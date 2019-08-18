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
    struct Constants{
        var animateBy:Float = 0.0
    }
    var constants = Constants()
    var time:Float = 0.0
    var device:MTLDevice!
//    var vertices:[Float] = [
//        -1,1,0, //v0
//        -1,-1,0, //v1
//        1,-1,0, //v2
//        1,1,0, //v3
//    ]
//
//    var indices:[UInt16] = [
//        0,1,2,2,3,0
//    ]
    var plane:Plane?
    var pipelineState: MTLRenderPipelineState?
    //var vertexBuffer:MTLBuffer?
    //var indexBuffer:MTLBuffer?
    var commandQueue:MTLCommandQueue!
    var metalView: MTKView!
//    private func BuildModel(){
//        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])
//        
//        //this time use indices into the vertex buffer so we don't duplicate vertices
//        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
//    }
    func setMTKView(to mtkView:MTKView) {
    //func setMTKView(){
        metalView = mtkView
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device
        metalView.clearColor = Colors.green
        commandQueue = device.makeCommandQueue()
        metalView.delegate = self
        plane = Plane(_device: device)
        
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
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
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
        //safely unwrap vars so we don't crash
        guard let drawable = view.currentDrawable,
            let pipelineState = pipelineState,
            //let indexBuffer = indexBuffer,
            let descriptor = view.currentRenderPassDescriptor else{
                return
        }
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        //set up constants var to hold the animation value based on time
        time += 1/Float(view.preferredFramesPerSecond)
        let animateBy = abs(sin(time)/2 + 0.5)
        
        constants.animateBy = animateBy
        
        commandEncoder?.setRenderPipelineState(pipelineState)
        commandEncoder?.setVertexBuffer(plane?.vertexBuffer, offset: 0, index: 0)
        
        //set the constants parameter in the vertex shader to constants from cpu memory
        //index 1 means that it's the 2nd paramter in the shader
        commandEncoder?.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)
        //commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        //use indices this time so we dont duplicate vertices of the model
        commandEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: (plane?.indices.count)!, indexType: .uint16, indexBuffer: plane!.indexBuffer!, indexBufferOffset: 0)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()//draw at the gpu
    }
}
