<a name="readme-top"></a>



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Issues][issues-shield]][issues-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/JokerZ75/Elaros-OH">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center"></h3>

  <p align="center">
    <br />
    <a href="https://github.com/JokerZ75/Elaros-OH"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    ·
    <a href="https://github.com/JokerZ75/Elaros-OH/issues">Report Bug</a>
    ·
    <a href="https://github.com/JokerZ75/Elaros-OH/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#features-and-showcase">Features and Showcase</a>
      <ul>
        <li><a href="#login">Login</a></li>
        <li><a href="#register">Register</a></li>
        <li><a href="#2fa">2FA</a></li>
        <li><a href="#home">Home</a></li>
        <li><a href="#my-health">My Health</a></li>
        <li><a href="#support">Support</a></li>
        <li><a href="#community">Community</a></li>
        <li><a href="#account">Account</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
        <li>
      <a href="#deployment-guide">Deployment</a>
      <ul>
        <li><a href="#ios-deployment">IOS Deployment</a></li>
        <li><a href="#android-deployment">Android Deployment</a></li>
      </ul>
    </li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

Our client Elaros is looking to support long Covid sufferers through a Long Covid Occupational Health App named Open OH that will be accessible through a mobile app.
The software should allow long covid sufferers to sign up for an account to manage and communicate their long-term condition with their employer.
<br />
It will allow for the long COVID sufferers to monitor symptoms by carrying out questionnaires and gain information through the resources section that may help to reduce their symptoms. The purpose of the resources section is to facilitate users integrating back into society and the workforce. The application should also allow users to find support at nearby clinics and should display aggregate data to support company research.


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/JokerZ75/Elaros-OH/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Built With

* [![Firebase][Firebase]][Firebase-url]
* [![Flutter][Flutter]][Flutter-url]
* [![Google-cloud][Google-cloud]][Google-cloud-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MAIN FEATURES -->
## Features and Showcase

### Login
![Screenshot 2024-04-03 at 13 05 24 (1)](https://github.com/JokerZ75/Elaros-OH/assets/95136337/aab5c7d4-b5ac-48dc-906b-20ce1ce6e486)
![Login-reset-pass](https://github.com/JokerZ75/Elaros-OH/assets/95136337/c8d31c3b-45cc-4711-a64c-28ad54381014)
![Google Signin](https://github.com/JokerZ75/Elaros-OH/assets/95136337/34b2a05c-1cfd-4afd-8241-28dad1452cca)

The login process is simple and fast, especially when using Google Sign in only requires a few clicks, asking the user for their email and password they will then be required to enter a code sent to their mobile.
This page also offers the option to reset a password using a link sent to the users' entered email in case they ever forget their password.

### Register
![Register](https://github.com/JokerZ75/Elaros-OH/assets/95136337/074b25b9-ad04-4a0f-95c4-dfd3b8f16cbf)

The register page includes a drawer that will slide up allowing the user to view the terms and conditions.

Registering is a 4 stage process when not signing in with Google as the user will have to enter all their details, verify their email address, and then add a phone number for 2FA entering a sent code to confirm it. The user will then have to fill out an onboarding questionnaire so we can get their pre-COVID scores.
<br />
Registering and creating an account with Google is only a 2 stage process requiring the Google sign-in and then the onboarding questionnaire making it the recommended way of using the App for ease of use.


### 2FA
![Add 2FA](https://github.com/JokerZ75/Elaros-OH/assets/95136337/95f06700-effe-4614-a6f2-11b3001bef4e)

The application includes the capabilities for 2FA when enabled the user will be required to add a phone number to their account which will be sent One-time codes that they can use to complete their login, improving application security.

### Home
![Home](https://github.com/JokerZ75/Elaros-OH/assets/95136337/44278fa8-9008-4643-844e-b173ce21d833)

The home page of the application includes:
- A button for users to quickly take a questionnaire.
- A section showing the user's current environment (weather) conditions. (CURRENTLY NOT FUNCTIONING)
- A section showing a user's three most recently taken assessments.


### My Health
![Health-graph](https://github.com/JokerZ75/Elaros-OH/assets/95136337/8412a2ed-ab69-4966-b7a0-6fe7d1a52836)

At the top of the health page are the graphs which display the severity of a user's symptoms throughout the months, they can choose between viewing these on a radar or bar chart.
<br />
<br />

![health-buttons](https://github.com/JokerZ75/Elaros-OH/assets/95136337/70de176a-dd02-4eaa-8a3f-13b57e14fcf8)

Below the graphs are the other actions that can be done on the health page
<br />
<br />

![Previous-assessments](https://github.com/JokerZ75/Elaros-OH/assets/95136337/b74b73dc-1da3-4f95-a214-f1df1a87f9f1)
![pdf](https://github.com/JokerZ75/Elaros-OH/assets/95136337/bade5413-1d70-4b86-9f22-fd749c495439)
![Questionnaire (1)](https://github.com/JokerZ75/Elaros-OH/assets/95136337/0f2e33b7-431d-4131-ae07-b9e49d62305a)

### Support
![Support](https://github.com/JokerZ75/Elaros-OH/assets/95136337/0e6a99d9-c912-48dd-bd25-a1e20329e080)

The Support page provides links to rehabilitation content helping users learn how to improve their symptoms as well as a map showing nearby medical centers which can provide help to long COVID patients.

### Community
![Community](https://github.com/JokerZ75/Elaros-OH/assets/95136337/cd514d92-8446-4516-8614-9fc242686dc7)
![Forum](https://github.com/JokerZ75/Elaros-OH/assets/95136337/3d9181a8-10c8-4753-98b8-6b083f848f84)

The community page includes a Forum the Community page itself shows the most recent and its most recent comments, more can then be viewed on the forum page itself.

![Community map](https://github.com/JokerZ75/Elaros-OH/assets/95136337/a10b96fe-5d85-413d-ade4-86cbad7f7aef)

The community page also has a community map that will show the most common symptoms within a 10,000m area only once there are more than 3 users who have taken a test within that area.



### Account

![Account](https://github.com/JokerZ75/Elaros-OH/assets/95136337/4f1ea720-79a6-4530-9dd6-8645afa9bbfd)

The account page allows the user to update their information as well, see the terms and conditions, and delete their account. 




<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

To get the application up and running you will require:
<br />
* Flutter
    - See how to install Flutter and how to get it up and running here: [Flutter](https://docs.flutter.dev/get-started/install).
* Firebase - If you are going to use your own database and not ours
    - You will need to set up a Firebase account and create a Firebase project with a plan of your choosing.
    - See how to get Firebase working alongside Flutter here: [Firebase](https://firebase.google.com/docs/flutter/setup?platform=ios).

### Installation

1. Clone the repository ([How to clone a repo](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)).
2. Download the packages by running:
```zsh
  flutter pub get
```


#### Android

* Follow this guide for setup for Android app: [Flutter Android Guide (Windows)](https://developer.android.com/studio).
* Follow this guide for setup for Android app: [Flutter Android Guide (Mac)](https://docs.flutter.dev/get-started/install/macos/mobile-android?tab=download).

#### IOS

* Follow this guide for setup for IOS app: [Flutter Android Guide (Mac)](https://docs.flutter.dev/get-started/install/macos/mobile-ios?tab=download).

#### Google Cloud - REQUIRED FOR MAPS FUNCTIONALITY

- Create an account with Google Cloud: https://cloud.google.com/?hl=en
- Create a project and navigate API & Services and the library tab.
  - Activate Maps SDK for Android and IOS.
- Navigate to the Google Maps Platform and make sure that the APIs are enabled.
- Navigate to the Keys and Credentials tab and create a new API Key.
- Copy the API key, this will need to be copied into several places in the code.
  - Copy to occupational_health\android\app\src\main\AndroidManifest.xml
    ```xml
    <manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET"/>   
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <!-- Access location -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    
    <application

        android:label="occupational_health"
        android:name="${applicationName}"
        android:icon="@mipmap/launcher_icon"
        android:enableOnBackInvokedCallback="true">
        <!-- YOUR GOOGLE MAPS API KEY -->
        <meta-data
          
                android:name="com.google.android.geo.API_KEY"
                android:value="YOUR KEY"/>
    ```
  - Copy to occupational_health\ios\Runner\AppDelegate.swift
    ```swift
    import UIKit
    import Flutter
    import GoogleMaps
    
    @UIApplicationMain
    @objc class AppDelegate: FlutterAppDelegate {
      override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        // YOUR GOOGLE MAP API KEY
        GMSServices.provideAPIKey("YOUR API KEY")
    ```
  - Copy to occupational_health\lib\pages\support_page\support_page.dart
    ```dart
    class SupportPage extends StatefulWidget {
      const SupportPage({Key? key}) : super(key: key);
    
      @override
      State<StatefulWidget> createState() => _SupportPageState();
    }
    
    class _SupportPageState extends State<SupportPage> {
    
      // YOUR GOOGLE MAPS API KEY
      final GoogleMapsPlaces _places =
          GoogleMapsPlaces(apiKey: "YOUR KEY");
    ```


#### Firebase - Optional if you want to use your own database for development or deployment

To get your firebase ready to run the application either for development or deployment using your own database and not ours we will need to activate a few things.
  * Activate authentication
      - Add email and password as a provider.
      - Activate SMS multi-factor authentication in "Sign-in method/Advanced"
        - You will also need to follow these guides enable 2FA for both IOS and Android
          - IOS: https://firebase.google.com/docs/auth/ios/multi-factor?hl=en&authuser=0#using_recaptcha_verification
          - Android: https://firebase.google.com/docs/auth/android/multi-factor?hl=en&authuser=0#before_you_begin
          - To proceed without 2FA switch the variable found at lib/services/Auth/mfa_gate.dart
            ```dart
            class _MfaGateState extends State<MfaGate> {
            bool _isVerified = false; // Make this true if you want to test without 2FA
            final AuthService _auth = AuthService();
            bool _signedInWithGoogle = false;
            ...
            ```
        - Add Google as a Sign in Provider
          - Make sure to follow the instructions given whilst going through this process.
          - IOS:
            * Add custom URL schemes to your Xcode project:
              1. Open your project configuration: click the project name in the left tree view. Select your app from the TARGETS section, then select the Info tab, and expand the URL Types                       section.
              2. Click the + button, and add a URL scheme for your reversed client ID. To find this value, open the GoogleService-Info.plist configuration file, and look for the                                  REVERSED_CLIENT_ID key. Copy the value of that key, and paste it into the URL Schemes box on the configuration page. Leave the other fields untouched.

              When completed, your config should look something similar to the following (but with your application-specific values):
              ![image](https://github.com/JokerZ75/Elaros-OH/assets/95136337/ad12c331-5ee9-454c-96d0-b50e4bb614a9)
            * You may also have to copy your Client ID from IOS/Runner/GoogleService-info.plist into the GIDClientID sections of IOS/Runner/Info.plist

  
  * Activate firestore database
      - Update its rules to:
      ```zsh
      rules_version = '2';
      service cloud.firestore {
        match /databases/{database}/documents {
          match /{document=**} {
            allow read, write: if true;
          }
        }
      }
      ```


### Deployment Guide

Once you have a working build of the application that you can run.
Follow <a href="#getting-started">Getting Started</a> for this.
<br />

#### IOS Deployment

To release the app to IOS follow this guide from the Flutter documentation: https://docs.flutter.dev/deployment/ios


#### Android Deployment

To release the app to Android follow this guide from the Flutter documentation: https://docs.flutter.dev/deployment/android#publishing-to-the-google-play-store


<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/JokerZ75/Elaros-OH.svg?style=for-the-badge
[contributors-url]: https://github.com/JokerZ75/Elaros-OH/graphs/contributors
[issues-shield]: https://img.shields.io/github/issues/JokerZ75/Elaros-OH.svg?style=for-the-badge
[issues-url]: https://github.com/JokerZ75/Elaros-OH/issues
[Flutter]: https://img.shields.io/badge/flutter-blue?style=for-the-badge&logo=flutter&logoColor=white
[Flutter-url]: https://flutter.dev/
[Firebase]: https://img.shields.io/badge/firebase-orange?style=for-the-badge&logo=firebase&logoColor=white
[Firebase-url]: https://firebase.google.com/
[Google-cloud]: https://img.shields.io/badge/google_cloud-white?style=for-the-badge&logo=googlecloud&logoColor=blue
[Google-cloud-url]: https://console.cloud.google.com/google/maps-apis/home
