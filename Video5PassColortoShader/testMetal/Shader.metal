//
//  Shader.metal
//  testMetal
//
//  Created by David Dvergsten on 8/16/19.
//  Copyright © 2019 Rapid Imaging Tech. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};
//this is basically a match template of Constants from the renderer.swift/cpu code
struct Constants{
    float animateBy;
};

struct VertexOut{
    float4 position [[position]];
    float4 color;
};
vertex VertexOut vertex_shader(const VertexIn vertexIn [[stage_in]])
{
    VertexOut vout;
    vout.position = vertexIn.position;
    vout.color = vertexIn.color;
    return vout;
    //float4 position = float4(vertices[vertexId], 1);
    //position.x += constants.animateBy;
    //return float4(vertices[vertexId], 1);
    //return position;
}

fragment half4 fragment_shader(const VertexOut vertexIn[[stage_in]]){
    return half4(vertexIn.color);
}
