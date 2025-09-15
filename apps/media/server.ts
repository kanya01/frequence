import fastify from 'fastify';
import { S3Client } from '@aws-sdk/client-s3';

const app = fastify();

// Tigris setup
if (!process.env.TIGRIS_ACCESS_KEY || !process.env.TIGRIS_SECRET_KEY) {
  throw new Error('TIGRIS_ACCESS_KEY and TIGRIS_SECRET_KEY must be defined');
}

const tigrisClient = new S3Client({
  region: 'auto',
  endpoint: process.env.TIGRIS_ENDPOINT,
  credentials: {
    accessKeyId: process.env.TIGRIS_ACCESS_KEY,
    secretAccessKey: process.env.TIGRIS_SECRET_KEY,
  },
});

// TODO: Add routes for file upload and basic processing

app.get('/health', async () => ({ status: 'ok' }));

app.listen({ port: 8080 }, (err) => {
  if (err) throw err;
  console.log('Media Service running on port 8080');
});
