//
//  ViewController.swift
//  metalWithoutModelIO
//
//  Created by David Dvergsten on 12/15/21.
//

import MetalKit

class ViewController: UIViewController {

    var renderer:Renderer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let metalViewdd = view as? MTKView else{
            fatalError("could not create metal view")
        }
        renderer = Renderer(metalView: metalViewdd)
        
        
    }


}

