# WeatherSwift

An iOS weather app that shows the GFS forecast for your current location: temperature, clouds, humidity, atmospheric pressure, rain, and snow risk, listed hour by hour with a detail view for each entry.

## For users

- **Location-based forecast** — on launch, the app asks for your location (used once to fetch the forecast, not tracked continuously) and shows the GFS forecast for that spot.
- **Forecast list + detail** — a scrollable list of upcoming forecast entries; tap one to see full detail (temperature, clouds, humidity, pressure, rain, snow risk).
- **Offline support** — forecasts are cached on-device, so the last known forecast is still shown without a network connection. When back online, the app refreshes automatically.
- **Network status banners** — an in-app banner tells you when the network becomes unavailable or comes back.
- **Localized** — available in English and French.

Requires iOS 15 or later.

## For developers

### Stack

Swift, UIKit (storyboard-free, programmatic root view controller via `SceneDelegate`), Core Data, Swift Package Manager. No third-party backend — forecasts come from the public [infoclimat.fr](https://www.infoclimat.fr) GFS API.

### Project layout

The Xcode project lives in `WeatherSwift/WeatherSwift.xcodeproj` (one level below the git root). Three build targets:

- **WeatherCore** — networking, JSON parsing, Core Data persistence, and domain services. No view code.
- **WeatherUI** — reusable UI extensions and view models, built on top of WeatherCore.
- **WeatherSwift** — the app: MVVM views/view models (`WeatherSwift/MVVM/`) plus app lifecycle (`AppDelegate`/`SceneDelegate`) and navigation.

### How a forecast gets to the screen

1. `BridgeForecastService.getForecasts` is the single entry point the UI calls. It returns the cached Core Data forecasts immediately, then — if online — refreshes from the network and returns updated results.
2. `WebServiceService` builds the infoclimat request URL for the device's GPS coordinates (via `PermissionService`) and fetches the JSON.
3. `ParserService` parses the JSON into `ForecastStruct` values.
4. `CoreDataService` replaces the cache with the new data; the context is saved on app termination.

Full architecture notes, build/test/lint commands, and SPM dependency details are in [`CLAUDE.md`](CLAUDE.md).

### Building & testing

```bash
cd WeatherSwift
xcodebuild -project WeatherSwift.xcodeproj -scheme WeatherSwift -sdk iphonesimulator build
xcodebuild -project WeatherSwift.xcodeproj -scheme WeatherSwift -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test
```

No dependency install step is needed — SPM packages resolve automatically when the project opens.

## License

See [`LICENSE`](LICENSE).
