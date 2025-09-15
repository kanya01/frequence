import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';

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

export const uploadFile = async (file: Buffer, key: string) => {
    const command = new PutObjectCommand({
        Bucket: 'freq-space-media',
        Key: key,
        Body: file,
    });
    await tigrisClient.send(command);
    return;
};
