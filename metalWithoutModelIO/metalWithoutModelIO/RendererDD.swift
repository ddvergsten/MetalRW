//
//  RendererDD.swift
//  metalWithoutModelIO
//
//  Created by David Dvergsten on 12/15/21.
//

import MetalKit

class Renderer: NSObject{
    let pipelineState: MTLRenderPipelineState
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    var depthStencilState:MTLDepthStencilState?
    
    private static func buildPipelineState(_ pstr:String)->MTLRenderPipelineState{
        let library = Renderer.library
        let vertexFunction = library?.makeFunction(name: "vertexShader")
        let fragmentFunction = library?.makeFunction(name: "fragmentShader")
        
        var pipelineState:MTLRenderPipelineState
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
          pipelineState = try Renderer.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
          fatalError(error.localizedDescription)
        }
        return pipelineState
    }
    static func buildDepthStencilState()->MTLDepthStencilState?{
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        return Renderer.device.makeDepthStencilState(descriptor: descriptor)
        
    }
    init(metalView: MTKView){
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue() else{
                  fatalError("couldn't create device or command queue")
              }
        Renderer.device = device
        depthStencilState = Renderer.buildDepthStencilState()
        Renderer.commandQueue = commandQueue
        Renderer.library = device.makeDefaultLibrary()
        metalView.device = device
        metalView.depthStencilPixelFormat = .depth32Float
        pipelineState = Renderer.buildPipelineState("it works")
        aspect = 0.0
        super.init()
        
        metalView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        metalView.delegate = self
        metalView.drawableSize
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)//metalView.bounds.size)
        
    }
    var aspect:Float
    var _viewport:vector_uint2 = vector_uint2(0, 0)
    var rotation:Float = 0.0
}

extension Renderer: MTKViewDelegate{
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //setup our perspective matrix here?
        aspect = Float(view.bounds.width)/Float(view.bounds.height)
        _viewport.x = UInt32(size.width)
        _viewport.y = UInt32(size.height)
        
    }
    
    func draw(in view: MTKView) {
        rotation += 0.01
        var triangleSizeHalf = 2.0
        var triangleSizeFull = triangleSizeHalf * 2
        var zvalue = 0.0
        var colorRed:vector_float4 = vector_float4(1.0, 0.0, 0.0, 1.0)
        var colorBlue:vector_float4 = vector_float4(0.0, 0.0, 1.0, 1.0)
        let triangleVertices:[AAPLVertex] =
        [
            //red side
            AAPLVertex(position: vector_float3((Float(triangleSizeHalf)), Float(-triangleSizeHalf), Float(zvalue)), color: colorRed),
            AAPLVertex(position: vector_float3(-(Float(triangleSizeHalf)), -Float(triangleSizeHalf), Float(zvalue)), color: colorRed),
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue)), color: colorRed),
            
            AAPLVertex(position: vector_float3((Float(triangleSizeHalf)), Float(triangleSizeHalf), Float(zvalue)), color: colorRed),
            AAPLVertex(position: vector_float3(-(Float(triangleSizeHalf)), -Float(triangleSizeHalf), Float(zvalue)), color: colorRed),
            AAPLVertex(position: vector_float3(Float(-triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue)), color: colorRed),
            
            //blue side
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue)), color: colorBlue),
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: colorBlue),
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue)), color: colorBlue),
            
            AAPLVertex(position: vector_float3((Float(triangleSizeHalf)), Float(triangleSizeHalf), Float(zvalue)), color: colorBlue),
            AAPLVertex(position: vector_float3((Float(triangleSizeHalf)), Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: colorBlue),
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: colorBlue)
        ]
        guard
          let descriptor = view.currentRenderPassDescriptor,
          let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
          let renderEncoder =
          commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            return
        }
       
        
        
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setViewport(MTLViewport(originX: 0.0, originY: 00, width: Double(_viewport.x), height: Double(_viewport.y), znear: 0.0, zfar: 1.0))
        renderEncoder.setRenderPipelineState(pipelineState)
        
        var ortho:float4x4 = float4x4(orthoLeft: -10.0, right: 10.0, bottom: -10.0, top: 10.0, near: 0.0, far: 10.0)
        renderEncoder.setVertexBytes(&ortho, length: MemoryLayout<float4x4>.stride, index: Int(AAPLOrtho.rawValue))
        
        
        var translation:float4x4 = float4x4(translation: float3(0.0, 0.0, 4.0))
        var rotation:float4x4 = float4x4(rotation: float3(0.0, rotation, 0.0))
        rotation = translation * rotation
        renderEncoder.setVertexBytes(&rotation, length: MemoryLayout<float4x4>.stride, index: Int(AAPLrotation.rawValue))
        
        var verticesSize = MemoryLayout<AAPLVertex>.size * triangleVertices.count
        renderEncoder.setVertexBytes(triangleVertices, length: MemoryLayout<AAPLVertex>.size * triangleVertices.count, index: Int(AAPLVertexInputIndexVertices.rawValue))
        
        var stride = MemoryLayout<vector_float2>.stride
        renderEncoder.setVertexBytes(&_viewport, length: MemoryLayout<vector_float2>.stride, index: Int(AAPLVertexInputIndexViewportSize.rawValue))
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 12)
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
          return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
