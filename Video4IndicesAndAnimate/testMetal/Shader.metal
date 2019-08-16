//
//  Shader.metal
//  testMetal
//
//  Created by David Dvergsten on 8/16/19.
//  Copyright © 2019 Rapid Imaging Tech. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//this is basically a match template of Constants from the renderer.swift/cpu code
struct Constants{
    float animateBy;
};

vertex float4 vertex_shader(const device packed_float3 * vertices [[buffer(0)]],
                            constant Constants &constants [[buffer(1)]],
                            uint vertexId[[vertex_id]])
{
    float4 position = float4(vertices[vertexId], 1);
    position.x += constants.animateBy;
    //return float4(vertices[vertexId], 1);
    return position;
}

fragment half4 fragment_shader(){
    return half4(1,1,0,1);
}
