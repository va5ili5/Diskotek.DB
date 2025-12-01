CREATE TABLE [dbo].[Users] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Username]    NVARCHAR (50)  NOT NULL,
    [Firstname]   NVARCHAR (100) NOT NULL,
    [Lastname]    NVARCHAR (100) NOT NULL,
    [Email]       NVARCHAR (100) NOT NULL,
    [CreatedAt]   DATETIME       DEFAULT (sysutcdatetime()) NOT NULL,
    [UpdatedAt]   DATETIME       NULL,
    [CreatedBy]   INT            NOT NULL,
    [UpdatedBy]   INT            NULL,
    [IsActive]    BIT            DEFAULT ((1)) NULL,
    [LastLoginAt] DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Email] ASC),
    UNIQUE NONCLUSTERED ([Username] ASC)
);

