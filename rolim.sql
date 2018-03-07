use tempdb;
ALTER DATABASE forlogic SET OFFLINE WITH ROLLBACK IMMEDIATE;
ALTER DATABASE forlogic SET ONLINE;
DROP DATABASE forlogic;
go
CREATE DATABASE forlogic
go
use forlogic
go
CREATE SCHEMA persons
go
CREATE SCHEMA courses
go
CREATE SCHEMA classes
go
CREATE SCHEMA contents
go
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
go
IF NOT EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'persons.users_type') and OBJECTPROPERTY(id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE persons.users_types 
		(
			id_user_type	int IDENTITY(1,1) NOT NULL,
			names			nvarchar(100) NOT NULL,
			removed			int DEFAULT((0)) CHECK(removed >= 0 and removed <= 1) NOT NULL, 
			primary key (id_user_type)
		)
	END
go
IF NOT EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'persons.users') and OBJECTPROPERTY(id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE persons.users
		(
			id_user			int IDENTITY (1,1) NOT NULL ,
	        names			NVARCHAR (200) NOT NULL,
			removed			int DEFAULT ((0)) CHECK (removed >= 0 and removed <= 1) NOT NULL,
			id_user_type	int,
			foreign key (id_user_type) references persons.users_types (id_user_type),
			primary key (id_user)

		)
	END
go
IF NOT EXISTS (SELECT * FROM dbo.sysobjects where id = object_id (N'persons.users_login') and OBJECTPROPERTY (id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE users_login 
		(
			id_user_login	int IDENTITY (1,1) NOT NULL,
			id_user			int NOT NULL,
			dates			datetime NOT NULL DEFAULT GETDATE(),
			primary key (id_user_login),
			foreign key (id_user) references persons.users(id_user)
		)
	END
go
IF NOT EXISTS (SELECT * FROM dbo.sysobjects where id = object_id (N'courses.courses') and OBJECTPROPERTY (id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE courses.courses 
		(
			id_course	int IDENTITY (1,1) NOT NULL,
			names		nvarchar (100) NOT NULL,
			removed		int DEFAULT ((0)) CHECK (removed >= 0 and removed <= 1) NOT NULL,
			primary key (id_course)
		)
	END
go
IF NOT EXISTS (SELECT * FROM dbo.sysobjects where id = object_id (N'courses.tutors') and OBJECTPROPERTY (id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE courses.tutors
		(
			id_course_tutor		int IDENTITY (1,1) NOT NULL,
			id_course			int NOT NULL,
			id_user				int NOT NULL,
			primary key (id_course_tutor),
			foreign key (id_course) references courses.courses (id_course),
			foreign key (id_user) references persons.users(id_user)
		)
	END
go
IF NOT EXISTS (SELECT * FROM dbo.sysobjects where id = object_id (N'classes.courses_classes') and OBJECTPROPERTY (id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE classes.courses_classes 
		(
			id_course_class		int IDENTITY (1,1) NOT NULL,
			names				nvarchar (100) NOT NULL,
			removed				int DEFAULT ((0)) CHECK (removed >= 0 and removed <= 1) NOT NULL,
			id_course			int NOT NULL,
			primary key (id_course_class),
			foreign key (id_course) references courses.courses (id_course),
		)
	END
go
IF NOT EXISTS (SELECT * FROM dbo.sysobjects where id = object_id (N'classes.courses_classes_students') and OBJECTPROPERTY (id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE classes.courses_classes_students 
		(
			id_course_class_student		int IDENTITY (1,1) NOT NULL,
			id_course_class				int NOT NULL,
			id_user						int NOT NULL,
			removed						int DEFAULT ((0)) CHECK (removed >= 0 and removed <= 1) NOT NULL,
			primary key (id_course_class_student),
			foreign key (id_course_class) references classes.courses_classes (id_course_class)
		)
	END
go

IF NOT EXISTS (SELECT * FROM dbo.sysobjects where id = object_id (N'classes.courses_classes_contents') and OBJECTPROPERTY (id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE classes.courses_classes_contents
		(
			id_courses_classes_contents		int IDENTITY (1,1) NOT NULL,
			removed				int DEFAULT ((0)) CHECK (removed >= 0 and removed <= 1) NOT NULL,
			descriptions		nvarchar (MAX),
			id_courses_class	int NOT NULL,
			primary key (id_courses_classes_contents),
			foreign key (id_courses_class) references classes.courses_classes (id_course_class)
		)
	END
go
IF NOT EXISTS (SELECT * FROM dbo.sysobjects where id = object_id (N'classes.courses_classes_schedule') and OBJECTPROPERTY (id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE classes.courses_classes_schedule
		(
			id_schedule			int IDENTITY (1,1) NOT NULL,
			id_course_class		int NOT NULL,
			datas				datetime NOT NULL,
			date_finished		datetime NOT NULL,
			removed				int DEFAULT ((0)) CHECK (removed >= 0 and removed <= 1) NOT NULL,
			primary key (id_schedule),
			foreign key (id_course_class) references classes.courses_classes (id_course_class)
		)
	END
go
IF NOT EXISTS (SELECT * FROM dbo.sysobjects where id = object_id (N'classes.courses_classes_tutors') and OBJECTPROPERTY (id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE classes.courses_classes_tutors
		(
			id_courses_classes_tutors		int IDENTITY (1,1) NOT NULL,
			id_course_class					int NOT NULL,
			id_course_tutor					int NOT NULL,
			removed				int DEFAULT ((0)) CHECK (removed >= 0 and removed <= 1) NOT NULL,
			primary key (id_courses_classes_tutors),
			foreign key (id_course_class) references classes.courses_classes (id_course_class),
			foreign key (id_course_tutor) references courses.tutors (id_course_tutor)
		)
	END
go
IF NOT EXISTS (SELECT * FROM dbo.sysobjects where id = object_id (N'contents.courses_classes_activities') and OBJECTPROPERTY (id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE contents.courses_classes_activities
		(
			id_activity			int IDENTITY (1,1) NOT NULL,
			id_course_class		int NOT NULL,
			removed				int DEFAULT ((0)) CHECK (removed >= 0 and removed <= 1) NOT NULL,
			descriptions		nvarchar (MAX),
			scheduled_date		datetime NOT NULL,
			primary key (id_activity),
			foreign key (id_course_class) references classes.courses_classes (id_course_class) 
		)
	END
go
IF NOT EXISTS (SELECT * FROM dbo.sysobjects where id = object_id (N'contents.courses_classes_activities_students') and OBJECTPROPERTY (id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE contents.courses_classes_activities_students
		(
			id_activity_classes_students	int IDENTITY (1,1) NOT NULL,
			id_activity						int NOT NULL,
			id_course_class_student			int NOT NULL,
			removed							int DEFAULT ((0)) CHECK (removed >= 0 and removed <= 1) NOT NULL,
			delivery_date					datetime NOT NULL,
			primary key (id_activity_classes_students),
			foreign key (id_activity) references contents.courses_classes_activities (id_activity),
			foreign key (id_course_class_student) references classes.courses_classes_students 
		)
	END
go

IF NOT EXISTS (SELECT * FROM dbo.sysobjects where id = object_id (N'contents.courses_classes_assessements') and OBJECTPROPERTY (id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE contents.courses_classes_assessements
		(
			id_assessement				int IDENTITY (1,1) NOT NULL,
			id_course_class				int NOT NULL,
			removed						int DEFAULT ((0)) CHECK (removed >= 0 and removed <= 1) NOT NULL,
			schedule_date				datetime NOT NULL,
			realization_date			datetime,
			descriptions				nvarchar (MAX) NOT NULL,
			primary key (id_assessement),
			foreign key (id_course_class) references classes.courses_classes,
		)
	END
go

IF NOT EXISTS (SELECT * FROM dbo.sysobjects where id = object_id (N'contents.assessements_students') and OBJECTPROPERTY (id, N'IsTable') = 1)
	BEGIN
		CREATE TABLE contents.assessements_students
		(
			id_assessements_student		int IDENTITY (1,1) NOT NULL,
			id_course_class_student		int NOT NULL,
			id_assessement				int NOT NULL,
			note						decimal (5,1) NOT NULL,
			removed						int DEFAULT ((0)) CHECK (removed >= 0 and removed <= 1) NOT NULL,
			primary key (id_assessements_student),
			foreign key (id_course_class_student) references classes.courses_classes_students (id_course_class_student),
			foreign key (id_assessement) references contents.courses_classes_assessements (id_assessement)
		) 
	END
go
exec sp_MSforeachtable @command1="print '?'", @command2="ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
