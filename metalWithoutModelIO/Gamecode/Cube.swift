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
    
    var bordercolor:vector_float4 = vector_float4(1.0, 1.0, 1.0, 1.0)
    var triangleVertices:[AAPLVertex] = []
    var position:float3 = float3(0.0, 0.0, 0.0)
    var translation:float4x4  {
        let tr:float4x4 = float4x4(translation: position)
        return tr
    }
    func CreateModel(red:Float, green:Float, blue:Float, cubesize:Float, bordersize:Float){
        //let color:vector_float4 = vector_float4(red, green, blue, 1.0)
        let cubeSizeHalf:Float = cubesize / 2.0
        let cubeSizeFull:Float = cubesize
        let cubeColorSizeHalf:Float = cubeSizeHalf - bordersize
        let cubeColorSizeFull:Float = cubeSizeFull - 2 * bordersize
        let zvalue:Float = 0.0
         triangleVertices =
        [
            //front side//////////////////////////////////////
            AAPLVertex(position: vector_float3((Float(cubeColorSizeHalf)), Float(-cubeColorSizeHalf), Float(zvalue)), color: frontColor),
            AAPLVertex(position: vector_float3(-(Float(cubeColorSizeHalf)), -Float(cubeColorSizeHalf), Float(zvalue)), color: frontColor),
            AAPLVertex(position: vector_float3(Float(cubeColorSizeHalf), Float(cubeColorSizeHalf), Float(zvalue)), color: frontColor),
            
            AAPLVertex(position: vector_float3((Float(cubeColorSizeHalf)), Float(cubeColorSizeHalf), Float(zvalue)), color: frontColor),
            AAPLVertex(position: vector_float3(-(Float(cubeColorSizeHalf)), -Float(cubeColorSizeHalf), Float(zvalue)), color: frontColor),
            AAPLVertex(position: vector_float3(Float(-cubeColorSizeHalf), Float(cubeColorSizeHalf), Float(zvalue)), color: frontColor),
            
            //border top
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), Float(cubeColorSizeHalf ), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), Float(cubeSizeHalf), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), Float(cubeSizeHalf), Float(zvalue)), color: bordercolor),

            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), Float(cubeColorSizeHalf ), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), Float(cubeSizeHalf), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), Float(cubeColorSizeHalf ), Float(zvalue)), color: bordercolor),
            //border bottom
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), -Float(cubeSizeHalf ), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), -Float(cubeColorSizeHalf), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeColorSizeHalf), Float(zvalue)), color: bordercolor),

            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), -Float(cubeSizeHalf ), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), -Float(cubeColorSizeHalf), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeSizeHalf ), Float(zvalue)), color: bordercolor),
            //border left
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), -Float(cubeSizeHalf ), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), Float(cubeSizeHalf), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3(-Float(cubeColorSizeHalf), Float(cubeSizeHalf), Float(zvalue)), color: bordercolor),

            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), -Float(cubeSizeHalf ), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3(-(Float(cubeColorSizeHalf)), Float(cubeSizeHalf), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3(-Float(cubeColorSizeHalf), -Float(cubeSizeHalf ), Float(zvalue)), color: bordercolor),

            //border right
            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), -Float(cubeSizeHalf ), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), Float(cubeSizeHalf), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeColorSizeHalf), Float(cubeSizeHalf), Float(zvalue)), color: bordercolor),

            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), -Float(cubeSizeHalf ), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3((Float(cubeColorSizeHalf)), Float(cubeSizeHalf), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeColorSizeHalf), -Float(cubeSizeHalf ), Float(zvalue)), color: bordercolor),
            
            
            //back side///////////////////////////////////
            AAPLVertex(position: vector_float3((Float(cubeColorSizeHalf)), Float(-cubeColorSizeHalf), Float(zvalue + cubeSizeFull)), color: backColor),
            AAPLVertex(position: vector_float3(Float(cubeColorSizeHalf), Float(cubeColorSizeHalf), Float(zvalue + cubeSizeFull)), color: backColor),
            AAPLVertex(position: vector_float3(-(Float(cubeColorSizeHalf)), -Float(cubeColorSizeHalf), Float(zvalue + cubeSizeFull)), color: backColor),
            
            AAPLVertex(position: vector_float3((Float(cubeColorSizeHalf)), Float(cubeColorSizeHalf), Float(zvalue + cubeSizeFull)), color: backColor),
            AAPLVertex(position: vector_float3(Float(-cubeColorSizeHalf), Float(cubeColorSizeHalf), Float(zvalue + cubeSizeFull)), color: backColor),
            AAPLVertex(position: vector_float3(-(Float(cubeColorSizeHalf)), -Float(cubeColorSizeHalf), Float(zvalue + cubeSizeFull)), color: backColor),
            //border top
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), Float(cubeSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), Float(cubeColorSizeHalf ), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), Float(cubeSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),

            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), Float(cubeSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), Float(cubeColorSizeHalf ), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), Float(cubeColorSizeHalf ), Float(zvalue + cubeSizeFull)), color: bordercolor),
            //border bottom
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), -Float(cubeColorSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), -Float(cubeSizeHalf ), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeColorSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),

            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), -Float(cubeColorSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), -Float(cubeSizeHalf ), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeSizeHalf ), Float(zvalue + cubeSizeFull)), color: bordercolor),
            //border left
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), Float(cubeSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), -Float(cubeSizeHalf ), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(-Float(cubeColorSizeHalf), Float(cubeSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),

            AAPLVertex(position: vector_float3(-(Float(cubeColorSizeHalf)), Float(cubeSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(-(Float(cubeSizeHalf)), -Float(cubeSizeHalf ), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(-Float(cubeColorSizeHalf), -Float(cubeSizeHalf ), Float(zvalue + cubeSizeFull)), color: bordercolor),
            //border right
            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), Float(cubeSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), -Float(cubeSizeHalf ), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeColorSizeHalf), Float(cubeSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),

            AAPLVertex(position: vector_float3((Float(cubeColorSizeHalf)), Float(cubeSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), -Float(cubeSizeHalf ), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeColorSizeHalf), -Float(cubeSizeHalf ), Float(zvalue + cubeSizeFull)), color: bordercolor),
            
            
            //right side//////////////////////////////////////
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), Float(cubeColorSizeHalf), Float(zvalue + bordersize)), color: rightColor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeColorSizeHalf), Float(zvalue  + bordersize + cubeColorSizeFull)), color: rightColor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeColorSizeHalf), Float(zvalue + bordersize)), color: rightColor),

            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), Float(cubeColorSizeHalf), Float(zvalue + bordersize)), color: rightColor),
            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), Float(cubeColorSizeHalf), Float(zvalue  + bordersize + cubeColorSizeFull)), color: rightColor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeColorSizeHalf), Float(zvalue  + bordersize + cubeColorSizeFull)), color: rightColor),
            //front border
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeSizeHalf), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), Float(cubeSizeHalf), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), Float(cubeSizeHalf), Float(zvalue + bordersize)), color: bordercolor),

            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), -Float(cubeSizeHalf), Float(zvalue)), color: bordercolor),
            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), Float(cubeSizeHalf), Float(zvalue + bordersize)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeSizeHalf), Float(zvalue + bordersize)), color: bordercolor),
            //back border
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeSizeHalf), Float(zvalue + cubeColorSizeFull + bordersize)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), Float(cubeSizeHalf), Float(zvalue + cubeColorSizeFull + bordersize)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), Float(cubeSizeHalf), Float(zvalue + bordersize + cubeColorSizeFull + bordersize)), color: bordercolor),

            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), -Float(cubeSizeHalf), Float(zvalue + cubeColorSizeFull + bordersize)), color: bordercolor),
            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), Float(cubeSizeHalf), Float(zvalue + bordersize + cubeColorSizeFull + bordersize)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeSizeHalf), Float(zvalue + bordersize + cubeColorSizeFull + bordersize)), color: bordercolor),
            //top border
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), Float(cubeColorSizeHalf), Float(zvalue )), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), Float(cubeSizeHalf), Float(zvalue )), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), Float(cubeSizeHalf), Float(zvalue + cubeSizeFull )), color: bordercolor),

            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), Float(cubeColorSizeHalf), Float(zvalue )), color: bordercolor),
            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), Float(cubeSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), Float(cubeColorSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),
            //bottom border
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeSizeHalf), Float(zvalue )), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeColorSizeHalf), Float(zvalue )), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeColorSizeHalf), Float(zvalue + cubeSizeFull )), color: bordercolor),

            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), -Float(cubeSizeHalf), Float(zvalue )), color: bordercolor),
            AAPLVertex(position: vector_float3((Float(cubeSizeHalf)), -Float(cubeColorSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),
            AAPLVertex(position: vector_float3(Float(cubeSizeHalf), -Float(cubeSizeHalf), Float(zvalue + cubeSizeFull)), color: bordercolor),
            //left side///////////////////////////////////////
            AAPLVertex(position: vector_float3(-Float(cubeSizeHalf), Float(cubeColorSizeHalf), Float(zvalue + bordersize)), color: leftColor),
            AAPLVertex(position: vector_float3(-Float(cubeSizeHalf), -Float(cubeColorSizeHalf), Float(zvalue + bordersize)), color: leftColor),
            AAPLVertex(position: vector_float3(-Float(cubeSizeHalf), -Float(cubeColorSizeHalf), Float(zvalue + cubeColorSizeFull + bordersize)), color: leftColor),
            
            AAPLVertex(position: vector_float3((-Float(cubeSizeHalf)), Float(cubeColorSizeHalf), Float(zvalue + bordersize)), color: leftColor),
            AAPLVertex(position: vector_float3(-Float(cubeSizeHalf), -Float(cubeColorSizeHalf), Float(zvalue + cubeColorSizeFull + bordersize)), color: leftColor),
            AAPLVertex(position: vector_float3((-Float(cubeSizeHalf)), Float(cubeColorSizeHalf), Float(zvalue + cubeColorSizeFull + bordersize)), color: leftColor),
            
            //top side/////////////////////////////////////////////
            AAPLVertex(position: vector_float3(Float(cubeColorSizeHalf), Float(cubeSizeHalf), Float(zvalue + bordersize)), color: topColor),
            AAPLVertex(position: vector_float3(-Float(cubeColorSizeHalf), Float(cubeSizeHalf), Float(zvalue + cubeColorSizeFull + bordersize)), color: topColor),
            AAPLVertex(position: vector_float3(Float(cubeColorSizeHalf), Float(cubeSizeHalf), Float(zvalue + cubeColorSizeFull + bordersize)), color: topColor),
            
            AAPLVertex(position: vector_float3(Float(cubeColorSizeHalf), Float(cubeSizeHalf), Float(zvalue + bordersize)), color: topColor),
            AAPLVertex(position: vector_float3(-Float(cubeColorSizeHalf), Float(cubeSizeHalf), Float(zvalue + bordersize)), color: topColor),
            AAPLVertex(position: vector_float3(-Float(cubeColorSizeHalf), Float(cubeSizeHalf), Float(zvalue + cubeColorSizeFull + bordersize)), color: topColor),
            
            //bottom side////////////////////////////////////////////////
            AAPLVertex(position: vector_float3(Float(cubeColorSizeHalf), -Float(cubeSizeHalf), Float(zvalue + bordersize)), color: bottomColor),
            AAPLVertex(position: vector_float3(Float(cubeColorSizeHalf), -Float(cubeSizeHalf), Float(zvalue + cubeColorSizeFull + bordersize)), color: bottomColor),
            AAPLVertex(position: vector_float3(-Float(cubeColorSizeHalf), -Float(cubeSizeHalf), Float(zvalue + cubeColorSizeFull + bordersize)), color: bottomColor),
            
            AAPLVertex(position: vector_float3(Float(cubeColorSizeHalf), -Float(cubeSizeHalf), Float(zvalue + bordersize)), color: bottomColor),
            AAPLVertex(position: vector_float3(-Float(cubeColorSizeHalf), -Float(cubeSizeHalf), Float(zvalue + cubeColorSizeFull + bordersize)), color: bottomColor),
            AAPLVertex(position: vector_float3(-Float(cubeColorSizeHalf), -Float(cubeSizeHalf), Float(zvalue + bordersize)), color: bottomColor),
            
        ]
        //return triangleVertices
    }
    
}
