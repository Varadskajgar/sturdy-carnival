# Realistic Mart — Flutter Web Starter

A responsive demo storefront inspired by your references: clean Vercel/ChatGPT-like surfaces, soft grey canvas, bold black typography, lime-green accents, rounded product cards and subtle entrance motion.

## Included
- Responsive storefront for mobile, tablet and desktop
- Search by product name, category or product code
- Category filters, sorting, wishlist and cart quantity controls
- Product detail bottom sheet
- Demo products with unique product codes
- Separate Dart files for app, theme, data, models, state, screens and reusable widgets
- Vercel build configuration

## Run locally
Install Flutter SDK with web support, then:

```bash
flutter pub get
flutter run -d chrome
```

## Deploy from GitHub to Vercel
1. Push this project to a GitHub repository.
2. Import that repository in Vercel.
3. Keep the Root Directory as `./`.
4. `vercel.json` runs `scripts/vercel_build.sh`, installs the stable Flutter SDK in the build environment and creates `build/web`.
5. Deploy.

The first Vercel build can take longer because it downloads Flutter.

## Important demo limitations
This is a working front-end demo. Cart, search, filters, wishlist and product details work in the browser session. Checkout intentionally shows a demo message. There is no database, customer authentication, admin dashboard, COD order creation, inventory sync or payment processing connected yet. Connect Supabase and secure admin authorization before accepting real orders.

## Change demo products
Edit `lib/data/demo_products.dart`. Every product has a unique `code`, price, old price, category, description, tag and image URL.

## Project structure

```text
lib/
  main.dart
  app.dart
  data/demo_products.dart
  models/product.dart
  screens/home_screen.dart
  state/shop_state.dart
  theme/app_theme.dart
  widgets/brand_mark.dart
  widgets/cart_sheet.dart
  widgets/product_card.dart
web/
  index.html
scripts/
  vercel_build.sh
vercel.json
pubspec.yaml
```
