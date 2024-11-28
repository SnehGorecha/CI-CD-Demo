//
//  CoreDataManager.swift
//  BaseProject
//
//  Created by MacBook Pro  on 03/10/23.
//

import Foundation
import CoreData
import UIKit


class CoreDataManager {
    
    // MARK: - Core Data stack
    
    /// The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: AppInfo.app_name)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    
    
    /// This function will used to save coredata's context
    func saveContext () {
        let context = CoreDataManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// This is context object which is accessed from AppDelegate
    //    private static var managedObjectContext: NSManagedObjectContext {
    //        return persistentContainer.viewContext
    //    }
    
    
    func isCoreDataStoreCreated(databaseName: String) -> Bool {
        // Initialize the Core Data stack
        let container = NSPersistentContainer(name: databaseName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                // If there is an error, it means the store doesn't exist or can't be loaded.
                print("Core Data store not created: \(error)")
            }
        }
        
        return container.persistentStoreCoordinator.persistentStores.count > 0
    }
    
    
    /// To add data with entity name and it will return status (true/false)
    class func add(data: [String : Any], forEntityName: String) -> Bool {
        
        if let entity = NSEntityDescription.entity(forEntityName: forEntityName, in: self.persistentContainer.viewContext) {
            
            let object = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext)
            
            data.forEach { entityData in
                print("EntityName - \(forEntityName) && Key - \(entityData.key) && Value - \(entityData.value)")
                object.setValue(entityData.value, forKey: entityData.key)
            }
            
            do {
                try self.persistentContainer.viewContext.save()
                return true
            }
            catch(let err) {
                print("Core data add error - \(err.localizedDescription)")
                return false
            }
        }
        print("Core data add false")
        return false
    }
    
    
    /// To retrive data with predication (Optional) with entity name and it will return status (true/false) and list of data if status is true
    class func retriveData(withPrediction : [String : Any]? = nil, forEntityName: String) -> (Bool, [NSFetchRequestResult]?) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: forEntityName)
        
        if let prediction = self.getPrediction(from: withPrediction) {
            fetchRequest.predicate = prediction
        }
        print("\nCore data retrive FetchRequest - \(fetchRequest)\n")
        
        do {
            let result = try self.persistentContainer.viewContext.fetch(fetchRequest)
            print("Core data retrive Result - \(result)")
            return (true, result)
        }
        catch (let err) {
            print("Core data retrive error - \(err.localizedDescription)")
            return (false, nil)
        }
    }
    
    
    /// To delete from with prediction (Optional) with entity name and it will return status (true/false)
    class func delete(mulitple_values: Bool = false, withPrediction : [String : Any]? = nil, forEntityName: String) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: forEntityName)
        
        if let prediction = self.getPrediction(from: withPrediction) {
            fetchRequest.predicate = prediction
        }
        print("\nCore data delete FetchRequest - \(fetchRequest)\n")
        
        do {
            let data = try self.persistentContainer.viewContext.fetch(fetchRequest)
            
            // DELETE MULTIPLE VALUES
            if mulitple_values {
                
                for single_data in data {
                    if let obj_data = single_data as? NSManagedObject {
                        self.persistentContainer.viewContext.delete(obj_data)
                    } else {
                        print("Core data delete false - 1 for Multiple values")
                        return false
                    }
                }
                
            } else {
                
                // DELETE SINGLE VALUE
                if let first_data = data.first as? NSManagedObject {
                    self.persistentContainer.viewContext.delete(first_data)
                } else {
                    print("Core data delete false - 1 for Single value")
                    return false
                }
            }
            
            
            do {
                try self.persistentContainer.viewContext.save()
                return true
            }
            catch (let err) {
                print("Core data delete error 1 - \(err.localizedDescription)")
                return false
            }
            
        } catch (let err) {
            print("Core data delete error 2 - \(err.localizedDescription)")
            return false
        }
    }
    
    
    /// To update data with prediction (Optional) with entity name and it will return status (true/false)
    class func update(data: [String : Any], withPrediction : [String : Any]? = nil, forEntityName: String) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: forEntityName)
        
        if let prediction = self.getPrediction(from: withPrediction) {
            fetchRequest.predicate = prediction
        }
        
        print("\nCore data update FetchRequest - \(fetchRequest)\n")
        
        do {
            if let data_to_update = try self.persistentContainer.viewContext.fetch(fetchRequest).first as? NSManagedObject {
                data.forEach { obj in
                    data_to_update.setValue(obj.value, forKey: obj.key)
                }
                do {
                    try self.persistentContainer.viewContext.save()
                    return true
                }
                catch (let err)  {
                    print("Core data update error 1 - \(err.localizedDescription)")
                    return false
                }
            } else {
                print("Core data update false 1")
                return false
            }
        } catch (let err) {
            print("Core data update error 2 - \(err.localizedDescription)")
            return false
        }
    }
    
    
    fileprivate static func getPrediction(from prediction : [String:Any]?) -> NSPredicate?  {
        if let prediction = prediction , prediction.count > 0 {
            
            var predicates: [NSPredicate] = []
            
            for (key, value) in prediction {
                if let formattedValue = value as? CVarArg {
                    let predicate = NSPredicate(format: "\(key) = %@", formattedValue)
                    predicates.append(predicate)
                }
            }
            
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            return compoundPredicate
        }
        
        return  nil
        
    }
    
}
