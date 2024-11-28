//
//  AddTwoStepVerificationViewModel.swift
//  AddressFull
//
//  Created by MacBook Pro  on 23/11/23.
//

import Foundation
import CoreData


class AddTwoStepVerificationViewModel {
    
    
    /// Use this  function to validate two step data from two step request model
    func validate(requestModel: AddTwoStepVerificationModel) -> ValidationResult {
        
        if requestModel.selected_question.isBlank {
            return ValidationResult(is_success: false, str_error_message: ValidationMessage.please_select_two_step_verification_question())
        }
        else if requestModel.answer.isBlank {
            return ValidationResult(is_success: false, str_error_message: ValidationMessage.please_enter_two_step_verification_answer())
        }
        else {
            return ValidationResult(is_success: true, str_error_message: "")
        }
    }
    
    
    /// Use this  function to save two step verification question answer
    func saveTwoStepVerificationQuestionAnswer(userID: String, 
                                               question: String,
                                               answer: String) -> Bool {
        
        let lastIndex = CoreDataBase.Entity.TwoStepVerificationQuestion().getLastStoredIndex()
        let newIndex  = lastIndex == nil ? 0 : ((lastIndex ?? 0) + 1)

        let data = [
            CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.user_id : userID,
            CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.question_id : "\(newIndex)",
            CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.question : question,
            CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.answer : answer
        ] as [String : Any]
        
        let isDataAdded =  CoreDataManager.add(data: data, forEntityName: CoreDataBase.Entity.TwoStepVerificationQuestion.entity_name)
        
        if isDataAdded {
            CoreDataBase.Entity.TwoStepVerificationQuestion().setLastStoredIndex(value: newIndex)
        }
        
        return isDataAdded
    }
    
    
    /// Use this  function to retrive two step verification question answer
    func retrieveTwoStepVerificationQuestionAnswer(userID: String) -> [TwoStepVerificationQuestionAnswerModel]? {
        
        let predection = [
            CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.user_id : userID
        ]
        
        let twoStepVerificationData = CoreDataManager.retriveData(withPrediction: predection,forEntityName: CoreDataBase.Entity.TwoStepVerificationQuestion.entity_name)
                
        
        if twoStepVerificationData.0, let data = twoStepVerificationData.1 as? [NSManagedObject] {
            
            var two_step_verification_question_answer_model_list = [TwoStepVerificationQuestionAnswerModel]()
            
            data.forEach { nsManagedObject in
                var model = TwoStepVerificationQuestionAnswerModel()
                
                if let question = nsManagedObject.value(forKey: CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.question) as? String {
                    model.question = question
                }
                if let answer = nsManagedObject.value(forKey: CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.answer) as? String {
                    model.answer = answer
                }
                
                if let question_id = nsManagedObject.value(forKey: CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.question_id) as? String {
                    model.question_id = question_id
                }
                
                if model.question != "" && model.answer != "" && model.question_id != ""{
                    two_step_verification_question_answer_model_list.append(model)
                }
            }
            return two_step_verification_question_answer_model_list.count > 0 ? two_step_verification_question_answer_model_list : nil
        }
        return nil
    }
    
    
    /// Use this  function to update two step verification question answer
    func updateTwoStepVerificationQuestionAnswer(userID: String, question: String, answer: String,questionID: String) -> Bool {
        
        let data = [
            CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.user_id : userID,
            CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.question_id : questionID,
            CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.question : question,
            CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.answer : answer
        ] as [String : Any]
        
        return CoreDataManager.update(data: data,withPrediction: [CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.question_id : questionID], forEntityName: CoreDataBase.Entity.TwoStepVerificationQuestion.entity_name)
    }
    
    
    /// Use this  function to delete two step verification question answer
    func deleteTwoStepVerificationQuestionAnswer(userID: String, questionID: String) -> Bool {
        
        let data = [
            CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.user_id : userID,
            CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.question_id : questionID
        ] as [String : Any]
        
        return CoreDataManager.delete(withPrediction: data, forEntityName: CoreDataBase.Entity.TwoStepVerificationQuestion.entity_name)
    }
}
