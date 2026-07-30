# Weather App

A simple, multi-platform weather application built with Flutter. It fetches and displays the current weather for your location or any city you search for. The app features a dynamic UI that changes its background gradient based on the weather conditions.

## Features

-   **Current Weather:** Displays temperature, condition (e.g., "Sunny", "Cloudy"), and humidity.
-   **Location-Based:** Automatically detects and shows the weather for your current location on startup.
-   **City Search:** Manually search for the weather in any city worldwide.
-   **Dynamic UI:** The background gradient and emoji change to reflect the current weather conditions (e.g., sunny, rainy, cloudy).
-   **State Management:** Utilizes the `provider` package for efficient state management.
-   **Native Integration:** A method channel is used on Android to fetch the device's current location.

## Architecture

This application follows a simple, provider-based architecture:

-   **`main.dart`**: The entry point of the application, which initializes `WeatherProvider`.
-   **`models/`**: Contains the `WeatherModel` class, which structures the data received from the API.
-   **`Providers/`**: Includes `WeatherProvider`, which handles the application's state, business logic, API calls, and UI text/color helpers.
-   **`screens/`**: The `HomeScreen` widget builds the user interface, reacting to state changes from `WeatherProvider`.
-   **`service/`**:
    -   `weather_service.dart`: A singleton service responsible for making HTTP requests to the WeatherAPI.
    -   `location_Service.dart`: A service that communicates with the native Android platform via a method channel to retrieve the device's current location.
-   **`android/`**: Contains the native Android implementation (`MainActivity.kt`) for the location service method channel, using the `FusedLocationProviderClient`.

## Getting Started

To get a local copy up and running, follow these steps.

### Prerequisites

-   Flutter SDK installed on your machine.
-   An API Key from [WeatherAPI.com](https://www.weatherapi.com/).

### Setup & Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/vishalyadu1c/weather_app.git
    ```

2.  **Navigate to the project directory:**
    ```sh
    cd weather_app
    ```

3.  **Add your API Key:**
    Open the `lib/service/weather_service.dart` file and replace the placeholder API key with your own.
    ```dart
    // In lib/service/weather_service.dart
    final String _apiKey = 'YOUR_API_KEY_HERE';
    ```

4.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

### Running the Application

1.  **Ensure you have a device connected or an emulator running.**

2.  **Run the app:**
    ```sh
    flutter run
    ```

The app requires location permissions to fetch weather for your current location. Please grant this permission when prompted.
