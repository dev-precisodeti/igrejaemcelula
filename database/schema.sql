-- Modelagem PostgreSQL Multi-Tenant para Igrejas em Células
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE TYPE user_role AS ENUM ('VISITOR', 'MEMBER', 'HOST', 'LEADER_IN_TRAINING', 'CELL_LEADER', 'SUPERVISOR', 'NETWORK_LEADER', 'CHURCH_ADMIN');
CREATE TABLE churches (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), name VARCHAR(150) NOT NULL, slug VARCHAR(60) UNIQUE NOT NULL);
CREATE TABLE networks (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), church_id UUID NOT NULL REFERENCES churches(id), name VARCHAR(100) NOT NULL, color_hex VARCHAR(7) DEFAULT '#2563EB');
CREATE TABLE cells (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), church_id UUID NOT NULL REFERENCES churches(id), network_id UUID NOT NULL REFERENCES networks(id), name VARCHAR(100) NOT NULL);
CREATE TABLE posts (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), church_id UUID NOT NULL REFERENCES churches(id), caption TEXT, is_pinned BOOLEAN DEFAULT FALSE);
