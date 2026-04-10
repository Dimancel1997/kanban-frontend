FROM node:16-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build -- --prod

FROM nginx:alpine 
COPY default.conf /etc/nginx/conf.d/default.conf 
COPY --from=build /app/dist/kanban-ui /usr/share/nginx/html 
EXPOSE 80 
CMD ["nginx", "-g", "daemon off;"]