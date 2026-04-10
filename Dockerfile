FROM node:18-bullseye-slim AS build

WORKDIR /app

COPY package*.json ./

RUN npm install --legacy-peer-deps

COPY . .

RUN npm run build -- --configuration=production

FROM nginx:1.25-alpine

COPY default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist/kanban-ui/ /usr/share/nginx/html/

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]