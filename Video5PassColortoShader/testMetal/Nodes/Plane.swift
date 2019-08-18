//
//  Plane.swift
//  testMetal
//
//  Created by David Dvergsten on 8/18/19.
//  Copyright © 2019 Rapid Imaging Tech. All rights reserved.
//

import Foundation
import MetalKit
class Plane: NSObject{
    var vertexBuffer:MTLBuffer?
    var indexBuffer:MTLBuffer?
    var device:MTLDevice!
    var vertices:[Vertex] = [
        Vertex(position: float3(-1,1,0), color: float4(1,0,0,1)),
        Vertex(position: float3(-1,-1,0), color: float4(0,1,0,1)),
        Vertex(position: float3(1,-1,0), color: float4(0,0,1,1)),
        Vertex(position: float3(1,1,0), color: float4(1,0,1,1)),
//        -1,1,0, //v0
//        -1,-1,0, //v1
//        1,-1,0, //v2
//        1,1,0, //v3
    ]
    
    var indices:[UInt16] = [
        0,1,2,2,3,0
    ]
    
    init(_device:MTLDevice){
        super.init()
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
