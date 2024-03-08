//
//  ContentView.swift
//  NavigationControllerDemo
//
//  Created by bannzai on 2024/03/08.
//

import SwiftUI

struct ContentView: View {
  @State var path = NavigationPath()

  var body: some View {
    NavigationStack(path: $path) {
      StandardNavigationDemo()
    }
    .onChange(of: path) { oldValue, newValue in
      print("path changed. count: \(path.count)")
    }
  }
}

enum Route: Hashable {
  case item(id: Int)
  case product(id: Int)
}

struct StandardNavigationDemo: View {
  var body: some View {
    ForEach(0...10, id: \.self) { index in
      if index % 2 == 0 {
        NavigationLink("index:\(index)", value: Route.item(id: index))
      } else {
        NavigationLink("index:\(index)", value: Route.product(id: index))
      }
    }
    .navigationDestination(for: Route.self) { route in
      switch route {
      case .item(let id):
        ItemPage(id: id)
      case .product(id: let id):
        ProductPage(id: id)
      }
    }
  }
}

struct ItemPage: View {
  let id: Int

  var body: some View {
    Text("ItemPage \(id)")
  }
}

struct ProductPage: View {
  let id: Int

  var body: some View {
    Text("ProductPage \(id)")
  }
}

struct HomePage: View {
  @Environment(NavigationController.self) var navigationController

  @State var secondPageIsPresented = false

  var body: some View {
    VStack {
      Button {
        navigationController.push {
          SecondPage()
        }
      } label: {
        Text("Push")
      }
      .onChange(of: navigationController.path) { oldValue, newValue in
        print("NavigationController.path changed: \(newValue), count: \(newValue.count)")
      }
    }
    .navigationTitle("Home Page")
    .navigationDestination(isPresented: $secondPageIsPresented) {
      SecondPage()
    }
  }
}

struct SecondPage: View {
  @Environment(NavigationController.self) var navigationController

  var body: some View {
    VStack {
      Button {
        navigationController.pop()
      } label: {
        Text("Pop")
      }
      
      Button {
        navigationController.push {
          ThirdPage()
        }
      } label: {
        Text("Push")
      }
    }
    .navigationTitle("Second Page")
  }
}

struct ThirdPage: View {
  @Environment(\.dismiss) var dismiss
  @Environment(NavigationController.self) var navigationController

  @State var sheetIsPresented = false
  @State var fullScreenCoverIsPresented = false

  var body: some View {
    VStack {
      Button {
        navigationController.pop()
      } label: {
        Text("Pop")
      }

      Button {
        navigationController.popToRoot()
      } label: {
        Text("Pop to root")
      }
      
      Button {
        sheetIsPresented = true
      } label: {
        Text("Sheet")
      }
      .sheet(isPresented: $sheetIsPresented, content: {
        HomePage()
          .withNavigation()
      })
      
      Button {
        fullScreenCoverIsPresented = true
      } label: {
        Text("Full screen cover")
      }
      .fullScreenCover(isPresented: $fullScreenCoverIsPresented, content: {
        HomePage()
          .withNavigation()
          .toolbar {
            ToolbarItem(placement: .topBarLeading) {
              Button {
                dismiss()
              } label: {
                Image(systemName: "xmark")
              }
            }
          }
      })
    }
    .navigationTitle("Third Page")
  }
}

#Preview {
  ContentView()
}
