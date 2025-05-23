<!--USE [master]
GO
/****** Object:  Database [testitel22]    Script Date: 4/29/2025 7:58:59 AM ******/
CREATE DATABASE [testitel22]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'testitel22', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\testitel22.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'testitel22_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\testitel22_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [testitel22] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [testitel22].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [testitel22] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [testitel22] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [testitel22] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [testitel22] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [testitel22] SET ARITHABORT OFF 
GO
ALTER DATABASE [testitel22] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [testitel22] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [testitel22] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [testitel22] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [testitel22] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [testitel22] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [testitel22] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [testitel22] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [testitel22] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [testitel22] SET  ENABLE_BROKER 
GO
ALTER DATABASE [testitel22] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [testitel22] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [testitel22] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [testitel22] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [testitel22] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [testitel22] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [testitel22] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [testitel22] SET RECOVERY FULL 
GO
ALTER DATABASE [testitel22] SET  MULTI_USER 
GO
ALTER DATABASE [testitel22] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [testitel22] SET DB_CHAINING OFF 
GO
ALTER DATABASE [testitel22] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [testitel22] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [testitel22] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [testitel22] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'testitel22', N'ON'
GO
ALTER DATABASE [testitel22] SET QUERY_STORE = ON
GO
ALTER DATABASE [testitel22] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [testitel22]
GO
/****** Object:  Table [dbo].[Account]    Script Date: 4/29/2025 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[AccountId] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NULL,
	[Password] [nvarchar](50) NULL,
	[FullName] [nvarchar](100) NULL,
	[Type] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 4/29/2025 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](100) NULL,
	[Description] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 4/29/2025 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [nvarchar](100) NULL,
	[Password] [nvarchar](50) NULL,
	[Address] [nvarchar](200) NULL,
	[Phone] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lesson]    Script Date: 4/29/2025 7:58:59 AM ******/
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
/****** Object:  Table [dbo].[Module]    Script Date: 4/29/2025 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Module](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) NOT NULL,
	[description] [text] NULL,
	[url] [varchar](255) NULL,
	[lesson_id] [int] NULL,
 CONSTRAINT [PK_Module] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order_Details]    Script Date: 4/29/2025 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order_Details](
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[UnitPrice] [decimal](10, 2) NULL,
	[Quantity] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 4/29/2025 7:58:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[OrderDate] [date] NULL,
	[RequiredDate] [date] NULL,
	[ShippedDate] [date] NULL,
	[Freight] [decimal](10, 2) NULL,
	[ShipAddress] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 4/29/2025 7:59:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](100) NULL,
	[SupplierId] [int] NULL,
	[CategoryId] [int] NULL,
	[QuantityPerUnit] [nvarchar](50) NULL,
	[UnitPrice] [decimal](10, 2) NULL,
	[ProductImage] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Question]    Script Date: 4/29/2025 7:59:00 AM ******/
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
/****** Object:  Table [dbo].[Quiz]    Script Date: 4/29/2025 7:59:00 AM ******/
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
/****** Object:  Table [dbo].[QuizQuestion]    Script Date: 4/29/2025 7:59:00 AM ******/
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
/****** Object:  Table [dbo].[QuizResult]    Script Date: 4/29/2025 7:59:00 AM ******/
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
/****** Object:  Table [dbo].[Role]    Script Date: 4/29/2025 7:59:00 AM ******/
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
/****** Object:  Table [dbo].[Subject]    Script Date: 4/29/2025 7:59:00 AM ******/
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
/****** Object:  Table [dbo].[Suppliers]    Script Date: 4/29/2025 7:59:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Suppliers](
	[SupplierId] [int] IDENTITY(1,1) NOT NULL,
	[SupplierName] [nvarchar](100) NULL,
	[Address] [nvarchar](200) NULL,
	[Phone] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[SupplierId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 4/29/2025 7:59:00 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email_address] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[phone_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAnswer]    Script Date: 4/29/2025 7:59:00 AM ******/
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
/****** Object:  Table [dbo].[UserRole]    Script Date: 4/29/2025 7:59:00 AM ******/
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
/****** Object:  Table [dbo].[UserStatus]    Script Date: 4/29/2025 7:59:00 AM ******/
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
/****** Object:  Table [dbo].[UserSubject]    Script Date: 4/29/2025 7:59:00 AM ******/
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
ALTER TABLE [dbo].[Module]  WITH CHECK ADD  CONSTRAINT [FK_Module_Lesson] FOREIGN KEY([lesson_id])
REFERENCES [dbo].[Lesson] ([id])
GO
ALTER TABLE [dbo].[Module] CHECK CONSTRAINT [FK_Module_Lesson]
GO
ALTER TABLE [dbo].[Order_Details]  WITH CHECK ADD FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([OrderId])
GO
ALTER TABLE [dbo].[Order_Details]  WITH CHECK ADD FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([CustomerId])
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([CategoryId])
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD FOREIGN KEY([SupplierId])
REFERENCES [dbo].[Suppliers] ([SupplierId])
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
GO
USE [master]
GO
ALTER DATABASE [testitel22] SET  READ_WRITE 
GO-->
