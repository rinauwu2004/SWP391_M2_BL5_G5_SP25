CREATE DATABASE [SWP391_M2_BL5]
USE [SWP391_M2_BL5]
GO

CREATE TABLE [Country] (
	[id] INT IDENTITY(1,1),
	[name] NVARCHAR(50) UNIQUE NOT NULL,
	[code] VARCHAR(10) NOT NULL,
	[prefix] VARCHAR(10) NOT NULL,

	CONSTRAINT [PK_Country] PRIMARY KEY ([id])
);

CREATE TABLE [UserStatus] (
	[id] int IDENTITY(1,1),
	[name] varchar(50) NOT NULL,

	CONSTRAINT [PK_UserStatus] PRIMARY KEY ([id])
)

CREATE TABLE [Role] (
	[id] int IDENTITY(1,1),
	[name] varchar(50) UNIQUE NOT NULL,
	[description] text NOT NULL,

	CONSTRAINT [PK_Role] PRIMARY KEY ([id]),
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
	[role_id] int NOT NULL,
	[created_at] datetime DEFAULT(GETDATE()),

	CONSTRAINT [PK_User] PRIMARY KEY ([id]),
	CONSTRAINT [FK_User_UserStatus] FOREIGN KEY ([status_id]) REFERENCES [UserStatus]([id]) ON UPDATE CASCADE,
	CONSTRAINT [FK_User_Role] FOREIGN KEY ([role_id]) REFERENCES [Role]([id]),
	CONSTRAINT [FK_User_Country] FOREIGN KEY ([country_id]) REFERENCES [Country]([id])
)

CREATE TABLE [Subject] (
	[id] int IDENTITY(1,1),
	[code] varchar(10) NOT NULL,
	[name] varchar(255) NOT NULL,
	[description] text NOT NULL,
	[status] bit DEFAULT(1),
	[created_at] datetime DEFAULT(GETDATE()),
	[modified_at] datetime,

	CONSTRAINT [PK_Subject] PRIMARY KEY ([id])
)

CREATE TABLE [Quiz] (
	[id] int IDENTITY(1,1),
	[teacherId] int NOT NULL,
	[title] nvarchar(255) NOT NULL,
	[description] nvarchar(max),
	[code] varchar(20) UNIQUE,
	[timeLimit] int,
	[status] varchar(20) DEFAULT 'Not started',
	[createdAt] DATETIME DEFAULT GETDATE(),

	CONSTRAINT [PK_Quiz] PRIMARY KEY ([id]),
	CONSTRAINT [FK_Quiz_User] FOREIGN KEY ([teacherId]) REFERENCES [User]([id])
);

CREATE TABLE [Question] (
	[id] int IDENTITY(1,1),
	[quizId] int NOT NULL,
	[content] NVARCHAR(MAX) NOT NULL,
  
	CONSTRAINT [PK_Question] PRIMARY KEY ([id]),
	CONSTRAINT [FK_Question_Quiz] FOREIGN KEY ([quizId]) REFERENCES [Quiz]([id])
);

CREATE TABLE [Answer] (
	[id] int IDENTITY(1,1),
	[questionId] int NOT NULL,
	[content] NVARCHAR(MAX) NOT NULL,
	[isCorrect] BIT DEFAULT 0,

	CONSTRAINT [PK_Answer] PRIMARY KEY ([id]),
	CONSTRAINT [FK_Answer_Question] FOREIGN KEY ([questionId]) REFERENCES [Question]([id])
);

CREATE TABLE [QuizAttempt] (
	[id] int IDENTITY(1,1),
	[studentId] int NOT NULL,
	[quizId] int NOT NULL,
	[startedTime] DATETIME DEFAULT GETDATE(),
	[submittedTime] DATETIME,
	[score] FLOAT,

	CONSTRAINT [PK_QuizAttempt] PRIMARY KEY ([id]),
	CONSTRAINT [FK_QuizAttempt_Quiz] FOREIGN KEY ([quizId]) REFERENCES [Quiz]([id]),
	CONSTRAINT [FK_QuizAttempt_User] FOREIGN KEY ([studentId]) REFERENCES [User]([id])
);

CREATE TABLE [QuizAttemptDetail] (
	[id] INT IDENTITY(1,1),
	[attemptId] INT NOT NULL,
	[questionId] INT NOT NULL,
	[answerId] INT NOT NULL,
  
	CONSTRAINT [PK_QuizAttemptDetail] PRIMARY KEY ([id]),
	CONSTRAINT [FK_QuizAttemptDetail_QuizAttempt] FOREIGN KEY ([attemptId]) REFERENCES [QuizAttempt]([id]),
	CONSTRAINT [FK_QuizAttemptDetail_Question] FOREIGN KEY ([questionId]) REFERENCES [Question]([id]),
	CONSTRAINT [FK_QuizAttemptDetail_Answer] FOREIGN KEY ([answerId]) REFERENCES [Answer]([id])
);

CREATE TABLE [Lesson] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) NOT NULL,
	[description] [text] NULL,
	[subject_id] [int] NOT NULL,
	[status] [bit] NULL,
	[modified_at] [datetime] NULL,
	[created_at] [datetime] NULL,

	CONSTRAINT [PK_Lesson] PRIMARY KEY ([id]),
	CONSTRAINT [FK_Lesson_Subject] FOREIGN KEY ([subject_id]) REFERENCES [Subject]([id])
);

CREATE TABLE [Module](
	[id] [int] IDENTITY(1,1),
	[name] [varchar](255) NOT NULL,
	[lesson_id] INT NOT NULL,
	[description] [text] NULL,
	[url] [varchar](255) NULL,
	
	CONSTRAINT [PK_Module] PRIMARY KEY ([id]),
	CONSTRAINT [FK_Module_Lesson] FOREIGN KEY ([lesson_id]) REFERENCES [Lesson]([id])
);

CREATE TABLE [dbo].[UserSubject](
	[id] [int] IDENTITY(1,1),
	[user_id] [int] NOT NULL,
	[subject_id] [int] NOT NULL,

	CONSTRAINT [PK_UserSubject] PRIMARY KEY ([id]),
	CONSTRAINT [FK_UserSubject_User] FOREIGN KEY ([user_id]) REFERENCES [User]([id]),
	CONSTRAINT [FK_UserSubject_Subject] FOREIGN KEY ([subject_id]) REFERENCES [Subject]([id])
);