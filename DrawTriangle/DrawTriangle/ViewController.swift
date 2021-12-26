//
//  ViewController.swift
//  DrawTriangle
//
//  Created by David Dvergsten on 11/29/21.
//
import MetalKit
//import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let metalView = view as? MTKView
        else{
            fatalError("cannot create metal view")
        }
        // Do any additional setup after loading the view.

    }
}

