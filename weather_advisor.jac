import datetime;

obj WeatherService {
    has api_key: str = " 309a1a8d720341dba56103104251607";
    has base_url: str = "https://www.weatherapi.com/my/";

    fn get_weather(self, location: str) -> dict {
        mock_data = {
            "Colombo": {
                "temperature": 28.5,
                "condition": "Partly Cloudy",
                "humidity": 78,
                "wind_speed": 12.5,
                "description": "Warm and humid with scattered clouds"
            },
            "Nuwara Eliya": {
                "temperature": 18.2,
                "condition": "Misty",
                "humidity": 85,
                "wind_speed": 8.0,
                "description": "Cool and misty typical hill country weather"
            },
            "Kandy": {
                "temperature": 24.1,
                "condition": "Light Rain",
                "humidity": 82,
                "wind_speed": 6.3,
                "description": "Light showers with warm temperatures"
            }
        };
        return mock_data.get(location, {
            "temperature": 25.0,
            "condition": "Clear",
            "humidity": 65,
            "wind_speed": 10.0,
            "description": "Pleasant weather conditions"
        });
    }
}

walker WeatherWalker {
    has location: str;
    has response: dict;
    has weather_service: WeatherService;

    fn init(self, location: str) {
        self.location = location;
        self.weather_service = WeatherService();
        self.response = {};
    }

    fn report(self) {
        data = self.weather_service.get_weather(self.location);
        self.response = {
            "location": self.location,
            "temperature": data["temperature"],
            "condition": data["condition"],
            "humidity": data["humidity"],
            "wind_speed": data["wind_speed"],
            "description": data["description"],
            "timestamp": datetime.now().isoformat()
        };
        print(f"Weather report for {self.location}:");
        print(f"  Temperature: {data['temperature']}°C");
        print(f"  Condition: {data['condition']}");
        print(f"  Humidity: {data['humidity']}%");
        print(f"  Wind: {data['wind_speed']} km/h");
        print(f"  Description: {data['description']}");
        print("");
    }
}

with entry {
    walker1 = spawn WeatherWalker("Colombo");
    walker1.report();

    walker2 = spawn WeatherWalker("Nuwara Eliya");
    walker2.report();

    walker3 = spawn WeatherWalker("Kandy");
    walker3.report();
}
