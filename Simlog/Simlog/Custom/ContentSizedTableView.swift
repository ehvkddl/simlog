//
//  ContentSizedTableView.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/20.
//

import UIKit

final class ResizedTableView: UITableView {
    
    private var reloadDataCompletionBlock: (() -> Void)?
    
    func reloadDataWithCompletion(_ complete: @escaping () -> Void) {
        reloadDataCompletionBlock = complete
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let block = reloadDataCompletionBlock {
            block()
        }
    }
    
}
