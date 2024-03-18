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
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

Our client Elaros is looking to support long Covid sufferers through a Long Covid Occupational Health App named Open OH that will be accessible through a mobile app.
The software should allow long covid sufferers to sign up for an account to manage and communicate their long-term condition with their employer.
<br />
It will allow for the long COVID sufferers to monitor symptoms through carrying out questionnaires and gain information through the resources section that may help to reduce their symptoms. The purpose of the resources section is to facilitate users integrating back into society and the workforce. The application should also allow users to find support at nearby clinics and should display aggregate data to support company research.


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/JokerZ75/Elaros-OH/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Built With

* [![Firebase][Firebase]][Firebase-url]
* [![Flutter][Flutter]][Flutter-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

To get the application up and running you will require:
<br />
* Flutter
    - See how to install Flutter and how to get it up and running here: [Flutter](https://docs.flutter.dev/get-started/install).
* Firebase
    - You will need to set up a Firebase account and create a Firebase project with a plan of your choosing.
    - See how to get Firebase working alongside Flutter here: [Firebase](https://firebase.google.com/docs/flutter/setup?platform=ios).

### Installation

1. Clone the repository ([How to clone a repo](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)).
2. Download the packages by running:
```zsh
  flutter pub get
```

#### Firebase

To get your firebase ready to run the application either for development or deployment we will need to activate a few things.
  * Activate authentication
      - Add
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


#### Android

* Follow this guide for setup for Android app: [Flutter Android Guide (Windows)](https://developer.android.com/studio).
* Follow this guide for setup for Android app: [Flutter Android Guide (Mac)](https://docs.flutter.dev/get-started/install/macos/mobile-android?tab=download).

#### IOS

* Follow this guide for setup for IOS app: [Flutter Android Guide (Mac)](https://docs.flutter.dev/get-started/install/macos/mobile-ios?tab=download).

### Deployment




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
