create KEYSPACE universities WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 3};

use universities;

/* Q1. Find Universities (including university info) near a person */
CREATE TABLE universities_near_person (
  person_id text,
  university_id text,
  university_name text,
  university_phone text,
  university_address text,
  distance float,
  PRIMARY KEY ((person_id), distance)
) WITH CLUSTERING ORDER BY (distance ASC)
AND comment = 'Q1. Find Universities (including university info) near a person';

INSERT INTO universities_near_person (person_id, university_id, university_name, university_phone, university_address, distance)
VALUES ('Student1', 'York', 'York University', '+1-647-123-1111', 'York Address', 20);

INSERT INTO universities_near_person (person_id, university_id, university_name, university_phone, university_address, distance)
VALUES ('Student1', 'UofT', 'University of Toronto', '+1-647-123-0000', 'UofT Address', 5);

INSERT INTO universities_near_person (person_id, university_id, university_name, university_phone, university_address, distance)
VALUES ('Student2', 'UofT', 'University of Toronto', '+1-647-123-0000', 'UofT Address', 15);

select university_id, university_name, university_phone, university_address from universities_near_person where person_id = 'Student1' AND distance < 10;

/*Q2. Find info about a given university*/
CREATE TABLE universities (
  university_id text PRIMARY KEY,
  university_name text,
  university_phone text,
  university_address text,
  courses set<text>
) WITH comment = 'Q2. Find info about a given university';

INSERT INTO universities (university_id, university_name, university_phone, university_address, courses)
VALUES ('UofT', 'University of Toronto', '+1-647-123-0000', 'UofT Address', {'Data Science', 'Machine Learning', 'Big Data'});

select * from universities;

/* Q3. Find people (only names) interested near a university */

CREATE TABLE people (
  university_id text,
  person_id text,
  person_name list<text>,
  distance float,
  PRIMARY KEY ((university_id), distance)
) WITH CLUSTERING ORDER BY (distance DESC)
AND comment = 'Q3. Find people (only names) interested near a university';

CREATE INDEX people_names ON universities.people(person_name);

INSERT INTO people (university_id, person_id, person_name, distance)
VALUES ('UofT', 'Student1', ['Jane', 'Smith'], 5);

INSERT INTO people (university_id, person_id, person_name, distance)
VALUES ('UofT', 'Student2', ['Jane', 'Anna','Smith'], 7.5);

select person_name from people where university_id='UofT' AND distance <10;

/* Q4. Find courses those registration date is in the future based on universities found in Q1 */

CREATE TABLE courses (
  university_id text,
  course_id text,
  course_name text,
  cost float,
  registration_date date,
  PRIMARY KEY ((university_id), registration_date, course_name)
) WITH CLUSTERING ORDER BY (registration_date DESC, course_name ASC)
AND comment = 'Q4. Find courses those registration date is in the future based on universities found in Q1.';

INSERT INTO courses (university_id, course_id, course_name, cost, registration_date)
VALUES ('UofT', 'SCS_3252_017', 'Big Data Management Systems & Tools', 995, '2019-09-19');

INSERT INTO courses (university_id, course_id, course_name, cost, registration_date)
VALUES ('UofT', 'SCS_3252_032', 'Big Data Management Systems & Tools', 995, '2020-01-04');

select course_name, course_id from courses where university_id = 'UofT' AND registration_date > toDate(now());

/* Q5. Find details about a person found in Q3 */

CREATE TABLE person (
  person_id text,
  person_name frozen <list<text>>,
  person_phone text,
  person_address text,
  PRIMARY KEY (person_name, person_id)
) WITH comment = 'Q5. Find details about a person found in Q3.';

INSERT INTO person (person_id, person_name, person_phone, person_address)
VALUES ('Student1', ['Jane', 'Smith'], '+1-416-123-4567', 'Student1 Address');

INSERT INTO person (person_id, person_name, person_phone, person_address)
VALUES ('Student2', ['Jane', 'Anna','Smith'], '+1-905-123-4567', 'Student2 Address');

select * from person where person_name = ['Jane', 'Smith'];
