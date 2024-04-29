CREATE TABLE users (
   id SERIAL PRIMARY KEY,
   fullname VARCHAR(100),
   email VARCHAR(100) UNIQUE
);

CREATE TABLE status (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE
);

CREATE TABLE tasks (
   id SERIAL PRIMARY KEY,
   title VARCHAR(100),
   description TEXT,
   status_id INTEGER,
   user_id INTEGER,
   FOREIGN KEY (status_id) REFERENCES status(id),
   FOREIGN KEY (user_id) REFERENCES users(id)
);


ALTER TABLE tasks
ADD CONSTRAINT fk_user_id
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE CASCADE;

ALTER TABLE tasks
ADD CONSTRAINT fk_status_id
FOREIGN KEY (status_id)
REFERENCES status(id)
ON DELETE CASCADE;


Запити в Бд


select *
from tasks
join users on tasks.user_id = users.id
where users.id = 38;


select *
from tasks
where status_id = (
select id
from status
where name = 'new'
);


UPDATE tasks
SET status_id = (
   SELECT id
   FROM status
   WHERE name = 'in progress'
)
WHERE id = 38;


SELECT *
FROM users
WHERE id NOT IN (
   SELECT DISTINCT user_id
   FROM tasks
);


INSERT INTO tasks (title, description, status_id, user_id)
VALUES ('HW', 'Do a calc progran', 1, 1);


SELECT *
FROM tasks
WHERE status_id != (
   SELECT id
   FROM status
   WHERE name = 'completed'
);


DELETE FROM tasks
WHERE id = 38;


SELECT *
FROM users
WHERE email LIKE '%example.com';


UPDATE users
SET fullname = 'Vlad'
WHERE id = 38;


SELECT status.name, COUNT(*) AS tasks_count
FROM tasks
JOIN status ON tasks.status_id = status.id
GROUP BY status.name;


SELECT tasks.*
FROM tasks
JOIN users ON tasks.user_id = users.id
WHERE users.email LIKE '%example.com';




SELECT *
FROM tasks
WHERE description IS NULL OR description = '';


SELECT users.*, tasks.*
FROM users
INNER JOIN tasks ON users.id = tasks.user_id
INNER JOIN status ON tasks.status_id = status.id
WHERE status.name = 'in progress';




SELECT users.id, users.fullname, COUNT(tasks.id) AS task_count
FROM users
LEFT JOIN tasks ON users.id = tasks.user_id
GROUP BY users.id, users.fullname;
