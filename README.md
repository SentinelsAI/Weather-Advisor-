# Weather Service API

A simple weather service implementation built with Jac programming language that provides weather information for Sri Lankan cities.

---

## 🌟 Features

- **Multi-city Support**: Get weather data for major Sri Lankan cities  
- **Comprehensive Data**: Temperature, humidity, wind speed, and weather conditions  
- **Walker Pattern**: Utilizes Jac's walker architecture for data processing  
- **Mock Data**: Uses predefined weather data for demonstration purposes  

---

## 📍 Supported Cities

- **Colombo**: Capital city weather data  
- **Nuwara Eliya**: Hill country weather conditions  
- **Kandy**: Central province weather information  
- **Default**: Fallback data for unsupported locations  

---

## 🧱 Code Structure

### `WeatherService` Object

- `api_key`: WeatherAPI.com API key (currently using mock data)  
- `base_url`: API endpoint URL  
- `get_weather(location)`: Returns weather data for specified location  

### `WeatherWalker`

- `location`: Target city for weather data  
- `response`: Formatted weather response  
- `weather_service`: WeatherService instance  
- `init(location)`: Initialize walker with target location  
- `report()`: Generate and display weather report  

---

## 🚀 Usage

The application automatically runs weather reports for three cities:

```jac
with entry {
    walker1 = spawn WeatherWalker("Colombo");
    walker1.report();

    walker2 = spawn WeatherWalker("Nuwara Eliya");
    walker2.report();

    walker3 = spawn WeatherWalker("Kandy");
    walker3.report();
}
