import UIKit
import Swinject
import SwinjectStoryboard

// This enables injection of the initial view controller from the app's main
//   storyboard project settings. So, this is the starting point of the
//   dependency tree.
extension SwinjectStoryboard {
    public class func setup() {
        if AppDelegate.dependencyRegistry == nil {
            AppDelegate.dependencyRegistry = DependencyRegistryImpl(container: defaultContainer)
        }
        
        let dependencyRegistry: DependencyRegistry = AppDelegate.dependencyRegistry
        
//        func main() {
//            dependencyRegistry.container.storyboardInitCompleted(LocationSearchController.self) { r, vc in
//
//                setupData(resolver: r)
//
//                let presenter = r.resolve(LocationSearchPresenter.self)!
//
//                //NOTE: We don't have access to the constructor for this VC so we are using method injection
//                vc.configure(with: presenter
//                    ,businessMasterControllerMaker: dependencyRegistry.makeBusinessMasterViewController)
//            }
//        }
        
        func main() {
            dependencyRegistry.container.storyboardInitCompleted(BusinessLocationFinder.self) { r, vc in

                setupData(resolver: r)

                let presenter = r.resolve(LocationSearchPresenter.self)!

                //NOTE: We don't have access to the constructor for this VC so we are using method injection
                vc.configure(with: presenter
                    ,businessMasterControllerMaker: dependencyRegistry.makeBusinessMasterViewController)
            }
        }

        func setupData(resolver r: Resolver) {
            //MockedWebServer.sharedInstance.start()
        }
        
        main()
    }
}

