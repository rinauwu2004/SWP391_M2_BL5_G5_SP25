CREATE DATABASE [SWP391_M2_BL5]
USE [SWP391_M2_BL5]
GO

CREATE TABLE [Country] (
	[id] INT IDENTITY(1,1),
	[name] NVARCHAR(50) NOT NULL,
	[code] VARCHAR(10) NOT NULL,
	[prefix] VARCHAR(10) NOT NULL,

	CONSTRAINT PK_Country PRIMARY KEY ([id])
);

CREATE TABLE [UserStatus] (
	[id] int IDENTITY(1,1),
	[name] varchar(50) NOT NULL,

	CONSTRAINT PK_UserStatus PRIMARY KEY ([id])
)

CREATE TABLE [User] (
	[id] int IDENTITY(1,1),
	[username] varchar(50) UNIQUE NOT NULL,
	[password_hash] varchar(50) NOT NULL,
	[password_salt] varchar(50) NOT NULL,
	[first_name] nvarchar(20) NOT NULL,
	[last_name] nvarchar(50) NOT NULL,
	[date_of_birth] date NOT NULL,
	[country_id] int NOT NULL,
	[phone_number] varchar(20) UNIQUE NOT NULL,
	[email_address] varchar(255) UNIQUE NOT NULL,
	[address] text NOT NULL,
	[status_id] int DEFAULT(1),
	[created_at] datetime DEFAULT(GETDATE()),

	CONSTRAINT PK_User PRIMARY KEY ([id]),
	CONSTRAINT FK_User_UserStatus FOREIGN KEY ([status_id]) REFERENCES [UserStatus]([id]) ON UPDATE CASCADE,
	CONSTRAINT FK_User_Country FOREIGN KEY ([country_id]) REFERENCES [Country]([id])
)

CREATE TABLE [Role] (
	[id] int IDENTITY(1,1),
	[name] varchar(50) NOT NULL,
	[description] text,

	CONSTRAINT PK_Role PRIMARY KEY ([id]),
)

CREATE TABLE [UserRole] (
	[id] int IDENTITY(1,1),
	[user_id] int NOT NULL,
	[role_id] int NOT NULL,

	CONSTRAINT PK_UserRole PRIMARY KEY ([id]),
	CONSTRAINT FK_UserRole_User FOREIGN KEY ([user_id]) REFERENCES [User]([id]) ON UPDATE CASCADE,
	CONSTRAINT FK_UserRole_Role FOREIGN KEY ([role_id]) REFERENCES [Role]([id]) ON UPDATE CASCADE
)

CREATE TABLE [Subject] (
	[id] int IDENTITY(1,1),
	[code] varchar(10) NOT NULL,
	[name] varchar(255) NOT NULL,
	[description] text NOT NULL,
	[status] bit DEFAULT(1),
	[created_at] datetime DEFAULT(GETDATE()),
	[modified_at] datetime,

	CONSTRAINT PK_Subject PRIMARY KEY ([id]),
)

CREATE TABLE [Quiz] (
	[id] int IDENTITY(1,1),
	[title] varchar(255) NOT NULL,
	[subject_id] int NOT NULL,
	[description] text,
	[duration] int NOT NULL,
	[is_started] bit DEFAULT(0),

	CONSTRAINT PK_Quiz PRIMARY KEY ([id]),
	CONSTRAINT FK_Quiz_Subject FOREIGN KEY ([subject_id]) REFERENCES [Subject]([id]) ON UPDATE CASCADE,
)

CREATE TABLE [Question] (
	[id] int IDENTITY(1,1),
	[description] text NOT NULL,
	[option] text NOT NULL,
	[correct_answer] text NOT NULL,

	CONSTRAINT PK_Question PRIMARY KEY ([id]),
)

CREATE TABLE [QuizQuestion] (
	[id] int IDENTITY(1,1),
	[quiz_id] int NOT NULL,
	[question_id] int NOT NULL,

	CONSTRAINT PK_QuizQuestion PRIMARY KEY ([id]),
	CONSTRAINT FK_QuizQuestion_Quiz FOREIGN KEY ([quiz_id]) REFERENCES [Quiz]([id]) ON UPDATE CASCADE,
	CONSTRAINT FK_QuizQuestion_Question FOREIGN KEY ([question_id]) REFERENCES [Question]([id]) ON UPDATE CASCADE,
)

CREATE TABLE [UserAnswer] (
	[id] int IDENTITY(1,1),
	[user_id] int NOT NULL,
	[quiz_id] int NOT NULL,
	[question_id] int NOT NULL,
	[selected_answer] text NOT NULL,
	[is_correct] bit NOT NULL,

	CONSTRAINT PK_UserAnswer PRIMARY KEY ([id]),
	CONSTRAINT FK_UserAnswer_User FOREIGN KEY ([user_id]) REFERENCES [User]([id]) ON UPDATE CASCADE,
	CONSTRAINT FK_UserAnswer_Quiz FOREIGN KEY ([quiz_id]) REFERENCES [Quiz]([id]) ON UPDATE CASCADE,
	CONSTRAINT FK_UserAnswer_Question FOREIGN KEY ([question_id]) REFERENCES [Question]([id]) ON UPDATE CASCADE
)

CREATE TABLE [QuizResult] (
	[id] int IDENTITY(1,1),
	[user_id] int NOT NULL,
	[quiz_id] int NOT NULL,
	[score] decimal(10,2) NOT NULL,
	[submitted_time] datetime NOT NULL,

	CONSTRAINT PK_QuizResult PRIMARY KEY ([id]),
	CONSTRAINT FK_QuizResult_User FOREIGN KEY ([user_id]) REFERENCES [User]([id]) ON UPDATE CASCADE,
	CONSTRAINT FK_QuizResult_Quiz FOREIGN KEY ([quiz_id]) REFERENCES [Quiz]([id]) ON UPDATE CASCADE
)