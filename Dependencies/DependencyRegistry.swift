import UIKit
import Swinject
import SwinjectStoryboard

protocol DependencyRegistry {
    var container: Container { get }
    
    typealias  BusinessCellMaker = (UITableView, IndexPath, Business) -> BusinessCell
    func makeBusinessCell(for tableView: UITableView, at indexPath: IndexPath, business: Business) -> BusinessCell
    
    typealias BusinessMasterControllerMaker = (String) -> BusinessMasterController
    func makeBusinessMasterViewController(location : String) -> BusinessMasterController
    
    typealias BusinessDetailControllerMaker = (Business, BusinessDelegate)  -> BusinessDetailController
    func makeBusinessDetailController(with business: Business, businessDelegate: BusinessDelegate) -> BusinessDetailController
  //  func makeBusinessDetailController(with business: Business, businessDelegate: BusinessDelegate) -> BusinessDetailController
}

class DependencyRegistryImpl: DependencyRegistry
{
    
    
    
    var container: Container
    
    init(container: Container) {
        
        Container.loggingFunction = nil
        
        self.container = container
        
        registerDependencies()
        registerPresenters()
        registerViewControllers()
    }
    
    func registerDependencies() {
        
        container.register(NetworkLayer.self    ) { r in NetworkLayerImpl()  }.inObjectScope(.container)
        
        container.register(TranslationLayer.self) { r in
            TranslationLayerImpl()
            }.inObjectScope(.container)
        
        container.register(ModelLayer.self){ r in
            ModelLayerImpl(networkLayer: r.resolve(NetworkLayer.self)!,
                           translationLayer: r.resolve(TranslationLayer.self)!)
            }.inObjectScope(.container)
    }
    
    
    func registerPresenters() {
        container.register(LocationSearchPresenter.self) { r in LocationSearchPresenterImpl() }
        container.register(BusinessMasterPresenter.self) { (r, modelLayer : ModelLayer,location: String)  in BusinessMasterPresenterImpl(modelLayer: r.resolve(ModelLayer.self)!, location: location) }
        
        container.register(BusinessCellPresenter.self) { (r, business: Business) in BusinessCellPresenterImpl(business: business) }
      
    }
    
    
    func registerViewControllers() {
        
//         container.register(BusinessDetailController.self) { (r, business: Business, businessDelegate: BusinessDelegate) in
//            let presenter = r.resolve(SecretDetailsPresenter.self, argument: spy)!
//            return SecretDetailsViewController(with: presenter, and: delegate)
//        }
//        
        
        
//        container.register(BusinessMasterController.self) { (r, businessCellMaker : @escaping BusinessCellMaker) in
//            let presenter = r.resolve(BusinessMasterPresenter.self, arguments: r.resolve(ModelLayer.self)!,location: location)!
//
        
        container.register(BusinessMasterController.self) { (r, location: String) in
            let presenter = r.resolve(BusinessMasterPresenter.self, arguments: r.resolve(ModelLayer.self)!,location)!
            
            //NOTE: We don't have access to the constructor for this VC so we are using method injection
            let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "BusinessMasterController") as! BusinessMasterController
            vc.configure(with: presenter,  businessDetailControllerMaker: self.makeBusinessDetailController, businessCellMaker: self.makeBusinessCell)
            return vc
        }
    }
    
    func makeBusinessCell(for tableView: UITableView, at indexPath: IndexPath, business: Business) -> BusinessCell {
        let presenter = container.resolve(BusinessCellPresenter.self, argument: business)!
        let cell = BusinessCell.dequeue(from: tableView, for: indexPath, with: presenter)
        return cell
    }
    
    func makeBusinessMasterViewController(location: String) -> BusinessMasterController {
        return container.resolve(BusinessMasterController.self, argument: location)!
    }
    
    
//    func makeBusinessMasterViewController(with location : String) -> BusinessMasterController {
//
//        return container.resolve(BusinessMasterController.self, argument: location)!
//
//    }
    
    func makeBusinessDetailController(with business: Business, businessDelegate: BusinessDelegate) -> BusinessDetailController {
        
        return container.resolve(BusinessDetailController.self, arguments: business, businessDelegate)!
      //  return container.resolve(BusinessDetailController.self, argument: business, delegate)!
    }
    
    
    
  
    
}
