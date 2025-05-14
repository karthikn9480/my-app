# Stage 1: Build
FROM public.ecr.aws/docker/library/node:22.15.0-alpine AS builder

WORKDIR /app

# Copy and install dependencies
COPY package*.json ./
RUN npm ci

# Copy the rest of the code and build the app
COPY . .
RUN npm run build

# Stage 2: Serve with Nginx
FROM public.ecr.aws/nginx/nginx:stable-alpine

# Remove the default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy built files to nginx's web root
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom nginx config (optional, see below)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
