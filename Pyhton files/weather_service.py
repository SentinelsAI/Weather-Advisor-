# weather_service.py
import requests
import os

class WeatherService:
    def __init__(self, api_key=None, use_mock=False):
        """
        Initialize weather service with optional API key
        Args:
            api_key (str): OpenWeatherMap API key
            use_mock (bool): Force mock data even with valid API key
        """
        self.api_key = api_key
        self.base_url = "https://api.openweathermap.org/data/2.5/weather"
        self.use_mock = use_mock
        self.mock_data = {
            "Colombo": {
                "temperature": 31,
                "humidity": 75,
                "wind_speed": 12,
                "conditions": "Partly Cloudy"
            },
            "Nuwara Eliya": {
                "temperature": 18,
                "humidity": 82,
                "wind_speed": 5,
                "conditions": "Mist"
            },
            "Kandy": {
                "temperature": 28,
                "humidity": 70,
                "wind_speed": 8,
                "conditions": "Sunny"
            },
            "Default": {
                "temperature": 30,
                "humidity": 65,
                "wind_speed": 10,
                "conditions": "Clear Sky"
            }
        }

    def get_weather(self, location):
        """
        Fetch weather data from API or mock
        Args:
            location (str): City name
        Returns:
            dict: Weather data
        """
        if self.use_mock :
            return self._get_mock_weather(location)
        
        return self._get_api_weather(location) or self._get_mock_weather(location)

    def _get_api_weather(self, location):
        """
        Fetch real weather data from OpenWeatherMap
        Args:
            location (str): City name
        Returns:
            dict/None: Weather data or None if failed
        """
        try:
            params = {
                'q': f"{location},LK",
                'appid': self.api_key,
                'units': 'metric'
            }
            response = requests.get(self.base_url, params=params, timeout=5)
            response.raise_for_status()
            data = response.json()
            
            return {
                'temperature': data['main']['temp'],
                'humidity': data['main']['humidity'],
                'wind_speed': data['wind']['speed'],
                'conditions': data['weather'][0]['description'].title()
            }
        except (requests.RequestException, KeyError, ValueError) as e:
            print(f"API Error for {location}: {str(e)}")
            return None

    def _get_mock_weather(self, location):
        """
        Get mock weather data
        Args:
            location (str): City name
        Returns:
            dict: Mock weather data
        """
        normalized_loc = location.title()
        return self.mock_data.get(normalized_loc, self.mock_data["Default"])