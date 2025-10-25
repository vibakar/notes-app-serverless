### STAGE 1: Setup the environment & install dependencies ###
FROM node:24-alpine3.21 AS setup

# Installs envsubst (provided by the gettext package)
RUN apk add --no-cache gettext

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .

### STAGE 2: Run the app in dev mode ###
FROM setup AS dev
CMD ["npm", "run", "dev"]

### STAGE 3: Build the app for prod ###
FROM setup AS build
RUN npm run build

### STAGE 4: Serve the prod app with Nginx ###
FROM nginx:stable-alpine AS prod

# remove the default Nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy built files from the previous stage
COPY --from=build /app/dist /usr/share/nginx/html

COPY start-prod.sh /start-prod.sh
RUN chmod +x /start-prod.sh

# Expose port 80 (default for Nginx)
EXPOSE 80

CMD ["/start-prod.sh"]