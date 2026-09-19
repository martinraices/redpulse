-- Red Pulse / PostgreSQL
-- Script 01: create the database
-- Run this while connected to a maintenance database such as "postgres".

CREATE DATABASE "RedPulseDB"
    WITH
    OWNER = CURRENT_USER
    ENCODING = 'UTF8'
    TEMPLATE = template0;

-- PostgreSQL cannot switch databases with standard SQL in the same session.
-- Reconnect your client to RedPulseDB before running 02_create_schema.sql.
