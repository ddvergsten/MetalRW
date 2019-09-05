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
    var rotAngle:Float = 0.00
    var modelConstants = ModelConstants()
    var modelConstantsCube = ModelConstants()
    var time:Float = 0.0
    var device:MTLDevice!

    var plane:Plane?
    var cube:Cube?
    
    var pipelineStatePlane: MTLRenderPipelineState?
    var pipelineStateCube: MTLRenderPipelineState?
    
    var commandQueue:MTLCommandQueue!
    var metalView: MTKView!
    var samplerState: MTLSamplerState?
    var depthStencilState: MTLDepthStencilState?
    func buildDepthStencilState(){
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
    func setMTKView(to mtkView:MTKView) {
        metalView = mtkView
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device
        metalView.clearColor = Colors.green
        metalView.depthStencilPixelFormat = .depth32Float
        commandQueue = device.makeCommandQueue()
        metalView.delegate = self
        
        plane = Plane(_device: device, imageName: "cgi1.png")//the plane holds buffers and sets them up with the model
        cube = Cube(_device: device)
        
        BuildPipelineStatePlane()//pipeline state sets up vertex and fragment shaders and strides of buffers
        BuildPipelineStateCube()
        buildSamplerState()
        
        buildDepthStencilState()
    }
    private func buildSamplerState(){
        let descriptor = MTLSamplerDescriptor()
        descriptor.minFilter = .linear
        descriptor.magFilter = .linear
        samplerState = device.makeSamplerState(descriptor: descriptor)
    }
    private func BuildPipelineStatePlane(){
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: plane!.vertexFunctionName)
        let fragmentFunction = library?.makeFunction(name: plane!.fragmentFunctionName)
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexDescriptor = plane?.vertexDescriptor
        do{
            pipelineStatePlane = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }
        catch let error as NSError{
            print("error: \(error.localizedDescription)")
        }
    }
    
    private func BuildPipelineStateCube(){
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: cube!.vertexFunctionName)
        let fragmentFunction = library?.makeFunction(name: cube!.fragmentFunctionName)

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexDescriptor = cube?.vertexDescriptor
        do{
            pipelineStateCube = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
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
            let pipelineStatePlane = pipelineStatePlane,
            let pipelineStateCube = pipelineStateCube,
            let descriptor = view.currentRenderPassDescriptor
            else{//if any of the guard vars resolve to null then bail
                return
            }
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        let aspect = Float(750.0/1334.0)
        let projectionMatrix = matrix_float4x4(projectionFov: radians(fromDegrees: 65), aspect: aspect, nearZ: 0.1, farZ: 100.0)
        
        commandEncoder?.setFragmentSamplerState(samplerState, index: 0)
        commandEncoder?.setDepthStencilState(depthStencilState)
        
        //render cube
        ////////////
        //set up constants var to hold the animation value based on time
        //time += 1/Float(view.preferredFramesPerSecond)
        rotAngle+=0.01
        let animateBy = rotAngle //abs(sin(time)/2 + 0.5)
        
        //constants.animateBy = animateBy
        let rotationMatrix = matrix_float4x4(rotationAngle: animateBy, x: 0, y: 1, z: 0)
        
        let viewMatrixCube = matrix_float4x4(translationX: 0, y: 0, z: -4)
        //let modelViewMatrixCube = matrix_multiply(rotationMatrix, viewMatrixCube)
        let modelViewMatrixCube = matrix_multiply( viewMatrixCube, rotationMatrix)
        
        //modelConstants.modelViewMatrix = modelViewMatrix
        
        //let aspect = Float(750.0/1334.0)
        //let projectionMatrix = matrix_float4x4(projectionFov: radians(fromDegrees: 65), aspect: aspect, nearZ: 0.1, farZ: 100.0)
        modelConstantsCube.modelViewMatrix = matrix_multiply(projectionMatrix, modelViewMatrixCube)
        commandEncoder?.setRenderPipelineState(pipelineStateCube)
        commandEncoder?.setVertexBuffer(cube?.vertexBuffer, offset: 0, index: 0)
        
        //set the constants parameter in the vertex shader to constants from cpu memory
        //index 1 means that it's the 2nd paramter in the shader
        //commandEncoder?.setFragmentSamplerState(samplerState, index: 0)
        //place in plane class???
        commandEncoder?.setVertexBytes(&modelConstantsCube, length: MemoryLayout<ModelConstants>.stride, index: 1)
        //use indices this time so we dont duplicate vertices of the model
        commandEncoder?.setFrontFacing(.counterClockwise)
        commandEncoder?.setCullMode(.back)
        commandEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: (cube?.indices.count)!, indexType: .uint16, indexBuffer: cube!.indexBuffer!, indexBufferOffset: 0)
        
        //commandEncoder?.endEncoding()
        //commandBuffer?.present(drawable)
        /////////////////
        
        //render flat image
        ////////////
        //set up constants var to hold the animation value based on time
        //time += 1/Float(view.preferredFramesPerSecond)
        //let animateBy = abs(sin(time)/2 + 0.5)
        
        //constants.animateBy = animateBy
        //let rotationMatrix = matrix_float4x4(rotationAngle: animateBy, x: 0, y: 0, z: 1)
        
        let scale = matrix_float4x4(scaleX: 3, y: 3, z: 1)
        let viewMatrix = matrix_float4x4(translationX: 0, y: 0, z: -7)
        let modelViewMatrix = matrix_multiply(scale, viewMatrix)
        
        modelConstants.modelViewMatrix = modelViewMatrix
        
        
        
        modelConstants.modelViewMatrix = matrix_multiply(projectionMatrix, modelViewMatrix)
        commandEncoder?.setRenderPipelineState(pipelineStatePlane)
        commandEncoder?.setVertexBuffer(plane?.vertexBuffer, offset: 0, index: 0)
        
        //set the constants parameter in the vertex shader to constants from cpu memory
        //index 1 means that it's the 2nd paramter in the shader
        
        //place in plane class???
        commandEncoder?.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 1)
        //use indices this time so we dont duplicate vertices of the model
        commandEncoder?.setFragmentTexture(plane?.texture, index: 0)
        commandEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: (plane?.indices.count)!, indexType: .uint16, indexBuffer: plane!.indexBuffer!, indexBufferOffset: 0)
        
        
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        /////////////////
        
        
        
        commandBuffer?.commit()//draw at the gpu
    }
}
