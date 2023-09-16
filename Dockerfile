FROM node:18.17.1 AS builder
ENV NODE_ENV production
WORKDIR /app
COPY package.json .
COPY package-lock.json .
RUN npm install --omit=dev
COPY . .
ARG REACT_APP_HOST_API_PORT
ENV REACT_APP_HOST_API_PORT=$REACT_APP_HOST_API_PORT
RUN npm run build

FROM nginx:1.24.0 AS production
ENV NODE_ENV production
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]