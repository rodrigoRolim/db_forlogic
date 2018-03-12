use forlogic
--
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
--
DELETE FROM persons.users_types;
DBCC CHECKIDENT('persons.users_types', RESEED, 0)

-- person.users_types
INSERT INTO persons.users_types(names) VALUES('estudante');
INSERT INTO persons.users_types(names) VALUES('professor');
-- persons.users
INSERT INTO persons.users(names, id_user_type) VALUES ('junior', 1)
INSERT INTO persons.users(names, id_user_type) VALUES ('raimunda', 1);
INSERT INTO persons.users(names, id_user_type) VALUES ('nonata', 2);
INSERT INTO persons.users(names, id_user_type) VALUES ('raimundo nonato', 1);
INSERT INTO persons.users(names, id_user_type) VALUES ('severino', 2);
INSERT INTO persons.users(names, id_user_type) VALUES ('hugo', 1);
INSERT INTO persons.users(names, id_user_type) VALUES ('rodineli', 1);
INSERT INTO persons.users(names, id_user_type) VALUES ('rui', 2);
-- courses.courses
INSERT INTO courses.courses(names) VALUES ('engenharia');
INSERT INTO courses.courses(names) VALUES ('humanas');
INSERT INTO courses.courses(names) VALUES ('matemática');
INSERT INTO courses.courses(names) VALUES ('física');
INSERT INTO courses.courses(names) VALUES ('física teorica');
INSERT INTO courses.courses(names) VALUES ('matemática abstrata');
INSERT INTO courses.courses(names) VALUES ('química');
-- classes.courses_classes
INSERT INTO classes.courses_classes(names, id_course) VALUES ('turma A', 1);
INSERT INTO classes.courses_classes(names, id_course) VALUES ('turma B', 2);
INSERT INTO classes.courses_classes(names, id_course) VALUES ('turma C', 3);
INSERT INTO classes.courses_classes(names, id_course) VALUES ('turma D', 1);
INSERT INTO classes.courses_classes(names, id_course) VALUES ('turma E', 7);
INSERT INTO classes.courses_classes(names, id_course) VALUES ('turma F', 3);
-- 
SELECT * FROM persons.users_types;
SELECT * FROM persons.users;
SELECT * FROM courses.courses
SELECT * FROM  classes.courses_classes

--usuário tem que ser estudante, ou seja, id_users_types = 1 e que esteja matriculado em, no máximo, três turmas distintas.
--

go
Create  PROCEDURE classes.setstudent(
	@id_user INT ,
	@id_course_class INT
)
AS
DECLARE @result INT, @linhas INT
SELECT @result = id_user_type FROM  persons.users WHERE id_user = @id_user
SELECT @linhas = count(id_user) FROM classes.courses_classes_students WHERE id_user = @id_user
IF @result = 1 and @linhas < 3
BEGIN
	INSERT INTO classes.courses_classes_students(id_course_class, id_user) VALUES(@id_course_class, @id_user)
END
ELSE
 PRINT N'NÃO PODE ADICIONÁ-LO';
 PRINT @result
 PRINT @linhas
go

EXEC classes.setstudent @id_user = 1, @id_course_class = 1; 
EXEC classes.setstudent @id_user = 1, @id_course_class = 2;
EXEC classes.setstudent @id_user = 1, @id_course_class = 4;
EXEC classes.setstudent @id_user = 2, @id_course_class = 1;
EXEC classes.setstudent @id_user = 3, @id_course_class = 5;
EXEC classes.setstudent @id_user = 4, @id_course_class = 3;
EXEC classes.setstudent @id_user = 3, @id_course_class = 3;
EXEC classes.setstudent @id_user = 3, @id_course_class = 2;
 
go
DROP PROCEDURE classes.setstudent;
go
--
exec sp_MSforeachtable @command1="print '?'", @command2="ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"