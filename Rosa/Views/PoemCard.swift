//
//  PoemCard.swift
//  Dante
//
//  Created by Antonio Navarra on 24/02/26.
//


import SwiftUI

/// A styled card component designed to look like a classic printed book page.
struct PoemCard: View {
    let poem: Poem
    @State private var isPressed: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(poem.title)
                .font(.system(.headline, design: .serif))
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Text(poem.author)
                .font(.system(.subheadline, design: .serif))
                .italic()
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            Spacer()
            
            // Classic Category Badge
            Text(poem.category.displayName.uppercased())
                .font(.system(.caption2, design: .serif))
                .fontWeight(.bold)
                .tracking(1.5)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.primary.opacity(0.05))
                .overlay(Rectangle().stroke(Color.primary.opacity(0.2), lineWidth: 0.5))
        }
        .padding(16)
        .frame(width: 160, height: 210, alignment: .topLeading)
        // Adaptable paper-style background
        .background(Color(UIColor.secondarySystemGroupedBackground))
        // Classic book page border with minimal rounding
        .overlay(
            Rectangle()
                .stroke(Color.primary.opacity(0.15), lineWidth: 1)
        )
        .cornerRadius(4)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 2)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
    }
}
