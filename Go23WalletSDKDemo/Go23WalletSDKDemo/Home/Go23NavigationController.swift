//
//  Go23NavigationController.swift
//  Go23LiteSDK
//
//  Created by luming on 2023/2/8.
//

import UIKit

class Go23NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let targets  = interactivePopGestureRecognizer?.value(forKey: "_targets") as? [NSObject] else {return}
        let targetObjc = targets[0]
        let target = targetObjc.value(forKey: "target")
        let action = Selector(("handleNavigationTransition:"))
        
        let panges = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(panges)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
