-- Enable common PostgreSQL extensions if they are available in the image.
-- This runs only on first init (when the data directory is empty).

DO $$
DECLARE
  ext text;
  exts text[] := ARRAY[
    'postgis',
    'anon',
    'uuid-ossp'
  ];
BEGIN
  FOREACH ext IN ARRAY exts LOOP
    IF EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = ext) THEN
      EXECUTE format('CREATE EXTENSION IF NOT EXISTS %I', ext);
    END IF;
  END LOOP;
END $$;

