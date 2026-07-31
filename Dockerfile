# As required in the task, using alpine due to its size
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

#RUN npm install -g npm@latest

# Install dependencies, using npm ci for a consistent environment
RUN npm ci

# Copy the rest of the application
COPY . .

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

USER appuser

# Expose port 8080
EXPOSE 8080

# Command to run the application
CMD ["node", "app.js"]
