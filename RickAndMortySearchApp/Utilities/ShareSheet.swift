//
//  ShareSheet.swift
//  RickAndMortySearchApp
//
//  Created by Suraj Raju Dhopati on 2/11/25.
//
import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    var completion: ((Bool) -> Void)? = nil 

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        controller.excludedActivityTypes = excludedActivityTypes
        
        controller.completionWithItemsHandler = { (_, completed, _, _) in
            self.completion?(completed)
        }
        
        if let popover = controller.popoverPresentationController {
            if let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }),
               let rootView = window.rootViewController?.view {
                popover.sourceView = rootView
                popover.sourceRect = CGRect(x: rootView.bounds.midX,
                                            y: rootView.bounds.midY,
                                            width: 0,
                                            height: 0)
                popover.permittedArrowDirections = []
            }
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update is needed.
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ShareSheet
        
        init(_ parent: ShareSheet) {
            self.parent = parent
        }
    }
}
