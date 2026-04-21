//
//  GenerativeBackground.swift
//  Dante
//
//  Created by Antonio Navarra on 24/02/26.
//


import SwiftUI

/// A highly performant, GPU-accelerated animated background based on the poem's era.
struct GenerativeBackground: View {
    let era: String
    
    var body: some View {
        // TimelineView drives smooth 60fps animations
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                // Draw different subtle animations based on the historical era
                if era == "Medieval" {
                    drawMedievalParticles(context: context, size: size, time: time)
                } else if era == "Romantic" {
                    drawRomanticWaves(context: context, size: size, time: time)
                } else {
                    drawModernDots(context: context, size: size, time: time)
                }
            }
        }
        .ignoresSafeArea()
        // Keep it very subtle so it never distracts from the poetry text
        .opacity(0.15)
    }
    
    // MARK: - Era Drawing Routines
    
    private func drawMedievalParticles(context: GraphicsContext, size: CGSize, time: Double) {
        for i in 0..<15 {
            let speed = Double(i % 3 + 1) * 10.0
            let yPos = size.height - CGFloat((time * speed).truncatingRemainder(dividingBy: Double(size.height)))
            let xPos = CGFloat(i) * (size.width / 15) + CGFloat(sin(time + Double(i)) * 20)
            
            let rect = CGRect(x: xPos, y: yPos, width: 4, height: 4)
            context.fill(Path(ellipseIn: rect), with: .color(.orange.opacity(0.6)))
        }
    }
    
    private func drawRomanticWaves(context: GraphicsContext, size: CGSize, time: Double) {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: size.height))
        
        for x in stride(from: 0, through: size.width, by: 50) {
            let yOffset = sin((time * 0.5) + (Double(x) / 100.0)) * 50
            path.addLine(to: CGPoint(x: x, y: size.height * 0.8 + yOffset))
        }
        
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        context.fill(path, with: .color(.blue.opacity(0.3)))
    }
    
    private func drawModernDots(context: GraphicsContext, size: CGSize, time: Double) {
        for i in 0..<10 {
            let scale = CGFloat(sin(time * 2 + Double(i)) * 0.5 + 1.0)
            let rect = CGRect(x: CGFloat(i) * (size.width / 10), y: size.height / 2, width: 8 * scale, height: 8 * scale)
            context.fill(Path(ellipseIn: rect), with: .color(.gray.opacity(0.5)))
        }
    }
}