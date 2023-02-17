//
//  Home.swift
//  AutoScrollingTabs
//
//  Created by Seungchul Ha on 2023/02/17.
//

// If you do not want to use LazyStack,
// then follow this simple method to convert if from LazyStack to General Stack.

import SwiftUI

struct Home: View {
	
	/// View Properties
	@State private var activeTab: ProductType = .iphone
	@Namespace private var animation
	@State private var productsBasedOnType: [[Product]] = []
	@State private var animationProgress: CGFloat = 0
	
    var body: some View {
        /// For Auto Scrolling Content's
		ScrollViewReader { proxy in
			
			ScrollView(.vertical, showsIndicators: false) {
				
			/// Lazy Stack For Pinning View at Top While Scrolling
				LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
					
					Section {
						ForEach(productsBasedOnType, id: \.self) { products in
							ProductSectionView(products)
						}
					} header: {
						ScrollableTabs(proxy)
					}
					
				}
				
			}
		}
		/// For Scroll Content Offset Detection
		.coordinateSpace(name: "CONTENTVIEW")
		.navigationTitle("Apple Store")
		/// Custom NavBar Background
		.toolbarBackground(.visible, for: .navigationBar)
		.toolbarBackground(Color("Purple"), for: .navigationBar)
		/// Dark Scheme For NavBar
		.toolbarColorScheme(.dark, for: .navigationBar)
		.background {
			Rectangle()
				.fill(Color("BG"))
				.ignoresSafeArea()
		}
		.onAppear {
			/// Filtering Products Based on Product Type (Only Once)
			guard productsBasedOnType.isEmpty else { return }
			
			for type in ProductType.allCases {
				let products = products.filter { $0.type == type }
				
				productsBasedOnType.append(products)
			}
		}
    }
	
	/// Prodcuts Sectioned View
	@ViewBuilder
	func ProductSectionView(_ products: [Product]) -> some View {
		VStack(alignment: .leading, spacing: 15) {
			
			/// Safe Check
			if let firstProduct = products.first {
				Text(firstProduct.type.rawValue)
					.font(.title)
					.fontWeight(.semibold)
			}
			
			ForEach(products) { product in
				ProductRowView(product)
			}
		}
		.padding(15)
		/// - For Auto Scrolling Via ScrollViewProxy
		.id(products.type)
		.offset("CONTENTVIEW") { rect in
			let minY = rect.minY
			/// When the Content Reaches it's top then updating the current active tab
			if (minY < 30 && -minY < (rect.midY / 2) && activeTab != products.type) && animationProgress == 0 {
				withAnimation(.easeInOut(duration: 0.3)) {
					/// Safety Check
					///
					/// This is happening because we are upating it twice; to avoid this,
					/// we must distinguish between when the content is scrolled bt tap gesture and when it is scrolled naturally
					
					activeTab = (minY < 30 && -minY < (rect.midY / 2) && activeTab != products.type) ? products.type : activeTab
				}
			}
		}
	}
	
	/// Prodcut Row View
	@ViewBuilder
	func ProductRowView(_ product: Product) -> some View {
		HStack(spacing: 15) {
			Image(product.productImage)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 100, height: 100)
				.padding(10)
				.background {
					RoundedRectangle(cornerRadius: 15, style: .continuous)
						.fill(.white)
				}
			
			VStack(alignment: .leading, spacing: 8) {
				Text(product.title)
					.font(.title3)
				
				Text(product.subtitle)
					.font(.callout)
					.foregroundColor(.gray)
					.foregroundColor(Color("Purple"))
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
	
	
	/// Scrollable Tabs
	@ViewBuilder
	func ScrollableTabs(_ proxy: ScrollViewProxy) -> some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 10) {
				ForEach(ProductType.allCases, id: \.self) { type in
					Text(type.rawValue)
						.fontWeight(.semibold)
						.foregroundColor(.white)
						/// Active Tab Indicator
						.background(alignment: .bottom, content: {
							if activeTab == type {
								Capsule()
									.fill(.white)
									.frame(height: 5)
									.padding(.horizontal, -5)
									.offset(y: 15)
									.matchedGeometryEffect(id: "ACTIVETAB", in: animation)
							}
						})
						.padding(.horizontal, 15)
						.contentShape(Rectangle())
						/// Scrolling Tab's Whenever the Active tab is Updates
						.id(type.tabID)
						.onTapGesture {
							withAnimation(.easeInOut(duration: 0.3)) {
								activeTab = type
								animationProgress = 1.0
								
								/// Scrolling To the Selected Content
								proxy.scrollTo(type, anchor: .topLeading)
							}
						}
				}
			}
			.padding(.vertical, 15)
			.onChange(of: activeTab) { newValue in
				withAnimation(.easeInOut(duration: 0.3)) {
					proxy.scrollTo(newValue.tabID, anchor: .center)
				}
			}
			.checkAnimationEnd(for: animationProgress) {
				/// Reseting to Default, when the animation was finished
				animationProgress = 0.0
			}
		}
		.background {
			Rectangle()
				.fill(Color("Purple"))
				.shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
		}
	}
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}