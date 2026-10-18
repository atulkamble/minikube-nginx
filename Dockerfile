FROM nginx:alpine-slim
COPY index.html /usr/share/nginx/html/index.html
ENTRYPOINT ["nginx", "-g", "daemon off;"]
EXPOSE 80