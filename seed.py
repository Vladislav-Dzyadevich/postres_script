from faker import Faker
import psycopg2
import random

# Підключення до бази даних
conn = psycopg2.connect(
    dbname="postgres",
    user="postgres",
    password="postgres",
    host="localhost",
    port="5432"
)

# Створення об'єкту Faker
fake = Faker()

# Функція для вставки даних у таблицю users
def insert_users(conn, cur, num_records):
    for _ in range(num_records):
        fullname = fake.name()
        email = fake.email()
        cur.execute("INSERT INTO users (fullname, email) VALUES (%s, %s) RETURNING id", (fullname, email))
        user_id = cur.fetchone()[0]
        conn.commit()
        yield user_id

# Функція для вставки даних у таблицю status
def insert_status(conn, cur):
    statuses = ['new', 'in progress', 'completed']
    for status in statuses:
        cur.execute("SELECT id FROM status WHERE name = %s", (status,))
        existing_status = cur.fetchone()
        if not existing_status:
            cur.execute("INSERT INTO status (name) VALUES (%s)", (status,))
    conn.commit()


# Функція для вставки даних у таблицю tasks
def insert_tasks(conn, cur, num_records, num_users):
    user_ids = list(insert_users(conn, cur, num_users))
    for _ in range(num_records):
        title = fake.sentence()
        description = fake.paragraph()
        status_id = random.randint(1, 3)  # Випадковий ідентифікатор статусу
        user_id = random.choice(user_ids)  # Випадковий ідентифікатор користувача зі списку існуючих
        cur.execute("INSERT INTO tasks (title, description, status_id, user_id) VALUES (%s, %s, %s, %s)",
                    (title, description, status_id, user_id))
    conn.commit()

# Виклик функцій для вставки даних
num_users = 10  # Кількість користувачів
num_tasks = 20  # Кількість завдань

cur = conn.cursor()

insert_status(conn, cur)
insert_tasks(conn, cur, num_tasks, num_users)

cur.close()
conn.close()