import requests;
import os;


class WeatherService {
    """\n        Initialize weather service with optional API key\n        Args:\n            api_key (str): OpenWeatherMap API key\n            use_mock (bool): Force mock data even with valid API key\n        """
    def init(self: WeatherService, api_key: Any = None, use_mock: Any = False) {
        self.api_key = api_key;
        self.base_url = 'https://api.openweathermap.org/data/2.5/weather';
        self.use_mock = use_mock;
        self.mock_data =

            {'Colombo' :
            {'temperature' : 31 , 'humidity' : 75 , 'wind_speed' : 12 , 'conditions' : 'Partly Cloudy' } , 'Nuwara Eliya' :
            {'temperature' : 18 , 'humidity' : 82 , 'wind_speed' : 5 , 'conditions' : 'Mist' } , 'Kandy' :
            {'temperature' : 28 , 'humidity' : 70 , 'wind_speed' : 8 , 'conditions' : 'Sunny' } , 'Default' :
            {'temperature' : 30 , 'humidity' : 65 , 'wind_speed' : 10 , 'conditions' : 'Clear Sky' } };
    }

    """\n        Fetch weather data from API or mock\n        Args:\n            location (str): City name\n        Returns:\n            dict: Weather data\n        """
    def get_weather(self: WeatherService, location: Any) {
        if self.use_mock {
            return self._get_mock_weather(location);
        }
        return (self._get_api_weather(location) or self._get_mock_weather(location) );
    }

    """\n        Fetch real weather data from OpenWeatherMap\n        Args:\n            location (str): City name\n        Returns:\n            dict/None: Weather data or None if failed\n        """
    def _get_api_weather(self: WeatherService, location: Any) {
        try { params =
            {'q' : f"{location}',LK'" , 'appid' : self.api_key , 'units' : 'metric' }; response =
            requests.get(self.base_url, params=params, timeout=5); response.raise_for_status(); data =
            response.json(); return
        {'temperature' : data[ 'main' ][ 'temp' ] , 'humidity' : data[ 'main' ][ 'humidity' ] , 'wind_speed' : data[ 'wind' ][ 'speed' ] , 'conditions' : data[ 'weather' ][ 0 ][ 'description' ].title() };  } except (requests.RequestException, KeyError, ValueError) as e { print(f"'API Error for '{location}': '{str(e)}"); return None;  }
    }

    """\n        Get mock weather data\n        Args:\n            location (str): City name\n        Returns:\n            dict: Mock weather data\n        """
    def _get_mock_weather(self: WeatherService, location: Any) {
        normalized_loc = location.title();
        return self.mock_data.get(normalized_loc, self.mock_data[ 'Default' ]);
    }
}

