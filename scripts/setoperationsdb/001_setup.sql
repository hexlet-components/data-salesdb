DROP TABLE IF EXISTS course_members_2022;
CREATE TABLE course_members_2022 (
  id BIGINT PRIMARY KEY,
  username VARCHAR(50),
  coursename VARCHAR(255),
  created_at TIMESTAMP
);


DROP TABLE IF EXISTS course_members_2023;
CREATE TABLE course_members_2023 (
  id BIGINT PRIMARY KEY,
  username VARCHAR(50),
  coursename VARCHAR(255),
  created_at TIMESTAMP
);
