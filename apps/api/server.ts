// Single entry point for all API requests
// Handles: Authentication, rate limiting, request routing
// Fly.io App Name: freq-api-gateway" > apps/api-gateway/server.js
import fastify from 'fastify';
import rateLimit from '@fastify/rate-limit';
import { PrismaClient } from '@prisma/client';


const app = fastify();
const prisma = new PrismaClient();

app.register(rateLimit, {
    max: 100,
    timeWindow: '1 minute'
});

// Authentication middleware (implement JWT or similar)
app.addHook('preHandler', (req, reply, done) => {
    // TODO: Auth logic
    done();
});
// TODO: Add routes for auth, users, profiles, content, search

// Route requests to other services (use proxy or internal calls)
app.get('/health', async () => ({ status: 'ok' }));

app.listen({ port: 8080 }, (err) => {
    if (err) throw err;
    console.log('API Gateway running on port 8080');
});
