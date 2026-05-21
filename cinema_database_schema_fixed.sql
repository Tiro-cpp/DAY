-- Fixed Cinema Database Schema
CREATE TABLE languages (
    lang_id SERIAL PRIMARY KEY,
    code CHAR(2) UNIQUE NOT NULL,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE age_ratings (
    rating_id SERIAL PRIMARY KEY,
    code VARCHAR(10) UNIQUE NOT NULL
);

CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    duration_minutes INT NOT NULL,
    rating_id INT REFERENCES age_ratings(rating_id),
    poster_url TEXT,
    release_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE movie_translations (
    translation_id SERIAL PRIMARY KEY,
    movie_id INT NOT NULL REFERENCES movies(movie_id) ON DELETE CASCADE,
    lang_id INT NOT NULL REFERENCES languages(lang_id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    UNIQUE(movie_id, lang_id)
);

CREATE TABLE cinemas (
    cinema_id SERIAL PRIMARY KEY,
    phone_number VARCHAR(20),
    website_url TEXT
);

CREATE TABLE cinema_translations (
    translation_id SERIAL PRIMARY KEY,
    cinema_id INT NOT NULL REFERENCES cinemas(cinema_id) ON DELETE CASCADE,
    lang_id INT NOT NULL REFERENCES languages(lang_id),
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    UNIQUE(cinema_id, lang_id)
);

CREATE TABLE halls (
    hall_id SERIAL PRIMARY KEY,
    cinema_id INT NOT NULL REFERENCES cinemas(cinema_id) ON DELETE CASCADE,
    hall_name VARCHAR(50) NOT NULL
);

CREATE TABLE seat_types (
    type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE seats (
    seat_id SERIAL PRIMARY KEY,
    hall_id INT NOT NULL REFERENCES halls(hall_id) ON DELETE CASCADE,
    row_number INT NOT NULL,
    seat_number INT NOT NULL,
    type_id INT REFERENCES seat_types(type_id),
    UNIQUE(hall_id, row_number, seat_number)
);

CREATE TABLE showtimes (
    showtime_id SERIAL PRIMARY KEY,
    movie_id INT NOT NULL REFERENCES movies(movie_id),
    hall_id INT NOT NULL REFERENCES halls(hall_id),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    base_price DECIMAL(10,2) NOT NULL,
    is_3d BOOLEAN DEFAULT FALSE
);

CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role_id INT REFERENCES roles(role_id)
);

CREATE TABLE booking_statuses (
    status_id SERIAL PRIMARY KEY,
    status_name VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    status_id INT NOT NULL REFERENCES booking_statuses(status_id),
    total_price DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ticket_seats (
    ticket_id SERIAL PRIMARY KEY,
    booking_id INT NOT NULL REFERENCES bookings(booking_id) ON DELETE CASCADE,
    showtime_id INT NOT NULL REFERENCES showtimes(showtime_id),
    seat_id INT NOT NULL REFERENCES seats(seat_id),
    final_price DECIMAL(10,2) NOT NULL,
    UNIQUE(showtime_id, seat_id)
);

CREATE TABLE payment_statuses (
    status_id SERIAL PRIMARY KEY,
    status_name VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT NOT NULL REFERENCES bookings(booking_id),
    transaction_id VARCHAR(100) UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    status_id INT REFERENCES payment_statuses(status_id),
    processed_at TIMESTAMP
);

CREATE INDEX idx_showtimes_movie ON showtimes(movie_id);
CREATE INDEX idx_showtimes_hall ON showtimes(hall_id);
CREATE INDEX idx_ticket_seats_showtime ON ticket_seats(showtime_id);
CREATE INDEX idx_bookings_user ON bookings(user_id);
