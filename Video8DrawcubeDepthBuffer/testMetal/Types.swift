//
//  Types.swift
//  testMetal
//
//  Created by David Dvergsten on 8/18/19.
//  Copyright © 2019 Rapid Imaging Tech. All rights reserved.
//

import simd

struct Vertex{
    var position:float3
    var color:float4
    var texture:float2
}

struct ModelConstants {
    var modelViewMatrix = matrix_identity_float4x4
}
