<!--USE [testitel2]
GO
/****** Object:  Table [dbo].[Lesson]    Script Date: 4/26/2025 9:56:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lesson](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) NOT NULL,
	[description] [text] NULL,
	[subject_id] [int] NOT NULL,
	[status] [bit] NULL,
	[modified_at] [datetime] NULL,
	[created_at] [datetime] NULL,
 CONSTRAINT [PK_Lesson] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Module]    Script Date: 4/26/2025 9:56:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Module](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) NOT NULL,
	[description] [text] NULL,
	[url] [varchar](255) NULL,
 CONSTRAINT [PK_Module] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Question]    Script Date: 4/26/2025 9:56:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Question](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[description] [text] NOT NULL,
	[option] [text] NOT NULL,
	[correct_answer] [text] NOT NULL,
 CONSTRAINT [PK_Question] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Quiz]    Script Date: 4/26/2025 9:56:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Quiz](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [varchar](255) NOT NULL,
	[subject_id] [int] NOT NULL,
	[description] [text] NULL,
	[duration] [int] NOT NULL,
	[is_started] [bit] NULL,
 CONSTRAINT [PK_Quiz] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuizQuestion]    Script Date: 4/26/2025 9:56:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuizQuestion](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[quiz_id] [int] NOT NULL,
	[question_id] [int] NOT NULL,
 CONSTRAINT [PK_QuizQuestion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuizResult]    Script Date: 4/26/2025 9:56:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuizResult](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[quiz_id] [int] NOT NULL,
	[score] [decimal](10, 2) NOT NULL,
	[submitted_time] [datetime] NOT NULL,
 CONSTRAINT [PK_QuizResult] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 4/26/2025 9:56:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[description] [text] NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Subject]    Script Date: 4/26/2025 9:56:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subject](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [varchar](10) NOT NULL,
	[name] [varchar](255) NOT NULL,
	[description] [text] NOT NULL,
	[status] [bit] NULL,
	[created_at] [datetime] NULL,
	[modified_at] [datetime] NULL,
 CONSTRAINT [PK_Subject] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 4/26/2025 9:56:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[password_hash] [varchar](50) NOT NULL,
	[password_salt] [varchar](50) NOT NULL,
	[first_name] [varchar](20) NOT NULL,
	[last_name] [varchar](20) NOT NULL,
	[date_of_birth] [date] NOT NULL,
	[phone_number] [int] NOT NULL,
	[email_address] [varchar](255) NOT NULL,
	[address] [text] NOT NULL,
	[status_id] [int] NULL,
	[created_at] [datetime] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAnswer]    Script Date: 4/26/2025 9:56:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAnswer](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[quiz_id] [int] NOT NULL,
	[question_id] [int] NOT NULL,
	[selected_answer] [text] NOT NULL,
	[is_correct] [bit] NOT NULL,
 CONSTRAINT [PK_UserAnswer] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 4/26/2025 9:56:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[role_id] [int] NOT NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserStatus]    Script Date: 4/26/2025 9:56:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserStatus](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UserStatus] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSubject]    Script Date: 4/26/2025 9:56:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserSubject](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[subject_id] [int] NOT NULL,
 CONSTRAINT [PK_UserSubject] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Lesson] ON 

INSERT [dbo].[Lesson] ([id], [name], [description], [subject_id], [status], [modified_at], [created_at]) VALUES (1, N'Linear Equationswwsss', N'Solving simple linear equationssssss', 1, 0, CAST(N'2025-04-26T21:34:39.320' AS DateTime), CAST(N'2025-04-26T00:38:58.073' AS DateTime))
INSERT [dbo].[Lesson] ([id], [name], [description], [subject_id], [status], [modified_at], [created_at]) VALUES (7, N'ddd', N'dd', 2, 1, CAST(N'2025-04-26T21:25:34.777' AS DateTime), CAST(N'2025-04-26T21:25:34.777' AS DateTime))
INSERT [dbo].[Lesson] ([id], [name], [description], [subject_id], [status], [modified_at], [created_at]) VALUES (8, N'Linear Equationswwsss', N'dddd', 1, 1, CAST(N'2025-04-26T21:30:28.903' AS DateTime), CAST(N'2025-04-26T21:30:28.903' AS DateTime))
INSERT [dbo].[Lesson] ([id], [name], [description], [subject_id], [status], [modified_at], [created_at]) VALUES (9, N'Linear Equationswwsss', N'ddd', 1, 1, CAST(N'2025-04-26T21:32:57.017' AS DateTime), CAST(N'2025-04-26T21:32:57.017' AS DateTime))
INSERT [dbo].[Lesson] ([id], [name], [description], [subject_id], [status], [modified_at], [created_at]) VALUES (10, N'ssss', N'ssss', 2, 1, CAST(N'2025-04-26T21:50:03.217' AS DateTime), CAST(N'2025-04-26T21:50:03.217' AS DateTime))
INSERT [dbo].[Lesson] ([id], [name], [description], [subject_id], [status], [modified_at], [created_at]) VALUES (11, N'sss', N'dffff', 2, 0, CAST(N'2025-04-26T21:50:07.913' AS DateTime), CAST(N'2025-04-26T21:50:07.913' AS DateTime))
INSERT [dbo].[Lesson] ([id], [name], [description], [subject_id], [status], [modified_at], [created_at]) VALUES (12, N'Linear Equationswwsss', N'sss', 2, 0, CAST(N'2025-04-26T21:50:11.877' AS DateTime), CAST(N'2025-04-26T21:50:11.877' AS DateTime))
INSERT [dbo].[Lesson] ([id], [name], [description], [subject_id], [status], [modified_at], [created_at]) VALUES (13, N'aa', N'ddd', 2, 1, CAST(N'2025-04-26T21:50:15.820' AS DateTime), CAST(N'2025-04-26T21:50:15.820' AS DateTime))
INSERT [dbo].[Lesson] ([id], [name], [description], [subject_id], [status], [modified_at], [created_at]) VALUES (14, N'ww', N'www', 2, 0, CAST(N'2025-04-26T21:50:19.610' AS DateTime), CAST(N'2025-04-26T21:50:19.610' AS DateTime))
SET IDENTITY_INSERT [dbo].[Lesson] OFF
GO
SET IDENTITY_INSERT [dbo].[Module] ON 

INSERT [dbo].[Module] ([id], [name], [description], [url]) VALUES (1, N'Algebra Basics', N'Basic concepts of algebra', N'https://example.com/algebra')
INSERT [dbo].[Module] ([id], [name], [description], [url]) VALUES (2, N'Newtonian Mechanics', N'Classical physics module', N'https://example.com/mechanics')
SET IDENTITY_INSERT [dbo].[Module] OFF
GO
SET IDENTITY_INSERT [dbo].[Subject] ON 

INSERT [dbo].[Subject] ([id], [code], [name], [description], [status], [created_at], [modified_at]) VALUES (1, N'MTH101', N'Mathematics', N'Basic Mathematics course', 1, CAST(N'2025-04-26T00:38:58.067' AS DateTime), NULL)
INSERT [dbo].[Subject] ([id], [code], [name], [description], [status], [created_at], [modified_at]) VALUES (2, N'PHY101', N'Physics', N'Introduction to Physics', 1, CAST(N'2025-04-26T00:38:58.067' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Subject] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__User__20C6DFF5FD7370D8]    Script Date: 4/26/2025 9:56:34 PM ******/
ALTER TABLE [dbo].[User] ADD UNIQUE NONCLUSTERED 
(
	[email_address] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__User__A1936A6BFD8F11AE]    Script Date: 4/26/2025 9:56:34 PM ******/
