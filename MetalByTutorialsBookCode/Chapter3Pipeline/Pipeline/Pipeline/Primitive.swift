//
//  Primitive.swift
//  Pipeline
//
//  Created by David Dvergsten on 11/13/20.
//

import Foundation
import MetalKit

class Primitive{
    static func makeCube(device: MTLDevice, size: Float)-> MDLMesh{
        let allocator = MTKMeshBufferAllocator(device: device)
        let mesh = MDLMesh(boxWithExtent: [size, size, size], segments: [1,1,1], inwardNormals: false, geometryType: .triangles, allocator: allocator)
        return mesh
    }
}
