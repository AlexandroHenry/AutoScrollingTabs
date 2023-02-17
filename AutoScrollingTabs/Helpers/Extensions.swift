//
//  Extensions.swift
//  AutoScrollingTabs
//
//  Created by Seungchul Ha on 2023/02/18.
//

import SwiftUI

extension [Product] {
	
	/// Return the Array's First Product Type
	/// Since our product array contains only one type, this extension will be useful to retrieve the prodcut type.
	/// If you have mixed products, don't use this extension.
	
	var type: ProductType {
		if let firstProduct = self.first {
			return firstProduct.type
		}
		
		return .iphone
	}
}

/// Sroll Content Offset
struct OffsetKey: PreferenceKey {
	static var defaultValue: CGRect = .zero
	
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
		value = nextValue()
	}
}

extension View {
	@ViewBuilder
	func offset(_ coordinateSpace: AnyHashable, completion: @escaping (CGRect) -> ()) -> some View {
		self
			.overlay {
				GeometryReader {
					let rect = $0.frame(in: .named(coordinateSpace))
					
					Color.clear
						.preference(key: OffsetKey.self, value: rect)
						.onPreferenceChange(OffsetKey.self, perform: completion)
				}
			}
	}
}

/// To reset the animation progress, there are two ways:
/// 1. Using the delay dispatch queue function to reset it,
/// 2. A more perfect way is to create an Animatable modifier to notify us when the animation is finished exactly.
///  You can also use this modifier to return the animation progress

extension View {
	@ViewBuilder
	func checkAnimationEnd<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> ()) -> some View {
		self
			.modifier(AnimationEndCallback(for: value, onEnd: completion))
	}
}

/// Animation OnEnd CallBack
fileprivate struct AnimationEndCallback<Value: VectorArithmetic>: Animatable, ViewModifier {
	var animatableData: Value {
		didSet {
			checkIfFinished()
		}
	}
	
	var endValue: Value
	var onEnd: () -> ()
	
	init(for value: Value, onEnd: @escaping () -> Void) {
		self.animatableData = value
		self.endValue = value
		self.onEnd = onEnd
	}
	
	func body(content: Content) -> some View {
		content
	}
	
	private func checkIfFinished() {
		if endValue == animatableData {
			DispatchQueue.main.async {
				onEnd()
			}
		}
	}
}
