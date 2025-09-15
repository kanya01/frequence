-- PostgreSQL Schema for freq.space MVP
-- Optimized for Fly.io PostgreSQL

-- Enum Types
CREATE TYPE user_type_enum AS ENUM ('artist', 'producer', 'engineer', 'songwriter', 'vocalist', 'musician', 'video_producer');
CREATE TYPE content_type_enum AS ENUM ('post', 'track', 'portfolio');

-- Users and Authentication
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- User Profiles
CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    bio TEXT,
    user_type user_type_enum,
    avatar_url TEXT,
    skills TEXT[], -- PostgreSQL array
    created_at TIMESTAMP DEFAULT NOW()
);

-- Content (Posts, Tracks)
CREATE TABLE content (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    type content_type_enum,
    title VARCHAR(255),
    description TEXT,
    media_url TEXT, -- Single URL for MVP (Tigris-hosted)
    is_public BOOLEAN DEFAULT true,
    tags TEXT[],
    created_at TIMESTAMP DEFAULT NOW()
);

-- Social Interactions
CREATE TABLE follows (
    follower_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    following_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (follower_id, following_id)
);

CREATE TABLE likes (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    content_id INTEGER REFERENCES content(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (user_id, content_id)
);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    content_id INTEGER REFERENCES content(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Marketplace Services
CREATE TABLE services (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Full-text search index
CREATE INDEX content_search_idx ON content USING GIN (
    to_tsvector('english', title || ' ' || description || ' ' || array_to_string(tags, ' '))
);
CREATE INDEX profile_search_idx ON profiles USING GIN (
    to_tsvector('english', bio || ' ' || array_to_string(skills, ' '))
);
