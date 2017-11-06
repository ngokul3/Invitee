import UIKit
import Swinject
import SwinjectStoryboard

protocol DependencyRegistry {
    var container: Container { get }
    
    typealias  BusinessCellMaker = (UITableView, IndexPath, Business, BusinessMasterController) -> BusinessCell
    func makeBusinessCell(for tableView: UITableView, at indexPath: IndexPath, business: Business, businessViewDelegate : BusinessMasterController) -> BusinessCell
    
    typealias BusinessMasterControllerMaker = (String) -> BusinessMasterController
    func makeBusinessMasterViewController(location : String) -> BusinessMasterController
    
//    typealias BusinessDetailControllerMaker = (Business, BusinessDelegate)  -> BusinessDetailController
//    func makeBusinessDetailController(with business: Business, businessDelegate: BusinessDelegate) -> BusinessDetailController
//
    typealias BusinessNotificationControllerMaker = ([Business]) -> NotificationController
    func makeBusinessNotificationController(businesses: [Business]) -> NotificationController
    
    typealias NotificationTypeMaker = ([Business], NotificationType)-> Void
    func makeNotificationType(businesses: [Business] ,notificationType : NotificationType)
    
   
  //  func makeBusinessDetailController(with business: Business, businessDelegate: BusinessDelegate) -> BusinessDetailController
}

class DependencyRegistryImpl: DependencyRegistry
{
    
    func makeNotificationType(businesses: [Business] ,notificationType : NotificationType)
    {
        notificationType.sendNotification(businesses: businesses)
    }
    
    
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
        container.register(NotificationPresenter.self){(r, businesses: [Business]) in NotificationPresenterImpl(businesses: businesses)}
    }
    
    
    func registerViewControllers() {
 
        
        container.register(BusinessMasterController.self) { (r, location: String) in
            let presenter = r.resolve(BusinessMasterPresenter.self, arguments: r.resolve(ModelLayer.self)!,location)!
            
            //NOTE: We don't have access to the constructor for this VC so we are using method injection
            let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "BusinessMasterController") as! BusinessMasterController
            vc.configure(with: presenter,  businessCellMaker: self.makeBusinessCell, businessNotificationMaker : self.makeBusinessNotificationController,
                  businessNotificationControllerMaker : self.makeBusinessNotificationController )
            return vc
        }
        
        container.register(NotificationController.self){(r, businesses: [Business]) in
            let presenter = r.resolve(NotificationPresenter.self, argument: businesses)!
            let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "NotificationController") as! NotificationController
            vc.configure(with: presenter, notificationTypeMaker : self.makeNotificationType)
            return vc
        }
    }
    func makeBusinessCell(for tableView: UITableView, at indexPath: IndexPath, business: Business, businessViewDelegate : BusinessMasterController) -> BusinessCell {
        let presenter = container.resolve(BusinessCellPresenter.self, argument: business)!
        let cell = BusinessCell.dequeue(from: tableView, for: indexPath, with: presenter, businessViewDelegate : businessViewDelegate)
        return cell
    }
    
    func makeBusinessMasterViewController(location: String) -> BusinessMasterController {
        return container.resolve(BusinessMasterController.self, argument: location)!
    }
    
//    func makeBusinessDetailController(with business: Business, businessDelegate: BusinessDelegate) -> BusinessDetailController {
//        
//        return container.resolve(BusinessDetailController.self, arguments: business, businessDelegate)!
//      
//    }
//    
    
    func makeBusinessNotificationController(businesses: [Business]) -> NotificationController{
        return container.resolve(NotificationController.self, argument: businesses)!
    }
  
    
}
