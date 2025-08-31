//
//  ModelFormType.swift
//  BiteLog
//
//  Created by River Halverson on 8/31/25.
//

import SwiftUI

enum ModelFormType: View{
    case new
    case update(ReviewModel)
    
    var body: some View {
        switch self {
        case .new: EditEntry(vm:UpdateEditReviewModel())
            
        case .update(let review): EditEntry(vm:UpdateEditReviewModel(review: review))
        }
    }
    
}
