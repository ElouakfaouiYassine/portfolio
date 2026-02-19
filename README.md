# Portfolio (Flutter Web)

Personal portfolio site built with Flutter Web.

## Local Development

- Install dependencies: `flutter pub get`
- Run locally in Chrome: `flutter run -d chrome --web-renderer html`

## Production Build

- Build optimized web output (HTML renderer + PWA):
  `flutter build web --release --web-renderer html --pwa-strategy offline-first --base-href /portfolio/`

## Mobile Browser Notes

- PWA support is enabled via `web/manifest.json` and service worker registration in `web/index.html`.
- Test on both iOS Safari and Android Chrome for gesture consistency (scrolling, swipes, tap targets).
- HTML renderer is recommended for mobile users on cellular data to reduce first-load payload.

## Known Pitfalls

- First load on mobile web can still be slower than native because the Flutter engine must initialize.
- Mobile browser address bars can change visible viewport height and cause minor layout shifts.
