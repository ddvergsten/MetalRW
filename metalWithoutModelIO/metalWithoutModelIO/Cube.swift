//
//  Cube.swift
//  metalWithoutModelIO
//
//  Created by David Dvergsten on 12/29/21.
//

import Foundation

class Cube:NSObject{
    override init() {
        super.init()
    }
    var topColor:vector_float4 = vector_float4(1.0, 0.0, 1.0, 1.0)
    var bottomColor:vector_float4 = vector_float4(1.0, 1.0, 1.0, 1.0)
    var leftColor:vector_float4 = vector_float4(1.0, 1.0, 0.0, 1.0)
    var rightColor:vector_float4 = vector_float4(1.0, 0.0, 0.0, 1.0)
    var frontColor:vector_float4 = vector_float4(0.0, 1.0, 0.0, 1.0)
    var backColor:vector_float4 = vector_float4(0.0, 0.0, 1.0, 1.0)
    var triangleVertices:[AAPLVertex] = []
    var position:float3 = float3(0.0, 0.0, 0.0)
    var translation:float4x4  {
        let tr:float4x4 = float4x4(translation: position)
        return tr
    }
    func CreateModel(red:Float, green:Float, blue:Float, cubesize:Float){
        var color:vector_float4 = vector_float4(red, green, blue, 1.0)
        var triangleSizeHalf:Float = cubesize / 2.0
        var triangleSizeFull:Float = cubesize
        var zvalue:Float = 0.0
         triangleVertices =
        [
            //front side
            AAPLVertex(position: vector_float3((Float(triangleSizeHalf)), Float(-triangleSizeHalf), Float(zvalue)), color: frontColor),
            AAPLVertex(position: vector_float3(-(Float(triangleSizeHalf)), -Float(triangleSizeHalf), Float(zvalue)), color: frontColor),
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue)), color: frontColor),
            
            AAPLVertex(position: vector_float3((Float(triangleSizeHalf)), Float(triangleSizeHalf), Float(zvalue)), color: frontColor),
            AAPLVertex(position: vector_float3(-(Float(triangleSizeHalf)), -Float(triangleSizeHalf), Float(zvalue)), color: frontColor),
            AAPLVertex(position: vector_float3(Float(-triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue)), color: frontColor),
            
            //back side
            AAPLVertex(position: vector_float3((Float(triangleSizeHalf)), Float(-triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: backColor),
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: backColor),
            AAPLVertex(position: vector_float3(-(Float(triangleSizeHalf)), -Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: backColor),
            
            AAPLVertex(position: vector_float3((Float(triangleSizeHalf)), Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: backColor),
            AAPLVertex(position: vector_float3(Float(-triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: backColor),
            AAPLVertex(position: vector_float3(-(Float(triangleSizeHalf)), -Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: backColor),
            
            //right side
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue)), color: rightColor),
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: rightColor),
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue)), color: rightColor),
            
            AAPLVertex(position: vector_float3((Float(triangleSizeHalf)), Float(triangleSizeHalf), Float(zvalue)), color: rightColor),
            AAPLVertex(position: vector_float3((Float(triangleSizeHalf)), Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: rightColor),
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: rightColor),
            
            //left side
            AAPLVertex(position: vector_float3(-Float(triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue)), color: leftColor),
            AAPLVertex(position: vector_float3(-Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue)), color: leftColor),
            AAPLVertex(position: vector_float3(-Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: leftColor),
            
            AAPLVertex(position: vector_float3((-Float(triangleSizeHalf)), Float(triangleSizeHalf), Float(zvalue)), color: leftColor),
            AAPLVertex(position: vector_float3(-Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: leftColor),
            AAPLVertex(position: vector_float3((-Float(triangleSizeHalf)), Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: leftColor),
            
            //top side
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue)), color: topColor),
            AAPLVertex(position: vector_float3(-Float(triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: topColor),
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: topColor),
            
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue)), color: topColor),
            AAPLVertex(position: vector_float3(-Float(triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue)), color: topColor),
            AAPLVertex(position: vector_float3(-Float(triangleSizeHalf), Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: topColor),
            
            //bottom side
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue)), color: bottomColor),
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: bottomColor),
            AAPLVertex(position: vector_float3(-Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: bottomColor),
            
            AAPLVertex(position: vector_float3(Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue)), color: bottomColor),
            AAPLVertex(position: vector_float3(-Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue + triangleSizeFull)), color: bottomColor),
            AAPLVertex(position: vector_float3(-Float(triangleSizeHalf), -Float(triangleSizeHalf), Float(zvalue)), color: bottomColor),
            
        ]
        //return triangleVertices
    }
    
}
