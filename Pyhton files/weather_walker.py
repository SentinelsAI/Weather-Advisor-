# weather_walker.py
from weather_service import WeatherService

class WeatherWalker:
    def __init__(self, location, api_key=None, use_mock=False):
        """
        Initialize weather walker
        Args:
            location (str): Target city
            api_key (str): Optional API key
            use_mock (bool): Force mock data
        """
        self.location = location
        self.weather_service = WeatherService(api_key=api_key, use_mock=use_mock)
        self.response = None

    def process_weather(self):
        """Retrieve and format weather data"""
        raw_data = self.weather_service.get_weather(self.location)
        source = "🌤️ API" if not self.weather_service.use_mock and self.weather_service.api_key else "🛠️ Mock"
        
        self.response = (
            f"🌦 Weather Report for {self.location.title()} ({source})\n"
            f"• Temperature: {raw_data['temperature']}°C\n"
            f"• Humidity: {raw_data['humidity']}%\n"
            f"• Wind Speed: {raw_data['wind_speed']} km/h\n"
            f"• Conditions: {raw_data['conditions']}"
        )
    
    def report(self):
        """Generate and display weather report"""
        if not self.response:
            self.process_weather()
        print("\n" + "="*45)
        print(self.response)
        print("="*45 + "\n")

# Example usage
if __name__ == "__main__":
    # Get API key from environment or replace with your key
    API_KEY = "3ec4487d3705fa3a65e6d5ab71e8efc8"
    
    # Create walkers with different configurations
    walker1 = WeatherWalker("Colombo", api_key=API_KEY)  # Real API
    walker2 = WeatherWalker("Kandy", use_mock=True)     # Force mock
    walker3 = WeatherWalker("nuwara eliya", api_key=API_KEY)             # Will use API if key available
    
    for walker in [walker1, walker2, walker3]:
        walker.report()