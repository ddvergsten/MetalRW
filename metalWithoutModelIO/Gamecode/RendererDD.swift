//
//  RendererDD.swift
//  metalWithoutModelIO
//
//  Created by David Dvergsten on 12/15/21.
//

import MetalKit

class Renderer: NSObject{
    let CUBESIZE:Float = 160.0
    let CUBESPACING:Float = 20.0
    let MAXDEPTH:Float = 1000.0
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
        _aspect = 0.0
        super.init()
        createCubes()
        metalView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        metalView.delegate = self
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)//metalView.bounds.size)
        
    }
    func addCube(position:float3){
        let cube = Cube()
        cube.CreateModel(red: 1.0, green: 1.0, blue: 1.0, cubesize: CUBESIZE, bordersize:CUBESPACING )
        cube.position = position
        _cubeArray.append(cube)
    }
    func createCubes(){
        let cubePlusSpace = CUBESIZE //+ CUBESPACING
        for x in 0...0{
            for y in 0...0{
                for z in 0...0{
                    addCube(position: float3((Float(x) * cubePlusSpace)-cubePlusSpace, (Float(y) * cubePlusSpace)-cubePlusSpace, (Float(z) * cubePlusSpace) - cubePlusSpace))
                }
                //addCube(position: float3((Float(x) * CUBESIZE)-CUBESIZE, (Float(y) * CUBESIZE)-CUBESIZE, 0.0))
            }
            
        }
    }
    var _cubeArray:[Cube] = []
    var _aspect:Float
    var _viewport:vector_uint2 = vector_uint2(0, 0)
    var _rotation:Float = 0.0
    var _cubePosition:float3 = float3(0.0, 0.0, 0.0)
}

extension Renderer: MTKViewDelegate{
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //setup our perspective matrix here?
        _aspect = Float(view.bounds.width)/Float(view.bounds.height)
        _viewport.x = UInt32(size.width)
        _viewport.y = UInt32(size.height)
        //center the cube in viewport clipping area
        _cubePosition = float3(Float(_viewport.x)/2, Float(_viewport.y) / 2, MAXDEPTH / 2.0)
    }
    
    func draw(in view: MTKView) {
        _rotation += 0.01
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
        
        var ortho:float4x4 = float4x4(orthoLeft: 0.0, right: Float(_viewport.x), bottom: 0.0, top: Float(_viewport.y), near: 0.0, far: MAXDEPTH)
        
        renderEncoder.setVertexBytes(&ortho, length: MemoryLayout<float4x4>.stride, index: Int(AAPLOrtho.rawValue))
        
        for cube in _cubeArray{
            let rotation:float4x4 = float4x4(rotation: float3(0.0, _rotation, 0.0))
            let translation1:float4x4 = cube.translation
            var modelView = rotation * translation1
            let translation:float4x4 = float4x4(translation: _cubePosition)
            modelView = translation * modelView
            //moves this subcube away from the screen 100 units
            renderEncoder.setVertexBytes(&modelView, length: MemoryLayout<float4x4>.stride, index: Int(AAPLrotation.rawValue))

            //use a buffer
            renderEncoder.setVertexBuffer(cube.buffer, offset: 0, index: Int(AAPLVertexInputIndexVertices.rawValue))
            //renderEncoder.setVertexBytes(cube.triangleVertices, length: MemoryLayout<AAPLVertex>.size * //cube.triangleVertices.count, index: Int(AAPLVertexInputIndexVertices.rawValue))

            renderEncoder.setVertexBytes(&_viewport, length: MemoryLayout<vector_float2>.stride, index: Int(AAPLVertexInputIndexViewportSize.rawValue))
            renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: cube.triangleVertices.count)
        }

        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
          return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
