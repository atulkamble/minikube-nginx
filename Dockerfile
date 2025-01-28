# Use the official Nginx base image

FROM nginx:latest

 

# Copy the custom HTML file to the default Nginx HTML directory

COPY index.html /usr/share/nginx/html/index.html

 

# Expose port 80

EXPOSE 80




