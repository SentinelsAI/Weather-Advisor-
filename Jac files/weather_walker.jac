# weather_walker.jac
import:py requests;
import:py os;

# WeatherService node definition
node WeatherService {
    has api_key: str = None;
    has use_mock: bool = False;
    has base_url: str = "https://api.openweathermap.org/data/2.5/weather";
    has mock_data: dict;
    has valid_api_key: bool = False;

    can init {
        # Initialize mock data
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
        };

        # Check if API key is valid (not None, not empty, not placeholder)
        if (self.api_key and self.api_key != "YOUR_WEATHERAPI_KEY") {
            self.valid_api_key = True;
        }
    }

    can get_weather(location: str, force_mock: bool = False) -> dict {
        if (self.use_mock or force_mock or not self.valid_api_key) {
            return self.get_mock_weather(location);
        }
        
        api_result = self.get_api_weather(location);
        if (api_result) {
            return api_result;
        } else {
            return self.get_mock_weather(location);
        }
    }

    can get_api_weather(location: str) -> dict | None {
        if (not self.valid_api_key) {
            return None;
        }

        try {
            params = {
                "q": f"{location},LK",
                "appid": self.api_key,
                "units": "metric"
            };
            
            response = requests.get(self.base_url, params=params, timeout=5);
            response.raise_for_status();
            data = response.json();
            
            return {
                "temperature": data["main"]["temp"],
                "humidity": data["main"]["humidity"],
                "wind_speed": data["wind"]["speed"],
                "conditions": data["weather"][0]["description"].title()
            };
        } except Exception as e {
            print(f"API Error for {location}: {str(e)}");
            return None;
        }
    }

    can get_mock_weather(location: str) -> dict {
        normalized_loc = location.title();
        return self.mock_data.get(normalized_loc, self.mock_data["Default"]);
    }
}

walker WeatherWalker {
    has location: str;
    has api_key: str;
    has use_mock: bool = False;
    has weather_service: WeatherService;
    has response: str = "";
    has source: str = "[Mock]";

    can init {
        # Create weather service node
        self.weather_service = WeatherService(
            api_key=self.api_key,
            use_mock=self.use_mock
        );
    }

    can process_weather {
        raw_data: dict;
        
        if (self.weather_service.valid_api_key and not self.weather_service.use_mock) {
            raw_data = self.weather_service.get_weather(self.location, False);
            # Check if we got real API data by trying to detect mock data patterns
            if (raw_data and raw_data in [v for v in self.weather_service.mock_data.values()]) {
                self.source = "[Mock - API Failed]";
            } elif (raw_data) {
                self.source = "[WeatherAPI]";
            } else {
                raw_data = self.weather_service.get_weather(self.location, True);
                self.source = "[Mock - API Failed]";
            }
        } else {
            raw_data = self.weather_service.get_weather(self.location, True);
            self.source = "[Mock]";
        }

        # Format the response
        self.response = (
            f"Weather Report for {self.location.title()} {self.source}\n" +
            f"- Temperature: {raw_data['temperature']}°C\n" +
            f"- Humidity: {raw_data['humidity']}%\n" +
            f"- Wind Speed: {raw_data['wind_speed']} km/h\n" +
            f"- Conditions: {raw_data['conditions']}"
        );
    }

    can report {
        if (not self.response) {
            self.process_weather();
        }
        print("\n" + "=" * 50);
        print(self.response);
        print("=" * 50 + "\n");
    }
}

with entry {
    # Get API key - replace with your actual key
    API_KEY = "YOUR_WEATHERAPI_KEY";

    print("\n" + "=" * 25 + " WEATHER SERVICE START " + "=" * 25);

    if (not API_KEY or API_KEY == "YOUR_WEATHERAPI_KEY") {
        print("\nWARNING: Using placeholder API key");
        print("Please register at https://openweathermap.org/api");
        print("Set your API key in the code or as environment variable\n");
    }

    cities = ["Colombo", "Kandy", "Nuwara Eliya", "Galle"];
    
    for city in cities {
        try {
            wlk = WeatherWalker(
                location=city, 
                api_key=API_KEY
            );
            wlk.report();
        } except Exception as e {
            print(f"Error processing {city}: {str(e)}");
        }
    }

    print("=" * 25 + " WEATHER SERVICE END " + "=" * 27);
}