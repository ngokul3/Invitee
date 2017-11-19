import UIKit
import Swinject
import SwinjectStoryboard

protocol DependencyRegistry {
    var container: Container { get }
    
    typealias  BusinessCellMaker = (UITableView, IndexPath, Business, BusinessMasterController) -> BusinessCell
    func makeBusinessCell(for tableView: UITableView, at indexPath: IndexPath, business: Business, businessViewDelegate : BusinessMasterController) -> BusinessCell
    
    typealias BusinessMasterControllerMaker = (String, String) -> BusinessMasterController
    func makeBusinessMasterViewController(location : String, term : String) -> BusinessMasterController
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
        container.register(BusinessMasterPresenter.self) { (r, modelLayer : ModelLayer,location: String, term : String)  in BusinessMasterPresenterImpl(modelLayer: r.resolve(ModelLayer.self)!, location: location, term : term) }
        
        container.register(BusinessCellPresenter.self) { (r, business: Business) in BusinessCellPresenterImpl(business: business) }
      }
    
    
    func registerViewControllers() {
 
        
        container.register(BusinessMasterController.self) { (r, location: String, term: String) in
            let presenter = r.resolve(BusinessMasterPresenter.self, arguments: r.resolve(ModelLayer.self)!,location, term)!
            
            //NOTE: We don't have access to the constructor for this VC so we are using method injection
            let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "BusinessMasterController") as! BusinessMasterController
            vc.configure(with: presenter,  businessCellMaker: self.makeBusinessCell )
            return vc
        }
        
    }
    func makeBusinessCell(for tableView: UITableView, at indexPath: IndexPath, business: Business, businessViewDelegate : BusinessMasterController) -> BusinessCell {
        let presenter = container.resolve(BusinessCellPresenter.self, argument: business)!
        let cell = BusinessCell.dequeue(from: tableView, for: indexPath, with: presenter, businessViewDelegate : businessViewDelegate)
        return cell
    }
    
    func makeBusinessMasterViewController(location: String, term : String) -> BusinessMasterController {
        return container.resolve(BusinessMasterController.self, arguments: location, term)!
    }
}
