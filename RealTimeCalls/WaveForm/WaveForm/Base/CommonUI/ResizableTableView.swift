//
//  ResizableTableView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 21.07.23.
//

import UIKit

final class ResizableTableView: UITableView {
    override public var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override public var intrinsicContentSize: CGSize {
        contentSize
    }
}
