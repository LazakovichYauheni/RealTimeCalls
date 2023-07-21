//
//  UIBezierPath+Extensions.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.03.23.
//

import UIKit

extension UIBezierPath {
    func smoothedPath(granularity: Int) -> UIBezierPath {
        let points = cgPath.getPathElementsPoints()
        
        let smoothedPath = UIBezierPath()
        smoothedPath.lineWidth = lineWidth
        
        smoothedPath.move(to: points[0])
        
        let start = 2
        let end = points.count + 2
        
        for index in start..<end {
            let firstIndex = (points.count + index - 3) % points.count
            let secondIndex = (points.count + index - 2) % points.count
            let thirdIndex = (points.count + index - 1) % points.count
            let fourthIndex = index % points.count
            
            let point0 = points[firstIndex]
            let point1 = points[secondIndex]
            let point2 = points[thirdIndex]
            let point3 = points[fourthIndex]
            
            for i in 1..<granularity {
                let t: CGFloat = CGFloat(CGFloat(i) * (CGFloat(1) / CGFloat(granularity)))
                let tt: CGFloat = t * t
                let ttt: CGFloat = t * t * t
                
                var pi: CGPoint = CGPoint()
                
                let firstX = 2 * point1.x
                let secondX = (point2.x - point0.x) * t
                let thirdX = (2 * point0.x - 5 * point1.x + 4 * point2.x - point3.x) * tt
                let fourthX = (3 * point1.x - point0.x - 3 * point2.x + point3.x) * ttt
                
                pi.x = 0.5 * (firstX + secondX + thirdX + fourthX)
                
                let firstY = 2 * point1.y
                let secondY = (point2.y - point0.y) * t
                let thirdY = (2 * point0.y - 5 * point1.y + 4 * point2.y - point3.y) * tt
                let fourthY = (3 * point1.y - point0.y - 3 * point2.y + point3.y) * ttt
                
                pi.y = 0.5 * (firstY + secondY + thirdY + fourthY)
                smoothedPath.addLine(to: pi)
            }
            
            smoothedPath.addLine(to: point2)
        }
        
        smoothedPath.close()
        return smoothedPath
    }
}
