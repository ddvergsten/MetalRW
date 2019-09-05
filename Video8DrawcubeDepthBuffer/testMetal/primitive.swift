//
//  Plane.swift
//  testMetal
//
//  Created by David Dvergsten on 8/18/19.
//  Copyright © 2019 Rapid Imaging Tech. All rights reserved.
//

import Foundation
import MetalKit
class Primitive: NSObject{
    var vertexBuffer:MTLBuffer?
    var indexBuffer:MTLBuffer?
    var device:MTLDevice!
    var  fragmentFunctionName: String = "fragment_shader"
    var vertexFunctionName: String = "vertex_shader"
    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        //let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<float3>.stride + MemoryLayout<float4>.stride
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        return vertexDescriptor
    }
    func buildVertices(){
        
    }
    var vertices:[Vertex] = [
//        Vertex(position: float3(-1, 1, 0),
//               color: float4(1, 0, 0, 1),
//               texture: float2(0, 1)),
//        Vertex(position: float3(-1, -1, 0),
//               color: float4(0, 1, 0, 1),
//               texture: float2(0, 0)),
//        Vertex(position: float3(1, -1, 0),
//               color: float4(0, 0, 1, 1),
//               texture: float2(1, 0)),
//        Vertex(position: float3(1, 1, 0),
//               color: float4(1, 0, 1, 1),
//               texture: float2(1, 1))
    ]
    
    var indices:[UInt16] = [
//        0,1,2,
//        2,3,0
    ]
    var texture: MTLTexture?
    init(_device:MTLDevice){
        super.init()
        buildVertices()
        device = _device
        BuildModel()
    }
    
    init(_device:MTLDevice, imageName: String){
        super.init()
        buildVertices()
        //self.texture = setTexture(device: _device, imageName: imageName)
        if let texture = setTexture(device: _device, imageName: imageName){
            self.texture = texture
            fragmentFunctionName = "textured_fragment"
        }
        device = _device
        BuildModel()
    }
    //contains the mtlbuffers
    //the model data
    //build buffer functions
    private func BuildModel(){
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        
        //this time use indices into the vertex buffer so we don't duplicate vertices
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
    }
}

extension Primitive: Texturable{}
