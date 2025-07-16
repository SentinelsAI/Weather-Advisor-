Weather Service API
A simple weather service implementation built with Jac programming language that provides weather information for Sri Lankan cities.
Features

Multi-city Support: Get weather data for major Sri Lankan cities
Comprehensive Data: Temperature, humidity, wind speed, and weather conditions
Walker Pattern: Utilizes Jac's walker architecture for data processing
Mock Data: Uses predefined weather data for demonstration purposes

Supported Cities

Colombo: Capital city weather data
Nuwara Eliya: Hill country weather conditions
Kandy: Central province weather information
Default: Fallback data for unsupported locations

Code Structure
WeatherService Object

api_key: WeatherAPI.com API key (currently using mock data)
base_url: API endpoint URL
get_weather(location): Returns weather data for specified location

WeatherWalker

location: Target city for weather data
response: Formatted weather response
weather_service: WeatherService instance
init(location): Initialize walker with target location
report(): Generate and display weather report

Usage
The application automatically runs weather reports for three cities:
jacwith entry {
    walker1 = spawn WeatherWalker("Colombo");
    walker1.report();

    walker2 = spawn WeatherWalker("Nuwara Eliya");
    walker2.report();

    walker3 = spawn WeatherWalker("Kandy");
    walker3.report();
}
Sample Output
Weather report for Colombo:
  Temperature: 28.5°C
  Condition: Partly Cloudy
  Humidity: 78%
  Wind: 12.5 km/h
  Description: Warm and humid with scattered clouds

Weather report for Nuwara Eliya:
  Temperature: 18.2°C
  Condition: Misty
  Humidity: 85%
  Wind: 8.0 km/h
  Description: Cool and misty typical hill country weather

Weather report for Kandy:
  Temperature: 24.1°C
  Condition: Light Rain
  Humidity: 82%
  Wind: 6.3 km/h
  Description: Light showers with warm temperatures
Data Structure
Each weather response includes:

location: City name
temperature: Temperature in Celsius
condition: Weather condition (e.g., "Partly Cloudy")
humidity: Humidity percentage
wind_speed: Wind speed in km/h
description: Detailed weather description
timestamp: ISO format timestamp

Installation & Running

Ensure you have Jac programming language installed
Clone this repository
Run the weather service:
bashjac run weather_service.jac


Future Enhancements

Integration with live WeatherAPI.com service
Additional Sri Lankan cities
Historical weather data
Weather forecasting capabilities
Error handling for API failures

API Reference
The code includes a WeatherAPI.com API key for future live data integration. The current implementation uses mock data for demonstration purposes.
Contributing
Feel free to contribute by:

Adding more cities
Implementing live API integration
Improving error handling
Adding weather forecasting features

License
This project is open source and available under the MIT License.
