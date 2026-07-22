# ---------- Stage 1: Build ----------
FROM flutter-builder:3.44.6 AS build

WORKDIR /app

# Copy dependency files
COPY pubspec.yaml pubspec.lock ./

# Install dependencies
RUN flutter pub get

# Copy project
COPY . .

# Build Flutter Web
RUN flutter build web --release --no-wasm-dry-run

# ---------- Stage 2 ----------
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
