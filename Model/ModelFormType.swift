//
//  ModelFormType.swift
//  BiteLog
//
//  Created by River Halverson on 8/31/25.
//

import SwiftUI

enum ModelFormType: Identifiable, View{
    case new
    case update(ReviewModel)
    var id: String {
        String(describing: self)
    }
    
    var body: some View {
        switch self {
        case .new: EditEntry(viewModel:UpdateEditReviewModel())
            
        case .update(let review): EditEntry(viewModel:UpdateEditReviewModel(review: review))
        }
    }
    
}
