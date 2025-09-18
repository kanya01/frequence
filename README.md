# freq.space - Creative Marketplace and Social Platform

## Overview
freq.space is a Minimum Viable Product (MVP) designed as a creative marketplace and social platform tailored for music and creative professionals, including artists, producers, engineers, songwriters, vocalists, session musicians, and video producers. Built with a modern, scalable architecture on Fly.io, it enables users to connect, collaborate, showcase their work, and offer professional services in a streamlined and efficient environment.

The platform focuses on delivering core functionality for the MVP, balancing simplicity with scalability, and leverages Fly.io’s infrastructure for deployment, PostgreSQL for data storage, and Tigris for media handling.

## Core Features
The MVP includes the following essential features:
- **User Profiles**: Users can sign up, log in, and create profiles with bio, skills, user type (e.g., artist, producer), and avatar.
- **Content Sharing**: Upload and share audio tracks or videos with metadata (title, description, tags) and basic waveform visualization.
- **Search & Discovery**: Simple search by username, skills, or tags to find professionals or content.
- **Social Interactions**: Follow other users, like, and comment on content.
- **Marketplace Basics**: List and browse creative services (e.g., session musician for hire).

## Architecture
The MVP architecture is streamlined to three Fly.io apps to minimize complexity while maintaining modularity:

1. **API Gateway + Core Backend** (`freq-api`):
   - Handles authentication, user profiles, content management, and search.
   - Tech: TypeScript, Fastify, Prisma ORM, PostgreSQL.
2. **Media Service** (`freq-media`):
   - Manages file uploads and basic audio processing, storing media in Fly.io Volumes and Tigris (S3-compatible storage).
   - Tech: TypeScript, Fastify, AWS SDK for Tigris.
3. **Web App** (`freq-web`):
   - Static React frontend served via Fly.io’s edge caching.
   - Tech: React 18, TypeScript, Vite, Tailwind CSS, Zustand, TanStack Query, React Hook Form, Zod.

### Database
- **PostgreSQL**: Single database on Fly.io with optimized schemas for users, profiles, content, follows, likes, comments, and services.
- **Search**: PostgreSQL Full-Text Search for efficient querying by username, skills, or tags.
- **File Storage**: Fly.io Volumes for temporary storage and Tigris for permanent media storage.

### File Structure
```
freq.space/
├── apps/
│   ├── api/               # API Gateway + User + Content
│   │   ├── server.ts
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   ├── Dockerfile
│   │   ├── fly.toml
│   │   └── prisma/
│   │       └── schema.prisma
│   ├── media/             # File uploads and processing
│   │   ├── server.ts
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   ├── Dockerfile
│   │   ├── fly.toml
│   │   └── storage/
│   │       └── tigris.ts
│   └── web/               # React frontend
│       ├── src/
│       ├── package.json
│       ├── tsconfig.json
│       ├── Dockerfile
│       ├── fly.toml
│       └── vite.config.ts
├── databases/
│   └── schema.sql
├── package.json           # Root workspace config
└── README.md
```

## Getting Started
### Prerequisites
- **Node.js**: v18+ (https://nodejs.org/)
- **Git**: For cloning the repository (https://git-scm.com/)
- **Fly.io CLI**: For deployment (https://fly.io/docs/hands-on/install-flyctl/)
- **Docker**: For local PostgreSQL or testing (https://www.docker.com/)
- **PostgreSQL**: Local or via Docker for development.

### Setup Instructions
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/freq.space.git
   cd freq.space
   ```

2. **Install Root Dependencies**:
   ```bash
   npm install
   ```

3. **Set Up API App** (`apps/api`):
   ```bash
   cd apps/api
   npm install
   npx prisma migrate dev --name init
   ```

4. **Set Up Media App** (`apps/media`):
   ```bash
   cd ../media
   npm install
   ```

5. **Set Up Web App** (`apps/web`):
   ```bash
   cd ../web
   npm install
   ```

6. **Set Up Local Database**:
   - Run PostgreSQL via Docker:
     ```bash
     docker run --name freq-postgres -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres
     psql -h localhost -U postgres -c "CREATE DATABASE freq_space;"
     psql -h localhost -U postgres -d freq_space -f databases/schema.sql
     ```
   - Set `DATABASE_URL` in `apps/api/.env`:
     ```bash
     echo "DATABASE_URL=postgresql://postgres:password@localhost:5432/freq_space?schema=public" > apps/api/.env
     ```

7. **Run Locally**:
   - API: `cd apps/api && npx ts-node server.ts`
   - Web: `cd apps/web && npm run dev`
   - Media: `cd apps/media && npx ts-node server.ts`

### Deployment
1. **Set Up Fly.io**:
   - Install Fly.io CLI and authenticate: `flyctl auth signup` or `flyctl auth login`.
2. **Deploy Apps**:
   - API:
     ```bash
     cd apps/api
     flyctl launch --name freq-api --region ord --no-deploy
     flyctl deploy
     ```
   - Media:
     ```bash
     cd ../media
     flyctl launch --name freq-media --region ord --no-deploy
     flyctl deploy
     ```
   - Web:
     ```bash
     cd ../web
     flyctl launch --name freq-web --region ord --no-deploy
     flyctl deploy
     ```
3. **Set Up PostgreSQL**:
   ```bash
   flyctl postgres create --name freq-postgres --region ord
   flyctl postgres attach freq-postgres --app freq-api
   ```
4. **Configure Tigris**:
   - Sign up for Tigris via Fly.io, obtain credentials, and add to `apps/media/fly.toml`:
     ```toml
     [env]
       TIGRIS_ENDPOINT = "your-tigris-endpoint"
       TIGRIS_ACCESS_KEY = "your-access-key"
       TIGRIS_SECRET_KEY = "your-secret-key"
     ```

### Testing
- Test API endpoints using Postman or curl (e.g., `POST /register`, `GET /content`).
- Access the frontend at `http://localhost:5173` (Vite default port) or the deployed URL (e.g., `https://freq-web.fly.dev`).

## Technology Stack
### Backend
- **Language**: TypeScript
- **Framework**: Fastify (high-performance Node.js framework)
- **Database**: PostgreSQL with Prisma ORM
- **File Storage**: Fly.io Volumes + Tigris (S3-compatible storage)
- **Authentication**: JWT with bcrypt for password hashing

### Frontend
- **Language**: TypeScript
- **Framework**: React 18 + Vite
- **State Management**: Zustand + TanStack Query
- **UI**: Tailwind CSS + Radix UI
- **Forms**: React Hook Form + Zod for validation

## Key Benefits of Fly.io
- **Simplicity**: Easy deployment with Fly.io CLI and minimal configuration.
- **Performance**: Global edge network with built-in load balancing and caching.
- **Cost-Effective**: Pay-as-you-go pricing with automatic scaling.
- **Developer Experience**: Streamlined CLI and excellent documentation.

## Future Enhancements
The MVP is designed for extensibility. Planned features for future iterations include:
- Real-time collaboration (WebSocket-based live sessions using Socket.IO).
- Advanced media processing (waveform generation, thumbnails).
- Recommendation engine for content and professionals.
- Multi-region Fly.io deployment for global scalability.
- Redis integration for caching and job queues.

## Contributing
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature`.
3. Commit changes: `git commit -m "Add your feature"`.
4. Push to the branch: `git push origin feature/your-feature`.
5. Open a pull request.

Please ensure code follows the TypeScript style guide and includes tests where applicable.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact
For questions or support, reach out via GitHub Issues.