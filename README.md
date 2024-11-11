# Weather fetchnig application.
The app presents weather forecast for a selected location. Locations can be choosen from a selected weather data provider. Current implementation provides AcuWeather and OpenMeteo.

# AcuWeather API key
AcuWeather has limitations on the free API. If the daily quota is exceeded the API returns 401 error when queries about weather forecast for a location. This may require a new API key created at https://developer.accuweather.com/