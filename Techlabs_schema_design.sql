-- Database Schema: Projects, Users, Feedback, Events, Quizzes

-- 1. Roles Table
CREATE TABLE roles (
    id INT AUTO_INCREMENT
 PRIMARY KEY,
    role VARCHAR(100) UNIQUE
);

-- 2. Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT
 PRIMARY KEY,
    username VARCHAR(100),
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    role_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id)REFERENCES roles(id)
    
);

-- 3. Projects Table
CREATE TABLE projects (
    id INT AUTO_INCREMENT
 PRIMARY KEY,
    title VARCHAR(100),
    description VARCHAR(255),
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- 4. Project Tasks Table
CREATE TABLE project_tasks (
    id INT AUTO_INCREMENT
 PRIMARY KEY,
    project_id INT, 
    task_title VARCHAR(100),
    description VARCHAR(255),
    assigned_to INT,
    status ENUM( 'pending', 'completed') ,
    due_date DATE,
    FOREIGN KEY(assigned_to) REFERENCES users(id),
    FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE
);

-- 5. Community Feedback Table
CREATE TABLE community_feedback (
    id INT AUTO_INCREMENT
 PRIMARY KEY,
    user_id INT NULL,
    guest_name  VARCHAR(100) DEFAULT NULL,
    guest_email VARCHAR(100) DEFAULT NULL,
    project_id INT DEFAULT NULL,
    comment TEXT,
    rating INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

-- 6. Events Table
CREATE TABLE events (
    id INT AUTO_INCREMENT
 PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    event_date TIMESTAMP,
    created_by INT ,
    location VARCHAR(255),
    FOREIGN KEY(created_by) REFERENCES users(id)
);

--6a. registration
CREATE TABLE event_registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    event_id INT,
    rsvp_status ENUM('yes', 'no', 'maybe') DEFAULT 'yes',
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (event_id) REFERENCES events(id)
);
--6b. badges
CREATE TABLE badges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    badge_name VARCHAR(100),
    description TEXT
);
--6c user badges
CREATE TABLE user_badges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    badge_id INT,
    awarded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (badge_id) REFERENCES badges(id)
);

--WE WILL DISCUSS THE IMPLEMENTATION OF THE QUIZ APP BEFORE CREATING THE fINAL SCHEMA
-- 7. Questions Table
CREATE TABLE questions (
    id INT AUTO_INCREMENT
 PRIMARY KEY,
    project_id INT,
    question TEXT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(created_by) REFERENCES users(id),
    FOREIGN KEY(project_id) REFERENCES projects(id)
    
);

-- 8. Choices Table
CREATE TABLE choices (
    id INT AUTO_INCREMENT
 PRIMARY KEY,
    question_id INT,
    choice TEXT,
    correct_choice ENUM('True','False'),
    FOREIGN KEY (question_id)  REFERENCES questions(id) ON DELETE CASCADE
  
);

-- 9. Scores Table
CREATE TABLE scores (
    id INT AUTO_INCREMENT
 PRIMARY KEY,
    user_id INT,
    question_id INT,
    score INT,
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id)  REFERENCES users(id),
    FOREIGN KEY (question_id)  REFERENCES questions(id)
);
-- seeding data -- Seeding Data for Techlabs Database

-- 1. Roles
INSERT INTO roles (role) VALUES
('Admin'),
('Trainer'),
('Trainee');

-- 2. Users
INSERT INTO users (username, full_name, email, password, role_id) VALUES
('admin1', 'John Doe', 'john.doe@example.com', 'hashed_password1', 1 ),
('member1', 'Jane Smith', 'jane.smith@example.com', 'hashed_password2', 2),
('member2', 'Alice Johnson', 'alice.johnson@example.com', 'hashed_password3', 2),
('guest1', 'Bob Brown', 'bob.brown@example.com', 'hashed_password4', 3);

-- 3. Projects
INSERT INTO projects (title, description, created_by) VALUES
('Website Redesign', 'Redesign company website for better UX', 1),
('Mobile App', 'Develop a new mobile application', 2);

-- 4. Project Tasks
INSERT INTO project_tasks (project_id, task_title, description, assigned_to, status, due_date) VALUES
(1, 'Design Homepage', 'Create wireframes for homepage', 2, 'pending', '2025-06-20'),
(1, 'Backend Setup', 'Set up server and database', 3, 'completed', '2025-06-15'),
(2, 'API Development', 'Develop RESTful APIs', 3, 'pending', '2025-06-25');

-- 5. Community Feedback
INSERT INTO community_feedback (user_id, guest_name, guest_email, project_id, comment, rating) VALUES
(2, NULL, NULL, 1, 'Great design ideas!', 4),
(NULL, 'Guest User', 'guest@example.com', 1, 'Needs more color', 3),
(3, NULL, NULL, 2, 'Looking forward to the app', 5);

-- 6. Events
INSERT INTO events (title, description, event_date, created_by, location) VALUES
('Tech Workshop', 'Learn about web development', '2025-06-20 14:00:00', 1, 'Techlabs HQ'),
('App Launch', 'Official launch of mobile app', '2025-07-01 18:00:00', 2, 'Online');

-- 6a. Event Registrations
INSERT INTO event_registrations (user_id, event_id, rsvp_status) VALUES
(2, 1, 'yes'),
(3, 1, 'maybe'),
(2, 2, 'yes');

-- 6b. Badges
INSERT INTO badges (badge_name, description) VALUES
('Contributor', 'Contributed to a project'),
('Event Organizer', 'Organized a community event');

-- 6c. User Badges
INSERT INTO user_badges (user_id, badge_id) VALUES
(2, 1),
(1, 2),
(3, 1);

-- 7. Questions
INSERT INTO questions (project_id, question, created_by) VALUES
(1, 'What is the primary color scheme for the website?', 1),
(2, 'Which platform is the app targeting first?', 2);

-- 8. Choices
INSERT INTO choices (question_id, choice, correct_choice) VALUES
(1, 'Blue and White', 'True'),
(1, 'Red and Black', 'False'),
(2, 'Android', 'True'),
(2, 'iOS', 'False');

-- 9. Scores
INSERT INTO scores (user_id, question_id, score) VALUES
(2, 1, 1),
(3, 1, 0 ),
(2, 2, 1 );