ALTER TABLE [dbo].[User] ADD UNIQUE NONCLUSTERED 
(
	[phone_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__User__F3DBC572D40F2EB3]    Script Date: 4/26/2025 9:56:34 PM ******/
ALTER TABLE [dbo].[User] ADD UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lesson] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[Lesson] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Quiz] ADD  DEFAULT ((0)) FOR [is_started]
GO
ALTER TABLE [dbo].[Subject] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[Subject] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[User] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[Lesson]  WITH CHECK ADD  CONSTRAINT [FK_Lesson_Subject] FOREIGN KEY([subject_id])
REFERENCES [dbo].[Subject] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Lesson] CHECK CONSTRAINT [FK_Lesson_Subject]
GO
ALTER TABLE [dbo].[Quiz]  WITH CHECK ADD  CONSTRAINT [FK_Quiz_Subject] FOREIGN KEY([subject_id])
REFERENCES [dbo].[Subject] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Quiz] CHECK CONSTRAINT [FK_Quiz_Subject]
GO
ALTER TABLE [dbo].[QuizQuestion]  WITH CHECK ADD  CONSTRAINT [FK_QuizQuestion_Question] FOREIGN KEY([question_id])
REFERENCES [dbo].[Question] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[QuizQuestion] CHECK CONSTRAINT [FK_QuizQuestion_Question]
GO
ALTER TABLE [dbo].[QuizQuestion]  WITH CHECK ADD  CONSTRAINT [FK_QuizQuestion_Quiz] FOREIGN KEY([quiz_id])
REFERENCES [dbo].[Quiz] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[QuizQuestion] CHECK CONSTRAINT [FK_QuizQuestion_Quiz]
GO
ALTER TABLE [dbo].[QuizResult]  WITH CHECK ADD  CONSTRAINT [FK_QuizResult_Quiz] FOREIGN KEY([quiz_id])
REFERENCES [dbo].[Quiz] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[QuizResult] CHECK CONSTRAINT [FK_QuizResult_Quiz]
GO
ALTER TABLE [dbo].[QuizResult]  WITH CHECK ADD  CONSTRAINT [FK_QuizResult_User] FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[QuizResult] CHECK CONSTRAINT [FK_QuizResult_User]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_UserStatus] FOREIGN KEY([status_id])
REFERENCES [dbo].[UserStatus] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_UserStatus]
GO
ALTER TABLE [dbo].[UserAnswer]  WITH CHECK ADD  CONSTRAINT [FK_UserAnswer_Question] FOREIGN KEY([question_id])
REFERENCES [dbo].[Question] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[UserAnswer] CHECK CONSTRAINT [FK_UserAnswer_Question]
GO
ALTER TABLE [dbo].[UserAnswer]  WITH CHECK ADD  CONSTRAINT [FK_UserAnswer_Quiz] FOREIGN KEY([quiz_id])
REFERENCES [dbo].[Quiz] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[UserAnswer] CHECK CONSTRAINT [FK_UserAnswer_Quiz]
GO
ALTER TABLE [dbo].[UserAnswer]  WITH CHECK ADD  CONSTRAINT [FK_UserAnswer_User] FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[UserAnswer] CHECK CONSTRAINT [FK_UserAnswer_User]
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK_UserRole_Role] FOREIGN KEY([role_id])
REFERENCES [dbo].[Role] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK_UserRole_Role]
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK_UserRole_User] FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK_UserRole_User]
GO
ALTER TABLE [dbo].[UserSubject]  WITH CHECK ADD  CONSTRAINT [FK_UserSubject_Subject] FOREIGN KEY([subject_id])
REFERENCES [dbo].[Subject] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[UserSubject] CHECK CONSTRAINT [FK_UserSubject_Subject]
GO
ALTER TABLE [dbo].[UserSubject]  WITH CHECK ADD  CONSTRAINT [FK_UserSubject_User] FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[UserSubject] CHECK CONSTRAINT [FK_UserSubject_User]
GO-->
