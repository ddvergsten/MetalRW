//
//  ViewController.swift
//  testMetal
//
//  Created by David Dvergsten on 8/15/19.
//  Copyright © 2019 Rapid Imaging Tech. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {

    var metalView: MTKView{
        return view as! MTKView
    }
    var device:MTLDevice!
    var commandQueue:MTLCommandQueue!
    var renderer = Renderer()
    override func viewDidLoad() {
        super.viewDidLoad()
        renderer.setMTKView(to: metalView) //dgd new
        
    }


}

