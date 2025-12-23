FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build -- --configuration production --base-href /

FROM nginx:alpine

# Copy built assets
COPY --from=build /app/dist/ /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY entrypoint.sh /entrypoint.sh


RUN mkdir -p /usr/share/nginx/html/assets

RUN chmod +x /entrypoint.sh

RUN chmod -R 777 /usr/share/nginx/html && \
    chmod -R 777 /var/cache/nginx && \
    chmod -R 777 /var/run && \
    chmod -R 777 /var/log/nginx

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
