FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# Build TypeScript
RUN npm run build

EXPOSE 3000

# Use node to run the compiled JavaScript
CMD ["node", "dist/index.js"] 