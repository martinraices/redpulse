# Red Pulse

Red Pulse is a full-stack analytics dashboard for an online casino management team.

The project is designed to provide a clear overview of key business and operational metrics such as revenue, active players, retention, games activity, bonus cost, technical availability, and geographic coverage.

All data used in this project is synthetic and created for development and portfolio purposes.

## Features

- Dashboard summary metrics
- Revenue and GGR reporting
- Active players tracking
- Retention monitoring
- Games activity metrics
- Bonus cost analytics
- Technical availability metrics
- Geographic market coverage
- Responsive dashboard layout
- API-driven frontend using live backend data

## Tech Stack

### Frontend

- Next.js
- React
- TypeScript
- Tailwind CSS
- shadcn/ui
- Lucide React

### Backend

- NestJS
- TypeScript
- Prisma ORM
- PostgreSQL

### Infrastructure

- Docker
- Docker Compose

## Architecture

The application is split into three main parts:

```text
Frontend
Next.js + React
        |
        v
Backend API
NestJS + Prisma
        |
        v
PostgreSQL