//
//  ARTestView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 24/02/2025.
//

import SwiftUI
import ARKit


struct ARViewContainer: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        
        // start AR session with world tracking
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal] // or [.vertical] depending on use-case
        arView.session.run(configuration)
        
        // set delegate and assign the view to our coordinator
        arView.delegate = context.coordinator
        context.coordinator.arView = arView
        
        // add a tap gesture recognizer to handle user taps
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // update the AR view if needed.
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        weak var arView: ARSCNView?
        var firstPoint: SCNVector3?
        
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = arView else { return }
            let tapLocation = sender.location(in: arView)
            print("Tap location: \(tapLocation)")

            
//            // Hit test to find a feature point in the real world
//            let hitTestResults = arView.hitTest(tapLocation, types: .featurePoint)
//            
//            guard let hitResult = hitTestResults.first else { return }
//            let transform = hitResult.worldTransform
            
//            let configuration = ARWorldTrackingConfiguration()
//            configuration.planeDetection = [.horizontal] // or .vertical if needed
//            arView.session.run(configuration)
            
            // in place of deprecated hittest
            guard let query = arView.raycastQuery(from: tapLocation, allowing: .estimatedPlane, alignment: .any) else {
                print("Failed to create raycast query")
                return
            }
            
            let results = arView.session.raycast(query)
            print("Raycast results count: \(results.count)")
            guard let result = results.first else {
                print("No raycast results found")
                return
            }

            // get 3D world position from the raycast result
            let transform = result.worldTransform
            
            let tappedPosition = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            
            if firstPoint == nil {
                // first tap: store the point and add a red marker
                firstPoint = tappedPosition
                addMarker(at: tappedPosition, color: .red, in: arView)
            } else {
                // second tap: add a blue marker and measure the distance
                addMarker(at: tappedPosition, color: .blue, in: arView)
                if let startPoint = firstPoint {
                    let distance = calculateDistance(from: startPoint, to: tappedPosition)
                    displayDistance(distance, in: arView)
                }
                // reset for next measurement
                firstPoint = nil
            }
            // add reset button - so resets blue and red marker
        }
        
        func addMarker(at position: SCNVector3, color: UIColor, in arView: ARSCNView) {
            let sphere = SCNSphere(radius: 0.005)
            sphere.firstMaterial?.diffuse.contents = color
            let markerNode = SCNNode(geometry: sphere)
            markerNode.position = position
            arView.scene.rootNode.addChildNode(markerNode)
        }
        
        func calculateDistance(from start: SCNVector3, to end: SCNVector3) -> Float {
            let dx = end.x - start.x
            let dy = end.y - start.y
            let dz = end.z - start.z
            return sqrt(dx * dx + dy * dy + dz * dz)
        }
        
        func displayDistance(_ distance: Float, in arView: ARSCNView) {
            DispatchQueue.main.async {
                // create a label to display the measured distance
                let label = UILabel(frame: CGRect(x: 0, y: 40, width: arView.frame.width, height: 50))
                label.textAlignment = .center
                label.textColor = .white
                label.font = UIFont.boldSystemFont(ofSize: 24)
                label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                label.text = String(format: "Distance: %.2f m", distance)
                
                // add the label as a subview to the AR view
                arView.addSubview(label)
                
                // remove the label after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    label.removeFromSuperview()
                }
            }
        }
    }
}


struct ARTestView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                // also pause the AR session when this is clicked
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .padding()
            }
        }
    }
}
