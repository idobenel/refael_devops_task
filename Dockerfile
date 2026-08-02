# Build stage
FROM node:22-alpine AS builder

WORKDIR /app

# Copy dependency files first for better layer caching
COPY package*.json ./

# Install exact dependencies from lock file
RUN npm ci

# Copy application source
COPY . .


# Runtime stage
FROM node:22.22-alpine AS runtime

WORKDIR /app

# Copy only required runtime files
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/app.js ./app.js
COPY --from=builder /app/package*.json ./

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

USER appuser

EXPOSE 8080

CMD ["node", "app.js"]