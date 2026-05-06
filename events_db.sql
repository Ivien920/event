-- ============================================================
-- UMU Event Management System — Database Schema
-- Uganda Martyrs University
-- CSC 2202 Web-based System Programming
-- ============================================================

CREATE DATABASE IF NOT EXISTS umu_events CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE umu_events;

-- ── Users ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    reg_number    VARCHAR(30)  NOT NULL UNIQUE,
    full_name     VARCHAR(120) NOT NULL,
    email         VARCHAR(120) NOT NULL UNIQUE,
    password      VARCHAR(255) NOT NULL,
    role          ENUM('student','verified','admin') NOT NULL DEFAULT 'student',
    profile_photo VARCHAR(255) DEFAULT NULL,
    is_active     TINYINT(1)  NOT NULL DEFAULT 1,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── Event Categories ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS categories (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60) NOT NULL UNIQUE,
    icon VARCHAR(10) NOT NULL DEFAULT '🎉'
);

-- ── Events ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS events (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    creator_id    INT          NOT NULL,
    category_id   INT          NOT NULL,
    title         VARCHAR(200) NOT NULL,
    description   TEXT         NOT NULL,
    location      VARCHAR(200) NOT NULL,
    event_date    DATETIME     NOT NULL,
    is_free       TINYINT(1)   NOT NULL DEFAULT 1,
    price         DECIMAL(10,2) DEFAULT 0.00,
    capacity      INT          DEFAULT NULL,
    poster        VARCHAR(255) DEFAULT NULL,
    status        ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
    rejection_reason VARCHAR(255) DEFAULT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (creator_id)  REFERENCES users(id)      ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
);

-- ── RSVPs ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS rsvps (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    event_id   INT NOT NULL,
    rsvp_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_rsvp (user_id, event_id),
    FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);

-- ── Comments ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS comments (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    event_id   INT  NOT NULL,
    user_id    INT  NOT NULL,
    body       TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id)  ON DELETE CASCADE,
    FOREIGN KEY (user_id)  REFERENCES users(id)   ON DELETE CASCADE
);

-- ── Notifications ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS notifications (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT          NOT NULL,
    title      VARCHAR(200) NOT NULL,
    body       TEXT         NOT NULL,
    type       ENUM('reminder','approval','rejection','comment','system') NOT NULL DEFAULT 'system',
    is_read    TINYINT(1)   NOT NULL DEFAULT 0,
    event_id   INT          DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE SET NULL
);

-- ── Password Reset Tokens (bonus) ────────────────────────────
CREATE TABLE IF NOT EXISTS password_resets (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT          NOT NULL,
    token      VARCHAR(64)  NOT NULL,
    expires_at DATETIME     NOT NULL,
    used       TINYINT(1)   DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- SEED DATA
-- ============================================================

-- Categories
INSERT INTO categories (name, icon) VALUES
('Academic',   '🎓'),
('Sports',     '⚽'),
('Cultural',   '🎭'),
('Music',      '🎵'),
('Religious',  '✝️'),
('Health',     '🏥'),
('Technology', '💻'),
('Social',     '🤝');

-- Users  (password = "password" bcrypt)
INSERT INTO users (reg_number, full_name, email, password, role) VALUES
('ADMIN001',    'System Administrator', 'admin@umu.ac.ug',           '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin'),
('VER001',      'Events Coordinator',   'events@umu.ac.ug',          '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'verified'),
('2024/BSC/001','John Mukasa',          'john@students.umu.ac.ug',   '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student'),
('2024/BSC/002','Mary Nakato',          'mary@students.umu.ac.ug',   '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student');

-- Sample Events (approved)
INSERT INTO events (creator_id, category_id, title, description, location, event_date, is_free, price, capacity, status) VALUES
(2, 1, 'UMU Annual Academic Symposium 2025',
 'Join us for the annual academic symposium featuring presentations from top researchers and faculty members across all departments. This is a great opportunity for students to showcase their final year projects.',
 'Main Auditorium, UMU Nkozi', '2025-07-15 09:00:00', 1, 0.00, 300, 'approved'),

(2, 4, 'UMU Gospel Night',
 'An electrifying evening of praise, worship and thanksgiving. Featuring top gospel artists from across Uganda. All students and staff are welcome to attend this spiritually uplifting event.',
 'University Chapel, UMU', '2025-07-20 18:00:00', 1, 0.00, 500, 'approved'),

(2, 2, 'Inter-Faculty Sports Day',
 'Annual sports competition between faculties. Events include football, netball, athletics, and swimming. Come support your faculty and enjoy a day of sporting excellence.',
 'UMU Sports Grounds', '2025-07-25 08:00:00', 1, 0.00, 1000, 'approved'),

(2, 7, 'Tech Innovation Summit',
 'A day-long technology summit showcasing student and faculty innovations. Includes hackathon, product demos, and keynote address by industry leaders from Kampala tech ecosystem.',
 'ICT Centre, UMU', '2025-08-02 10:00:00', 0, 20000.00, 150, 'approved'),

(2, 3, 'Cultural Extravaganza 2025',
 'Celebrating the rich cultural heritage of Uganda through dance, music, drama and art. Students from all 4 regions will represent their cultures in an evening of beauty and diversity.',
 'Open Air Theatre, UMU', '2025-08-10 17:00:00', 1, 0.00, 800, 'approved');

-- Sample RSVPs
INSERT INTO rsvps (user_id, event_id) VALUES (3, 1), (3, 2), (4, 1), (4, 3);

-- Sample Comments
INSERT INTO comments (event_id, user_id, body) VALUES
(1, 3, 'Really looking forward to this symposium! Will the presentations be recorded?'),
(1, 4, 'This is a great initiative. I hope the Computer Science department is well represented.'),
(2, 3, 'Gospel Night is always amazing at UMU. Can\'t wait!'),
(3, 4, 'Go Faculty of Science! We are bringing the trophy home this year.');

-- Sample Notifications
INSERT INTO notifications (user_id, title, body, type, event_id) VALUES
(3, '📅 Reminder: Academic Symposium Tomorrow', 'Don\'t forget — UMU Annual Academic Symposium is tomorrow at 9:00 AM in the Main Auditorium.', 'reminder', 1),
(3, '✅ RSVP Confirmed', 'You have successfully RSVPd for UMU Gospel Night on 20th July 2025.', 'system', 2),
(4, '📅 Reminder: Sports Day Tomorrow', 'Inter-Faculty Sports Day is tomorrow at 8:00 AM at the UMU Sports Grounds. Bring your team spirit!', 'reminder', 3);
