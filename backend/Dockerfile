FROM node:24-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

RUN DATABASE_URL="postgresql://unused:unused@localhost:5432/unused" npx prisma generate

EXPOSE 3001

CMD ["sh", "-c", "npx prisma generate && npm run start:dev"]
