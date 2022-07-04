# server image
FROM nginx:latest AS base
EXPOSE 8080

# builder image
FROM node:16-alpine3.15 as builder

# make the 'app' folder the current working directory
# WORKDIR /
WORKDIR /

# copy both 'package.json' and 'package-lock.json' (if available)
COPY ["package*.json", "./"]
# COPY ["package*.json", "./"]

# install project dependencies
RUN npm i

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .

# build app for production with minification
RUN npm run build

FROM base AS final
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /dist /var/www/html/