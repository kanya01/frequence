CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- User Profiles
CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    bio TEXT,
    user_type user_type_enum,
    experience_level experience_level_enum,
    avatar_url TEXT,
    city VARCHAR(100),
    country VARCHAR(100),
    onboarding_completed BOOLEAN DEFAULT false,
    skills TEXT[], -- PostgreSQL array
    social_links JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE content (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    type content_type_enum, -- 'post', 'track', 'portfolio'
    title VARCHAR(255),
    description TEXT,
    media_urls TEXT[],
    metadata JSONB, -- waveform data, duration, etc.
    is_public BOOLEAN DEFAULT true,
    tags TEXT[],
    created_at TIMESTAMP DEFAULT NOW()
);


CREATE INDEX content_search_idx ON content USING GIN (
    to_tsvector('english', title || ' ' || description || ' ' || array_to_string(tags, ' '))
);" > databases/schema.sql