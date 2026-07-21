# Base image
FROM nginx:alpine

# Copy Flutter web build into Nginx
COPY build/web /usr/share/nginx/html

# Document that the container listens on port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
