# flutter_local_notifications_tutorial

A Flutter project that automates the process of switching the phone to **silent mode** at a specific time (default is 2 PM) and provides notifications to remind the user to activate or deactivate silent mode. Users can also set a **custom time** for silent mode activation.

This project also demonstrates:
- **Custom fonts** using `PaulJackson.ttf`.
- **Named routes** for navigation between screens.
- **Unnamed routes** for simple navigation with `Navigator.pop` and `Navigator.push`.
- **Awesome Flutter Notifications** for locally notifying the user when silent mode is scheduled, activated, or deactivated.

## Features

- **Scheduled Silent Mode**: The app automatically switches the phone to silent mode at a pre-set time (e.g., 2 PM) each day.
- **Custom Silent Mode Time**: Users can set a custom time for silent mode activation.
- **Notifications**: Users receive notifications:
  - When silent mode is scheduled.
  - When silent mode is activated (reminder to turn on silent mode).
  - When silent mode is deactivated.
- **Action Log**: The app maintains a log of silent mode actions, which can be displayed on the settings page.
- **Custom Fonts**: The app uses custom fonts (PaulJackson.ttf).
- **Navigation**: The app demonstrates named route navigation as well as unnamed routes using `Navigator.push` and `Navigator.pop`.

## Getting Started

### Prerequisites

To get this project up and running, make sure you have Flutter installed. If you haven't installed Flutter, follow the instructions in the official Flutter documentation: [Flutter Installation](https://flutter.dev/docs/get-started/install).

### Installation

1. Clone the repository or download the project.

   ```bash
   git clone https://github.com/itshussainsprojects/flutter_local_notifications_tutorial.git
