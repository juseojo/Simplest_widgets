//
//  OnboardingView.swift
//  Simplest_widgets
//
//  Created by seongjun cho on 11/19/24.
//  Refactored for TCA
//

import SwiftUI
import UIKit

// MARK: - Onboarding First Page View

struct OnboardingFirstPageView: View {
    let title: String

    var body: some View {
        VStack {
            if #available(iOS 18.0, *) {
                Image(systemName: "hand.wave.fill")
                    .resizable(resizingMode: .tile)
                    .foregroundColor(Color.white)
                    .frame(width: 100.0, height: 100.0)
                    .symbolEffect(.wiggle, options: .speed(0.5))
            } else {
                Image(systemName: "hand.wave.fill")
                    .resizable(resizingMode: .tile)
                    .foregroundColor(Color.white)
                    .frame(width: 100.0, height: 100.0)
            }
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

// MARK: - Onboarding Page View

struct OnboardingPageView: View {
    let imageName: String
    let title: String

    var body: some View {
        let deviceModelName = DeviceRepository.getCurrentDeviceModel()
        let bezelImage = UIImage(named: DeviceRepository.iphoneNameDictionary[deviceModelName] ?? "error") ?? UIImage(systemName: "xmark")!
        let bezel = DeviceRepository.getBezel(for: deviceModelName)
        let ratioNum = (UIScreen.main.bounds.width - 100) / bezelImage.size.width

        VStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
            ZStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(CGFloat(bezel?.radius ?? 0) * ratioNum)
                    .padding(.horizontal, (bezel?.leftPadding ?? 0) * ratioNum)
                    .padding(.vertical, (bezel?.topPadding ?? 0) * ratioNum)
                Image(uiImage: bezelImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .padding(.bottom, 40.0)
            .padding(.horizontal, 50.0)
        }
    }
}

// MARK: - Onboarding Last Page View

struct OnboardingLastPageView: View {
    let imageName: String
    let title: String
    let onComplete: () -> Void

    var body: some View {
        let deviceModelName = DeviceRepository.getCurrentDeviceModel()
        let bezelImage = UIImage(named: DeviceRepository.iphoneNameDictionary[deviceModelName] ?? "error") ?? UIImage(systemName: "xmark")!
        let bezel = DeviceRepository.getBezel(for: deviceModelName)
        let ratioNum = (UIScreen.main.bounds.width - 100) / bezelImage.size.width

        VStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
            ZStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(CGFloat(bezel?.radius ?? 0) * ratioNum)
                    .padding(.horizontal, (bezel?.leftPadding ?? 0) * ratioNum)
                    .padding(.vertical, (bezel?.topPadding ?? 0) * ratioNum - 1.0)
                Image(uiImage: bezelImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .padding(.bottom, 20.0)
            .padding(.horizontal, 50.0)
            Button {
                onComplete()
            } label: {
                Text("Start")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(6)
            }
            .padding(.bottom, 40.0)
        }
    }
}

// MARK: - Onboarding View

struct OnboardingView: View {
    let onComplete: () -> Void

    var body: some View {
        TabView {
            OnboardingFirstPageView(
                title: String(localized: "Hi, 😃\n We need home screen image for clear widget background.\n\n This tutorial can help that.\nthank you 😊")
            )
            OnboardingPageView(
                imageName: "Tutorial1",
                title: String(localized: "On your home screen,\ntouch the screen for a second")
            )
            OnboardingPageView(
                imageName: "Tutorial2",
                title: String(localized: "In edit mode, swipe the screen\nto the right until empty page")
            )
            OnboardingLastPageView(
                imageName: "Tutorial3",
                title: String(localized: "Capture your screen"),
                onComplete: onComplete
            )
        }
        .tabViewStyle(.page)
        .ignoresSafeArea(.all)
        .background(Color.gray)
    }
}

// MARK: - Preview

#Preview {
    OnboardingView(onComplete: {})
}
