INSERT INTO movies (id, name, release_date, duration_in_minute, director_name, synopsis, image, updated_at, slug) VALUES
  (7, 'The Batman', '2026-06-09', 125, 'Nia Santoso', 'A masked detective fights crime in the city.', '/movies/the-batman.jpg', now(), 'the-batman')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  release_date = EXCLUDED.release_date,
  duration_in_minute = EXCLUDED.duration_in_minute,
  director_name = EXCLUDED.director_name,
  synopsis = EXCLUDED.synopsis,
  image = EXCLUDED.image,
  updated_at = EXCLUDED.updated_at,
  slug = EXCLUDED.slug;

SELECT setval(pg_get_serial_sequence('movies', 'id'), COALESCE((SELECT MAX(id) FROM movies), 1), true);

INSERT INTO movie_cinemas (movie_id, cinema_id, show_date, showtime_id, price)
SELECT
  7,
  1,
  generated_date::date AS show_date,
  1,
  75000
FROM generate_series('2026-06-10'::date, '2026-06-16'::date, interval '1 day') AS generated_date
ON CONFLICT (movie_id, cinema_id, show_date, showtime_id) DO UPDATE SET
  price = EXCLUDED.price,
  updated_at = now();

WITH selected_mc AS (
  SELECT id AS movie_cinema_id
  FROM movie_cinemas
  WHERE movie_id = 7
    AND cinema_id = 1
    AND show_date = '2026-06-10'
    AND showtime_id = 1
  LIMIT 1
)
INSERT INTO orders (id, payment_reference, user_id, showtime_id, movie_cinema_id, total_price, payment_method_id, status, expired_at, created_at)
SELECT
  '00000000-0000-0000-0000-000000000007',
  'VA123456789',
  2,
  1,
  movie_cinema_id,
  75000,
  1,
  'paid',
  now() + interval '1 hour',
  now()
FROM selected_mc
ON CONFLICT (id) DO NOTHING;

INSERT INTO order_details (order_id, seat_id, showtime_id, movie_cinema_id, price)
SELECT
  '00000000-0000-0000-0000-000000000007',
  s.id,
  1,
  selected_mc.movie_cinema_id,
  75000
FROM selected_mc
JOIN seats s ON s.cinema_id = 1 AND s."row" = 'A' AND s."number" = 1
ON CONFLICT (order_id, seat_id) DO NOTHING;

