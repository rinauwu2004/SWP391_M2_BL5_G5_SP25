-- Create QuizAttempt table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuizAttempt]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[QuizAttempt](
        [id] [int] IDENTITY(1,1) NOT NULL,
        [studentId] [int] NOT NULL,
        [quizId] [int] NOT NULL,
        [startedTime] [datetime] NOT NULL,
        [submittedTime] [datetime] NULL,
        [score] [float] NULL,
        CONSTRAINT [PK_QuizAttempt] PRIMARY KEY CLUSTERED
        (
            [id] ASC
        ),
        CONSTRAINT [FK_QuizAttempt_User] FOREIGN KEY([studentId])
        REFERENCES [dbo].[User] ([id]),
        CONSTRAINT [FK_QuizAttempt_Quiz] FOREIGN KEY([quizId])
        REFERENCES [dbo].[Quiz] ([id])
    )
END
GO

-- Add some sample data for testing
INSERT INTO [dbo].[QuizAttempt] ([studentId], [quizId], [startedTime], [submittedTime], [score])
SELECT TOP 1 u.id, q.id, DATEADD(HOUR, -2, GETDATE()), DATEADD(HOUR, -1, GETDATE()), 0.85
FROM [dbo].[User] u
CROSS JOIN [dbo].[Quiz] q
WHERE u.role_id = (SELECT id FROM [dbo].[Role] WHERE name = 'student')
  AND NOT EXISTS (SELECT 1 FROM [dbo].[QuizAttempt] WHERE studentId = u.id AND quizId = q.id)

INSERT INTO [dbo].[QuizAttempt] ([studentId], [quizId], [startedTime], [submittedTime], [score])
SELECT TOP 1 u.id, q.id, DATEADD(HOUR, -3, GETDATE()), DATEADD(HOUR, -2, GETDATE()), 0.75
FROM [dbo].[User] u
CROSS JOIN [dbo].[Quiz] q
WHERE u.role_id = (SELECT id FROM [dbo].[Role] WHERE name = 'student')
  AND NOT EXISTS (SELECT 1 FROM [dbo].[QuizAttempt] WHERE studentId = u.id AND quizId = q.id)

INSERT INTO [dbo].[QuizAttempt] ([studentId], [quizId], [startedTime], [submittedTime], [score])
SELECT TOP 1 u.id, q.id, DATEADD(MINUTE, -30, GETDATE()), NULL, NULL
FROM [dbo].[User] u
CROSS JOIN [dbo].[Quiz] q
WHERE u.role_id = (SELECT id FROM [dbo].[Role] WHERE name = 'student')
  AND NOT EXISTS (SELECT 1 FROM [dbo].[QuizAttempt] WHERE studentId = u.id AND quizId = q.id)
GO
