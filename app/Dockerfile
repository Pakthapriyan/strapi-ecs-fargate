FROM node:20-alpine

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install --omit=dev

# Copy source
COPY . .

# Build Strapi (this creates /app/dist)
RUN npm run build

ENV NODE_ENV=production
EXPOSE 1337

CMD ["npm", "run", "start"]
