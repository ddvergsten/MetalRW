//
//  Renderer.swift
//  Pipeline
//
//  Created by David Dvergsten on 11/13/20.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    var timer: Float = 0
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    var meshCube: MTKMesh!
    var meshTrain: MTKMesh!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    
    
    init(metalView: MTKView){
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue() else{
            fatalError("GPU not available")
        }
        Renderer.device = device
        Renderer.commandQueue = commandQueue
        metalView.device = device
        
        //todo: load mesh from train.obj this time
        let allocator = MTKMeshBufferAllocator(device: device)
        guard let assetURL = Bundle.main.url(forResource: "train", withExtension: "obj") else {
            fatalError()
        }
        let vertexDescriptor2 = MTLVertexDescriptor()
        vertexDescriptor2.attributes[0].format = .float3
        vertexDescriptor2.attributes[0].offset = 0
        vertexDescriptor2.attributes[0].bufferIndex = 0
        vertexDescriptor2.layouts[0].stride = MemoryLayout<SIMD3<Float>>.stride
        
        let meshDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor2)
        (meshDescriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        let asset = MDLAsset(url: assetURL, vertexDescriptor: meshDescriptor, bufferAllocator: allocator)
        let mdlMesh2 = asset.childObjects(of: MDLMesh.self).first as! MDLMesh
        do{
            meshTrain = try MTKMesh(mesh: mdlMesh2, device: device)
        }
        catch let error{
            print(error.localizedDescription)
        }
        let mdlMesh = Primitive.makeCube(device: device, size: 1)
        do{
            //we need a mtkmesh so we can create the vertexbuffer for the pipeline
            meshCube = try MTKMesh(mesh: mdlMesh, device: device)
        }catch let error{
            print(error.localizedDescription)
        }
        
        //for use later, this points to the buffer containing the vertices for the train
        vertexBuffer = meshTrain.vertexBuffers[0].buffer
        
        //initilize our shader code into a library ie like opengl program
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")
        
        //setup the pipeline so it knows how to act on the data we give it
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
    
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh2.vertexDescriptor)
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        
        do{
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }
        catch let error {
            fatalError(error.localizedDescription)
            
        }
        super.init()
        metalView.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
        metalView.delegate = self
        
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize){
        
    }
    func draw(in view: MTKView) {
        guard let descriptor = view.currentRenderPassDescriptor,
              let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else {
            return
        }
        //drawing code goes here
        timer += 0.05
        var currentTime = sin(timer)
        
        //set value in shader (timer) which is at index 1 right after the position data?
        renderEncoder.setVertexBytes(&currentTime, length: MemoryLayout<Float>.stride, index: 1)
        
        //make this pipeline state current, ie like setting program/vertex stride ie index = 0 stride = 3 floats for xyz
        renderEncoder.setRenderPipelineState(pipelineState)
        
        //set the buffer with the actual data, ie vertices of the train model
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        for submesh in meshTrain.submeshes {
            
            //draw the train model ie like opengl drawelements command, except here I think we can stack up all our
            //draw commands and make one call to commandbuffer.present/commit
            renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: submesh.indexCount, indexType: submesh.indexType, indexBuffer: submesh.indexBuffer.buffer, indexBufferOffset: submesh.indexBuffer.offset)
        }
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
    }
}
