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
        
        
        
        
        
        
        //metalView.device = device
        //metalView.depthStencilPixelFormat = .depth32Float
        metalView.clearColor = MTLClearColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.0)
        metalView.delegate = self
        metalView.drawableSize
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)//metalView.bounds.size)
        
    }
    var aspect:Float
    var _viewport:vector_uint2 = vector_uint2(0, 0)
}

extension Renderer: MTKViewDelegate{
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //setup our perspective matrix here?
        aspect = Float(view.bounds.width)/Float(view.bounds.height)
        _viewport.x = UInt32(size.width)
        _viewport.y = UInt32(size.height)
        
    }
    
    func draw(in view: MTKView) {
        var triangleSize = 0.5
        //var el1 = AAPLVertex()
        //el1.position = [Float(triangleSize, -triangleSize]
       // el1.color = [1.0, 0.0, 0.0, 1.0]
        
        
        let triangleVertices:[AAPLVertex] =
        [
            AAPLVertex(position: vector_float2((Float(triangleSize)), Float(-triangleSize)), color: vector_float4(1.0, 0.0, 0.0, 1.0)),
            AAPLVertex(position: vector_float2(-(Float(triangleSize)), -Float(triangleSize)), color: vector_float4(0.0, 1.0, 0.0, 1.0)),
            AAPLVertex(position: vector_float2(0.0, Float(triangleSize)), color: vector_float4(0.0, 0.0, 1.0, 1.0))
        ]
        guard
          let descriptor = view.currentRenderPassDescriptor,
          let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
          let renderEncoder =
          commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            return
        }
        renderEncoder.setDepthStencilState(depthStencilState)
       var vpx = _viewport.x
        var vpy = _viewport.y
        renderEncoder.setViewport(MTLViewport(originX: 0.0, originY: 00, width: Double(vpx), height: Double(_viewport.y), znear: 0.0, zfar: 1.0))
        renderEncoder.setRenderPipelineState(pipelineState)
        var verticesSize = MemoryLayout.size(ofValue: triangleVertices)
        //renderEncoder.setVertexBytes(triangleVertices, length: MemoryLayout.size(ofValue: //triangleVertices), index: Int(AAPLVertexInputIndexVertices.rawValue))
        renderEncoder.setVertexBytes(triangleVertices, length: 96, index: Int(AAPLVertexInputIndexVertices.rawValue))
        
        //let count = 1
        //let pointPointer = UnsafeRawPointer(
        
        var stride = MemoryLayout<vector_float2>.stride
        renderEncoder.setVertexBytes(&_viewport, length: MemoryLayout<vector_float2>.stride, index: Int(AAPLVertexInputIndexViewportSize.rawValue))
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
          return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
        //        static const AAPLVertex triangleVertices[] =
//        {
//            // 2D positions,    RGBA colors
//            { {  250,  -250 }, { 1, 0, 0, 1 } },
//            { { -250,  -250 }, { 0, 1, 0, 1 } },
//            { {    0,   250 }, { 0, 0, 1, 1 } },
//        };
        print("drawing scene")
    }
}
