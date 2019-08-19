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

    var plane:Plane?
    var pipelineState: MTLRenderPipelineState?
    var commandQueue:MTLCommandQueue!
    var metalView: MTKView!
    var samplerState: MTLSamplerState?
    func setMTKView(to mtkView:MTKView) {
        metalView = mtkView
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device
        metalView.clearColor = Colors.green
        commandQueue = device.makeCommandQueue()
        metalView.delegate = self
        plane = Plane(_device: device, imageName: "cgi1.png")//the plane holds buffers and sets them up with the model
        BuildPipelineState()//pipeline state sets up vertex and fragment shaders and strides of buffers
        buildSamplerState()
    }
    private func buildSamplerState(){
        let descriptor = MTLSamplerDescriptor()
        descriptor.minFilter = .linear
        descriptor.magFilter = .linear
        samplerState = device.makeSamplerState(descriptor: descriptor)
    }
    private func BuildPipelineState(){
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: plane!.vertexFunctionName)
        let fragmentFunction = library?.makeFunction(name: plane!.fragmentFunctionName)
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
//        let vertexDescriptor = MTLVertexDescriptor()
//        vertexDescriptor.attributes[0].format = .float3
//        vertexDescriptor.attributes[0].offset = 0
//        vertexDescriptor.attributes[0].bufferIndex = 0
//        
//        vertexDescriptor.attributes[1].format = .float4
//        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride
//        vertexDescriptor.attributes[1].bufferIndex = 0
//        
//        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        pipelineDescriptor.vertexDescriptor = plane?.vertexDescriptor
        do{
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            
        }
        catch let error as NSError{
            print("error: \(error.localizedDescription)")
        }
    }
    override init() {
        print("initializing")
    }
}

extension Renderer:MTKViewDelegate{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    func draw(in view: MTKView) {
        //safely unwrap vars so we don't crash
        guard let drawable = view.currentDrawable,
            let pipelineState = pipelineState,
            let descriptor = view.currentRenderPassDescriptor
            else{//if any of the guard vars resolve to null then bail
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
        
        commandEncoder?.setFragmentSamplerState(samplerState, index: 0)
        //place in plane class???
        commandEncoder?.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)
        //use indices this time so we dont duplicate vertices of the model
        commandEncoder?.setFragmentTexture(plane?.texture, index: 0)
        commandEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: (plane?.indices.count)!, indexType: .uint16, indexBuffer: plane!.indexBuffer!, indexBufferOffset: 0)
        
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()//draw at the gpu
    }
}
