# Build stage
FROM node:20-alpine AS build

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy source
COPY . .

# Build Strapi
RUN npm run build

# Runtime stage
FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production

# Copy only needed files from build stage
COPY --from=build /app ./

# Create required writable directories
RUN mkdir -p /app/.cache /app/public/uploads \
    && chown -R node:node /app

# Drop root privileges
USER node

EXPOSE 1337

CMD ["npm", "run", "start"]
