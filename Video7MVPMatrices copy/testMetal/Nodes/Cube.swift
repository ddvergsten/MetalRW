//
//  Plane.swift
//  testMetal
//
//  Created by David Dvergsten on 8/18/19.
//  Copyright © 2019 Rapid Imaging Tech. All rights reserved.
//

import Foundation
import MetalKit
class Cube: Primitive{
    
    override func buildVertices() {
        
        
        vertices = [
            Vertex(position: float3(-1, 1, 1),
                   color: float4(1, 0, 0, 1),
                   texture: float2(0, 0)),
            Vertex(position: float3(-1, -1, 1),
                   color: float4(0, 1, 0, 1),
                   texture: float2(0, 0)),
            Vertex(position: float3(1, -1, 1),
                   color: float4(0, 0, 1, 1),
                   texture: float2(1, 1)),
            Vertex(position: float3(1, 1, 1),
                   color: float4(1, 0, 1, 1),
                   texture: float2(1, 0)),
            
            Vertex(position: float3(-1, 1, -1),
                   color: float4(0, 0, 1, 1),
                   texture: float2(1, 1)),
            Vertex(position: float3(-1, -1, -1),
                   color: float4(0, 1, 0, 1),
                   texture: float2(0, 1)),
            Vertex(position: float3(1, -1, -1),
                   color: float4(1, 0, 0, 1),
                   texture: float2(0, 0)),
            Vertex(position: float3(1, 1, -1),
                   color: float4(1, 0, 1, 1),
                   texture: float2(1, 0))
        ]
        
        indices = [
            0,1,2,  0,2,3, //Front
            4,6,5,  4,7,6, //Back
            
            4,5,1,  4,1,0, //Left
            3,6,7,  3,2,6, //Right
            
            4,0,3,  4,3,7, //Top
            1,5,6,  1,6,2 //Bottom
        ]
    }
    
}
