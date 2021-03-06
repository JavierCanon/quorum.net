USE [master]
GO
/****** Object:  Database [Quorum]    Script Date: 3/30/2020 8:32:01 PM ******/
CREATE DATABASE [Quorum]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Quorum', FILENAME = N'X:\GitHub\quorum.net\src\QuorumWeb\App_Data\Quorum.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Quorum_log', FILENAME = N'X:\GitHub\quorum.net\src\QuorumWeb\App_Data\Quorum_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Quorum] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Quorum].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Quorum] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Quorum] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Quorum] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Quorum] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Quorum] SET ARITHABORT OFF 
GO
ALTER DATABASE [Quorum] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Quorum] SET AUTO_SHRINK ON 
GO
ALTER DATABASE [Quorum] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Quorum] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Quorum] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Quorum] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Quorum] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Quorum] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Quorum] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Quorum] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Quorum] SET AUTO_UPDATE_STATISTICS_ASYNC ON 
GO
ALTER DATABASE [Quorum] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Quorum] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Quorum] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Quorum] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Quorum] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Quorum] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Quorum] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Quorum] SET  MULTI_USER 
GO
ALTER DATABASE [Quorum] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Quorum] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Quorum] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Quorum] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Quorum] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Quorum', N'ON'
GO
ALTER DATABASE [Quorum] SET QUERY_STORE = OFF
GO
USE [Quorum]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_RemoveCharacters]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	
/*

--> Alphabetic only:
SELECT dbo.fn_RemoveCharacters('a1!s2@d3#f4$', '^a-z')

---> Numeric only:
SELECT dbo.fn_RemoveCharacters('a1!s2@d3#f4$', '^0-9')

--> Alphanumeric only:
SELECT dbo.fn_RemoveCharacters('a1!s2@d3#f4$', '^a-z0-9')

--> Non-alphanumeric:
SELECT dbo.fn_RemoveCharacters('a1!s2@d3#f4$', 'a-z0-9')

*/
-- =============================================
CREATE FUNCTION [dbo].[fn_RemoveCharacters]
(
    @String NVARCHAR(MAX), 
    @MatchExpression VARCHAR(255)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    SET @MatchExpression =  '%['+@MatchExpression+']%'

    WHILE PatIndex(@MatchExpression, @String) > 0
        SET @String = Stuff(@String, PatIndex(@MatchExpression, @String), 1, '')

    RETURN @String

END


GO
/****** Object:  UserDefinedFunction [dbo].[fnCleanStringPlainText]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnCleanStringPlainText]
(
    -- Add the parameters for the function here
    @string NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
-- mapa:
-- http://www.danshort.com/ASCIImap/ 

    -- Return the result of the function
    RETURN 
    -- 
    RTRIM(LTRIM(REPLACE(
        REPLACE(
        REPLACE(
        REPLACE(
        REPLACE(
        REPLACE(
        REPLACE(
        REPLACE(
        REPLACE(
        REPLACE(
        RTRIM(LTRIM(@string))
        ,CHAR(13),'')
        ,CHAR(10),'')
        ,CHAR(160),'') --á
/*	,CHAR(193),'A') -- ┴
    ,CHAR(201),'E') -- ╔
    ,CHAR(205),'I') -- ═
    ,CHAR(203),'O') -- Ë --137 es con minuscula...
    ,CHAR(218),'U') -- ┌
    ,CHAR(208),'Ñ') -- Ð */
    ,CHAR(ASCII('┴')),'A') -- ┴
    ,CHAR(ASCII('╔')),'E') -- ╔
    ,CHAR(ASCII('═')),'I') -- ═
    ,CHAR(ASCII('Ë')),'O') -- Ë --137 es con minuscula...
    ,CHAR(ASCII('┌')),'U') -- ┌
    ,CHAR(ASCII('Ð')),'Ñ') -- Ð	
    ,N'├ì','I')
))	
    
-- SELECT ASCII('┴')

END



GO
/****** Object:  UserDefinedFunction [dbo].[fnFileNameRemoveExtension]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnFileNameRemoveExtension]
(
    -- Add the parameters for the function here
    @FileName NVARCHAR(256)
)
RETURNS NVARCHAR(256)
AS
BEGIN
    -- Declare the return variable here
    --DECLARE <@ResultVar, sysname, @Result> <Function_Data_Type, ,int>

    -- Add the T-SQL statements to compute the return value here
SELECT @FileName =
REVERSE(SUBSTRING(REVERSE(@FileName), 
CHARINDEX('.', REVERSE(@FileName)) + 1, 999))
;
    -- Return the result of the function
    RETURN @FileName;

END


GO
/****** Object:  UserDefinedFunction [dbo].[fnGetCountDaysInMonth]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetCountDaysInMonth] 
(
    -- Add the parameters for the function here
    @date DATE
)
RETURNS int
AS
BEGIN
    -- Declare the return variable here


    -- Return the result of the function
    RETURN datediff(day, dateadd(day, 1-day(@date), @date), dateadd(month, 1, dateadd(day, 1-day(@date), @date)))
    ;


END





GO
/****** Object:  UserDefinedFunction [dbo].[fnGetDatesFromDateRange]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetDatesFromDateRange]
(     
      @Increment              CHAR(1),
      @StartDate              DATE,
      @EndDate                DATE
)
RETURNS  
@SelectedRange    TABLE 
(IndividualDate DATE)
AS 
BEGIN
      ;WITH cteRange (DateRange) AS (
            SELECT @StartDate
            UNION ALL
            SELECT 
                  CASE
                        WHEN @Increment = 'd' THEN DATEADD(dd, 1, DateRange)
                        WHEN @Increment = 'w' THEN DATEADD(ww, 1, DateRange)
                        WHEN @Increment = 'm' THEN DATEADD(mm, 1, DateRange)
                  END
            FROM cteRange
            WHERE DateRange <= 
                  CASE
                        WHEN @Increment = 'd' THEN DATEADD(dd, -1, @EndDate)
                        WHEN @Increment = 'w' THEN DATEADD(ww, -1, @EndDate)
                        WHEN @Increment = 'm' THEN DATEADD(mm, -1, @EndDate)
                  END)
          
      INSERT INTO @SelectedRange (IndividualDate)
      SELECT DateRange
      FROM cteRange
      OPTION (MAXRECURSION 3660);
      RETURN
END


GO
/****** Object:  UserDefinedFunction [dbo].[fnGetDatesOfMonthCurrentYear]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetDatesOfMonthCurrentYear]
(
    -- Add the parameters for the function here
    @day DATE
)
RETURNS 
@Table_Var TABLE 
(
    -- Add the column definitions for the TABLE variable here
     DateOfMonth DATE
     ,DayOfMonth Int
    ,DayOfWeek Int
)
AS
BEGIN
    -- Fill the table variable with the rows for your result set
    DECLARE @month TINYINT
    SELECT	@month = MONTH(@day);

    WITH CTE_Days AS(
        SELECT 
        dateadd(month,@month-1,dateadd(year,datediff(year,0,getdate()),0)) D 
        UNION ALL
        SELECT 
        DATEADD(day, 1, D)FROM CTE_Days 
        WHERE D < dateadd(month,@month,dateadd(year,datediff(year,0,getdate()),0))-1
    )
    INSERT INTO @Table_Var
    SELECT 
      D
      ,DATEPART(DAY, D) 
     ,DATEPART(dw, D) 
    FROM CTE_Days
    ;

    RETURN 
END




GO
/****** Object:  UserDefinedFunction [dbo].[fnGetDatetimesFromDateRange]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetDatetimesFromDateRange]
(     
      @Increment              CHAR(1),
      @StartDate              DATETIME,
      @EndDate                DATETIME
)
RETURNS  
@SelectedRange    TABLE 
(IndividualDate DATETIME)
AS 
BEGIN
      ;WITH cteRange (DateRange) AS (
            SELECT @StartDate
            UNION ALL
            SELECT 
                  CASE
                        WHEN @Increment = 'd' THEN DATEADD(dd, 1, DateRange)
                        WHEN @Increment = 'w' THEN DATEADD(ww, 1, DateRange)
                        WHEN @Increment = 'm' THEN DATEADD(mm, 1, DateRange)
                  END
            FROM cteRange
            WHERE DateRange <= 
                  CASE
                        WHEN @Increment = 'd' THEN DATEADD(dd, -1, @EndDate)
                        WHEN @Increment = 'w' THEN DATEADD(ww, -1, @EndDate)
                        WHEN @Increment = 'm' THEN DATEADD(mm, -1, @EndDate)
                  END)
          
      INSERT INTO @SelectedRange (IndividualDate)
      SELECT DateRange
      FROM cteRange
      OPTION (MAXRECURSION 3660);
      RETURN
END



GO
/****** Object:  UserDefinedFunction [dbo].[fnGetDaysInMonth]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetDaysInMonth] 
(
    -- Add the parameters for the function here
    @date DATE
)
RETURNS int
AS
BEGIN
    -- Declare the return variable here


    -- Return the result of the function
    RETURN datediff(day, dateadd(day, 1-day(@date), @date), dateadd(month, 1, dateadd(day, 1-day(@date), @date)))
    ;


END



GO
/****** Object:  UserDefinedFunction [dbo].[fnGetFirstDayCurrentMonth]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetFirstDayCurrentMonth]
(
    -- Add the parameters for the function here
    @mydate DATE
)
RETURNS DATE
AS
BEGIN

    -- Return the result of the function
    RETURN DATEADD(dd,-(DAY(@mydate)-1), @mydate);

END




GO
/****** Object:  UserDefinedFunction [dbo].[fnGetFirstDayNextMonth]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetFirstDayNextMonth]
(
    -- Add the parameters for the function here
    @mydate DATE
)
RETURNS DATE
AS
BEGIN

    -- Return the result of the function
    RETURN DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))-1),DATEADD(mm,1,@mydate));

END




GO
/****** Object:  UserDefinedFunction [dbo].[fnGetFirstDayPreviousMonth]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetFirstDayPreviousMonth]
(
    -- Add the parameters for the function here
    @mydate DATE
)
RETURNS DATE
AS
BEGIN

    DECLARE @lastdaylm DATE;
    SET @lastdaylm = DATEADD(dd,-DAY(@mydate), @mydate);

    -- Return the result of the function
    RETURN DATEADD(dd,-DAY(@lastdaylm)+1, @lastdaylm);

END




GO
/****** Object:  UserDefinedFunction [dbo].[fnGetLastDayCurrentMonth]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetLastDayCurrentMonth]
(
    -- Add the parameters for the function here
    @mydate DATE
)
RETURNS DATE
AS
BEGIN

    -- Return the result of the function
    RETURN DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))),DATEADD(mm,1,@mydate));

END




GO
/****** Object:  UserDefinedFunction [dbo].[fnGetLastDayNextMonth]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetLastDayNextMonth]
(
    -- Add the parameters for the function here
    @mydate DATE
)
RETURNS DATE
AS
BEGIN

    DECLARE @lastdaynm DATE;
    SET @lastdaynm = DATEADD(month, 1, @mydate);

    -- Return the result of the function
    RETURN DATEADD(dd,-(DAY(DATEADD(mm,1,@lastdaynm))),DATEADD(mm,1,@lastdaynm));

END




GO
/****** Object:  UserDefinedFunction [dbo].[fnGetLastDayPreviousMonth]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetLastDayPreviousMonth]
(
    -- Add the parameters for the function here
    @mydate DATE
)
RETURNS DATE
AS
BEGIN

    -- Return the result of the function
    RETURN DATEADD(dd,-DAY(@mydate), @mydate);

END




GO
/****** Object:  UserDefinedFunction [dbo].[fnGetWeekDayFromMonday]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Javier Cañon
-- Create date: <Create Date, ,>
-- Description:	Return day of week without know of server SET DATEFIRST setting
-- =============================================
CREATE FUNCTION [dbo].[fnGetWeekDayFromMonday]
(
    -- Add the parameters for the function here
    @SomeDate DATE
)
RETURNS int
AS
BEGIN

DECLARE @SqlWeekDay INT, @ResultVar int;

    SET  @SqlWeekDay= DATEPART(dw, @SomeDate);
    SET @ResultVar = ((@SqlWeekDay + @@DATEFIRST - 1 - 1) % 7) + 1;


    -- Return the result of the function
    RETURN @ResultVar;

END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSettingGetValueById]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnSettingGetValueById] 
(
    -- Add the parameters for the function here
    @SettingId INT
)
RETURNS nvarchar(240)
AS
BEGIN
    -- Declare the return variable here
    DECLARE @ResultVar nvarchar(240);

    -- Add the T-SQL statements to compute the return value here
    SELECT @ResultVar = Value
    FROM 	dbo.Settings
    WHERE
    SettingId = @SettingId
    ;
    
    
    -- Return the result of the function
    RETURN @ResultVar;

END



GO
/****** Object:  UserDefinedFunction [dbo].[fnSettingGetValueByName]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create FUNCTION [dbo].[fnSettingGetValueByName] 
(
    -- Add the parameters for the function here
    @Name nvarchar(60)
)
RETURNS nvarchar(240)
AS
BEGIN
    -- Declare the return variable here
    DECLARE @ResultVar nvarchar(240);

    -- Add the T-SQL statements to compute the return value here
    SELECT @ResultVar = Value
    FROM 	dbo.Settings
    WHERE
    Name = @Name
    ;
    
    
    -- Return the result of the function
    RETURN @ResultVar;

END


GO
/****** Object:  Table [dbo].[Attendees]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attendees](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [OrganizationsID] [int] NOT NULL,
    [VotersID] [int] NOT NULL,
    [VoterCategoryID] [int] NOT NULL,
    [DateIn] [datetime] NULL,
    [GUID] [uniqueidentifier] ROWGUIDCOL  NULL,
    [VoteCode]  AS (CONVERT([varchar](10),[ID])+CONVERT([nvarchar](10),abs(checksum([GUID])))) PERSISTED,
 CONSTRAINT [PK_Attendees] PRIMARY KEY CLUSTERED 
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Attendees_VoteCode] UNIQUE NONCLUSTERED 
(
    [VoteCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AttendeesAnswers]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttendeesAnswers](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [QuestionsID] [int] NOT NULL,
    [AnswersID] [int] NOT NULL,
    [AttendeesID] [int] NOT NULL,
    [DateAnswered] [datetime] NULL,
 CONSTRAINT [PK_AttendeesAnswers] PRIMARY KEY CLUSTERED 
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_AttendeesAnswers_Unique] UNIQUE NONCLUSTERED 
(
    [QuestionsID] ASC,
    [AnswersID] ASC,
    [AttendeesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Organizations]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organizations](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](60) NOT NULL,
    [Identification] [nvarchar](20) NOT NULL,
    [Shareholding] [numeric](18, 9) NOT NULL,
 CONSTRAINT [PK_Organization] PRIMARY KEY CLUSTERED 
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Questions]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questions](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Question] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_Questions] PRIMARY KEY CLUSTERED 
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionsAnswers]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionsAnswers](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [QuestionsID] [int] NOT NULL,
    [Answer] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_QuestionsAnswers] PRIMARY KEY CLUSTERED 
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Settings]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Settings](
    [Setting_ID] [int] NOT NULL,
    [Name] [nvarchar](60) NOT NULL,
    [Value] [nvarchar](240) NOT NULL,
    [DataType] [nchar](1) NOT NULL,
    [DisplayName] [nvarchar](60) NOT NULL,
    [DisplayOrder] [int] NOT NULL,
    [Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
    [Setting_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Settings_Name] UNIQUE NONCLUSTERED 
(
    [Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
    [UserId] [int] IDENTITY(1,1) NOT NULL,
    [UserLogin] [nvarchar](128) NOT NULL,
    [UserPass] [nvarchar](255) NOT NULL,
    [UserEmail] [nvarchar](128) NULL,
    [UserFirstName] [nvarchar](60) NULL,
    [UserLastName] [nvarchar](60) NULL,
    [UserRolId] [int] NULL,
    [UserRolName] [nvarchar](60) NULL,
    [UserRolDisplayName] [nvarchar](60) NULL,
    [DisplayName] [nvarchar](60) NOT NULL,
    [UserActive] [bit] NOT NULL,
    [UserBanned] [bit] NOT NULL,
    [UserLastLogin] [datetime] NULL,
    [UserCreatedIn] [datetime] NULL,
    [UserUpdatedIn] [datetime] NULL,
    [UserCreatedByUserId] [int] NULL,
    [UserUpdatedByUserId] [int] NULL,
    [RowGuid] [uniqueidentifier] NOT NULL,
    [Photo] [varbinary](max) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
    [UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_User] UNIQUE NONCLUSTERED 
(
    [UserLogin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User_Log]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_Log](
    [ID] [bigint] IDENTITY(1,1) NOT NULL,
    [Date] [datetime] NOT NULL,
    [Thread] [nvarchar](255) NULL,
    [Level] [nvarchar](60) NULL,
    [Logger] [nvarchar](255) NULL,
    [Message] [nvarchar](max) NULL,
    [Exception] [nvarchar](max) NULL,
    [Category] [nvarchar](60) NULL,
    [User_ID] [int] NULL,
    [Rol_ID] [int] NULL,
    [Ip] [nvarchar](50) NULL,
    [Url] [nvarchar](255) NULL,
    [UserAgent] [nvarchar](255) NULL,
 CONSTRAINT [PK_User_Log] PRIMARY KEY CLUSTERED 
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserPermission]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPermission](
    [UserPerId] [int] IDENTITY(1,1) NOT NULL,
    [UserId] [int] NOT NULL,
    [UserPerTypeId] [int] NOT NULL,
    [UserPermission] [bit] NOT NULL,
 CONSTRAINT [PK_UserPermission] PRIMARY KEY CLUSTERED 
(
    [UserPerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserPermissionCategory]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPermissionCategory](
    [UserPerCatId] [int] NOT NULL,
    [UserPerCatName] [nvarchar](60) NOT NULL,
    [DisplayName] [nvarchar](60) NOT NULL,
    [UserPerCatDescription] [nvarchar](1000) NULL,
    [DisplayOrder] [int] NOT NULL,
    [DisplayActive] [bit] NOT NULL,
 CONSTRAINT [PK_UserPermissionCategory] PRIMARY KEY CLUSTERED 
(
    [UserPerCatId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_UserPermissionCategory_UserPerCatName] UNIQUE NONCLUSTERED 
(
    [UserPerCatName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserPermissionType]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPermissionType](
    [UserPerTypeId] [int] NOT NULL,
    [UserPerTypeName] [nvarchar](50) NOT NULL,
    [UserPerCatName] [nvarchar](60) NOT NULL,
    [DisplayName]  AS ([UserPerTypeName]) PERSISTED NOT NULL,
    [UserPerTypeDescription] [nvarchar](1000) NULL,
    [EnumName]  AS (replace(([UserPerCatName]+'_')+[UserPerTypeName],' ','_')) PERSISTED,
    [DisplayOrder] [int] NOT NULL,
    [DisplayActive] [bit] NOT NULL,
 CONSTRAINT [PK_UserPermissionType] PRIMARY KEY CLUSTERED 
(
    [UserPerTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_UserPermissionType_CatName_TypeName] UNIQUE NONCLUSTERED 
(
    [UserPerCatName] ASC,
    [UserPerTypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRol]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRol](
    [UserRolId] [int] NOT NULL,
    [UserRolName] [nvarchar](60) NOT NULL,
    [DisplayName] [nvarchar](60) NOT NULL,
    [DisplayOrder] [int] NOT NULL,
    [DisplayActive] [bit] NOT NULL,
    [SystemRol] [bit] NOT NULL,
 CONSTRAINT [PK_usuariosRoles] PRIMARY KEY CLUSTERED 
(
    [UserRolId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_UserRol_DisplayName] UNIQUE NONCLUSTERED 
(
    [DisplayName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_UserRol_UserRolName] UNIQUE NONCLUSTERED 
(
    [UserRolName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRolPermission]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRolPermission](
    [UserRolPerId] [int] IDENTITY(1,1) NOT NULL,
    [UserRolId] [int] NOT NULL,
    [UserPerTypeId] [int] NOT NULL,
    [UserRolPermission] [bit] NOT NULL,
 CONSTRAINT [PK_UserRolPermission] PRIMARY KEY CLUSTERED 
(
    [UserRolPerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSetting]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserSetting](
    [UserSettingId] [int] NOT NULL,
    [Name] [nvarchar](60) NOT NULL,
    [DataType] [nchar](1) NOT NULL,
    [DisplayName] [nvarchar](60) NOT NULL,
    [DisplayOrder] [int] NOT NULL,
    [Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_UserSetting] PRIMARY KEY CLUSTERED 
(
    [UserSettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_UserSetting_Name] UNIQUE NONCLUSTERED 
(
    [Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSettings]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserSettings](
    [UserSettingsId] [int] IDENTITY(1,1) NOT NULL,
    [UserId] [int] NOT NULL,
    [Name] [nvarchar](60) NOT NULL,
    [Value] [nvarchar](240) NOT NULL,
 CONSTRAINT [PK_UserSettings] PRIMARY KEY CLUSTERED 
(
    [UserSettingsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_UserSettings_UserId_Name] UNIQUE NONCLUSTERED 
(
    [UserId] ASC,
    [Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VoterCategory]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VoterCategory](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Category] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_VoterCategory] PRIMARY KEY CLUSTERED 
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_VoterCategory_Category] UNIQUE NONCLUSTERED 
(
    [Category] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Voters]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Voters](
    [ID] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](60) NOT NULL,
    [Identification] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Voters] PRIMARY KEY CLUSTERED 
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attendees] ADD  CONSTRAINT [DF_Attendees_DateIn]  DEFAULT (getdate()) FOR [DateIn]
GO
ALTER TABLE [dbo].[Attendees] ADD  CONSTRAINT [DF_Attendees_GUID]  DEFAULT (newid()) FOR [GUID]
GO
ALTER TABLE [dbo].[AttendeesAnswers] ADD  CONSTRAINT [DF_AttendeesAnswers_DateAnswered]  DEFAULT (getdate()) FOR [DateAnswered]
GO
ALTER TABLE [dbo].[Organizations] ADD  CONSTRAINT [DF_Organization_Shareholding]  DEFAULT ((0)) FOR [Shareholding]
GO
ALTER TABLE [dbo].[Settings] ADD  CONSTRAINT [DF_Settings_DataType]  DEFAULT (N'S') FOR [DataType]
GO
ALTER TABLE [dbo].[Settings] ADD  CONSTRAINT [DF_Settings_DisplayOrder]  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF__User__UserActive__24BEF13F]  DEFAULT ((1)) FOR [UserActive]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF__User__UserBanned__25B31578]  DEFAULT ((0)) FOR [UserBanned]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_UserCreatedIn]  DEFAULT (getdate()) FOR [UserCreatedIn]
GO
ALTER TABLE [dbo].[User] ADD  DEFAULT (newid()) FOR [RowGuid]
GO
ALTER TABLE [dbo].[UserPermissionCategory] ADD  CONSTRAINT [DF_UserPermissionCategory_DisplayOrder]  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[UserPermissionCategory] ADD  CONSTRAINT [DF_UserPermissionCategory_Active]  DEFAULT ((1)) FOR [DisplayActive]
GO
ALTER TABLE [dbo].[UserPermissionType] ADD  CONSTRAINT [DF_UserPermissionType_DisplayOrder]  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[UserPermissionType] ADD  CONSTRAINT [DF_UserPermissionType_Active]  DEFAULT ((1)) FOR [DisplayActive]
GO
ALTER TABLE [dbo].[UserRol] ADD  CONSTRAINT [DF_UserRol_DisplayOrder]  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[UserRol] ADD  CONSTRAINT [DF_UserRol_Active]  DEFAULT ((1)) FOR [DisplayActive]
GO
ALTER TABLE [dbo].[UserRol] ADD  CONSTRAINT [DF_UserRol_SystemRol]  DEFAULT ((0)) FOR [SystemRol]
GO
ALTER TABLE [dbo].[UserSetting] ADD  CONSTRAINT [DF_UserSetting_DataType]  DEFAULT (N'S') FOR [DataType]
GO
ALTER TABLE [dbo].[UserSetting] ADD  CONSTRAINT [DF_UserSetting_DisplayOrder]  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[QuestionsAnswers]  WITH CHECK ADD  CONSTRAINT [FK_QuestionsAnswers_Questions] FOREIGN KEY([QuestionsID])
REFERENCES [dbo].[Questions] ([ID])
GO
ALTER TABLE [dbo].[QuestionsAnswers] CHECK CONSTRAINT [FK_QuestionsAnswers_Questions]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_UserRol] FOREIGN KEY([UserRolId])
REFERENCES [dbo].[UserRol] ([UserRolId])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_UserRol]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_UserRol1] FOREIGN KEY([UserRolName])
REFERENCES [dbo].[UserRol] ([UserRolName])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_UserRol1]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_UserRol2] FOREIGN KEY([UserRolDisplayName])
REFERENCES [dbo].[UserRol] ([DisplayName])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_UserRol2]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_UserRol3] FOREIGN KEY([UserRolName])
REFERENCES [dbo].[UserRol] ([UserRolName])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_UserRol3]
GO
ALTER TABLE [dbo].[UserPermission]  WITH CHECK ADD  CONSTRAINT [FK_UserPermission_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserPermission] CHECK CONSTRAINT [FK_UserPermission_User]
GO
ALTER TABLE [dbo].[UserPermission]  WITH CHECK ADD  CONSTRAINT [FK_UserPermission_UserPermissionType] FOREIGN KEY([UserPerTypeId])
REFERENCES [dbo].[UserPermissionType] ([UserPerTypeId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserPermission] CHECK CONSTRAINT [FK_UserPermission_UserPermissionType]
GO
ALTER TABLE [dbo].[UserPermissionType]  WITH CHECK ADD  CONSTRAINT [FK_UserPermissionType_UserPermissionCategory] FOREIGN KEY([UserPerCatName])
REFERENCES [dbo].[UserPermissionCategory] ([UserPerCatName])
GO
ALTER TABLE [dbo].[UserPermissionType] CHECK CONSTRAINT [FK_UserPermissionType_UserPermissionCategory]
GO
ALTER TABLE [dbo].[UserRolPermission]  WITH CHECK ADD  CONSTRAINT [FK_UserRolPermission_UserPermissionType] FOREIGN KEY([UserPerTypeId])
REFERENCES [dbo].[UserPermissionType] ([UserPerTypeId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserRolPermission] CHECK CONSTRAINT [FK_UserRolPermission_UserPermissionType]
GO
ALTER TABLE [dbo].[UserRolPermission]  WITH CHECK ADD  CONSTRAINT [FK_UserRolPermission_UserRol] FOREIGN KEY([UserRolId])
REFERENCES [dbo].[UserRol] ([UserRolId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserRolPermission] CHECK CONSTRAINT [FK_UserRolPermission_UserRol]
GO
/****** Object:  StoredProcedure [dbo].[Export_XML_Query]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Export_XML_Query]
    -- Add the parameters for the stored procedure here
     @query varchar(7000)
    ,@fileAndPath varchar(100)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
declare @tsql varchar(8000);

select @tsql = 'bcp "' + @query + ' FOR XML RAW, ROOT;" queryout  "' + @fileAndPath + '" -x -c -T -S'+ @@servername;

exec master..xp_cmdshell @tsql;

END


GO
/****** Object:  StoredProcedure [dbo].[GenerateRowNumbers]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GenerateRowNumbers](@NumberOfRows int, @StartNumber int)
As Begin
    Declare @NumGen Table (Num int)
    Declare @cnt int
    Set @cnt = 1

    While @cnt <= 100 Begin
        Insert Into @NumGen 
        Select @cnt
        Set @cnt = @cnt + 1
    End

    Select @StartNumber + RowNum
    From 
    (
        Select Row_Number() Over (Order By N1.Num) As RowNum
        From @NumGen N1, @NumGen N2, @NumGen N3, @NumGen N4
    ) RowNums
    Where RowNum <= @NumberOfRows

End
 
GO
/****** Object:  StoredProcedure [dbo].[Roles_Search]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Roles_Search] 
    -- Add the parameters for the stored procedure here
@Search nvarchar(200)

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT UserRolId
      ,UserRolName
      ,DisplayName
      ,DisplayOrder
      ,DisplayActive
  FROM [dbo].[UserRol]
WHERE
(
UserRolName LIKE '%' + @Search
OR
DisplayName LIKE '%' + @Search
)
AND
DisplayActive = 1
ORDER BY DisplayOrder, UserRolName
;



END



GO
/****** Object:  StoredProcedure [dbo].[Settings_Get_by_ID]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Settings_Get_by_ID]
    -- Add the parameters for the stored procedure here
    @SettingId INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT 
    *
    FROM [dbo].[Settings]
    WHERE
     Setting_Id = @SettingId
    
    
END



GO
/****** Object:  StoredProcedure [dbo].[Settings_Get_by_Name]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Settings_Get_by_Name]
    -- Add the parameters for the stored procedure here
    @Name NVARCHAR(60)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT 
    *
    FROM [dbo].[Settings]
    WHERE
     [Name]= @Name


END



GO
/****** Object:  StoredProcedure [dbo].[Settings_Get_Value_by_ID]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Settings_Get_Value_by_ID]
    -- Add the parameters for the stored procedure here
    @SettingId INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT 
        [Value]
       ,[DataType]
    FROM [dbo].[Settings]
    WHERE
    [Setting_Id] = @SettingId

    
END



GO
/****** Object:  StoredProcedure [dbo].[Settings_Get_Value_by_Name]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Settings_Get_Value_by_Name]
    -- Add the parameters for the stored procedure here
    @Name NVARCHAR(60)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT 
        [Value]
       ,[DataType]
    FROM [dbo].[Settings]
    WHERE
    [Name] = @Name
    
    
END



GO
/****** Object:  StoredProcedure [dbo].[Settings_Update_Value]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	
-- Create new settings if no exists create new one with default values if no params exists.
-- =============================================
CREATE PROCEDURE [dbo].[Settings_Update_Value]
    -- Add the parameters for the stored procedure here
     @Name nvarchar(60) 
    ,@Value nvarchar(240) 
    ,@DataType nchar(1) = 'S'
    ,@DisplayName nvarchar(60) = NULL
    ,@DisplayOrder int = NULL
    ,@Description nvarchar(max) = NULL

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

IF(@DisplayName IS NULL) SET @DisplayName = @Name;
IF(@DisplayOrder IS NULL) SET @DisplayOrder = 0;
IF(@Description IS NULL) SET @Description = @Name;

    -- Insert statements for procedure here
IF(SELECT COUNT(*) FROM dbo.Settings WHERE Name = @Name) = 0
BEGIN -- INSERT IN SETTING TABLE IF NO EXISTS.

    INSERT INTO [dbo].[Settings]
            (
              [Setting_Id]
            ,[Name]
            ,[Value]
            ,[DataType]
            ,[DisplayName]
            ,[DisplayOrder]
            ,[Description])
    SELECT
            (SELECT ISNULL(MAX(Setting_Id), 0)+ 1 FROM [Settings] ) -- UserSettingId, int,>
            ,@Name --, nvarchar(60),>
            ,@Value --nvarchar(240) 
            ,@DataType --, nchar(1),>
            ,@DisplayName --, nvarchar(60),>
            ,@DisplayOrder --, int,>
            ,@Description --, nvarchar(max),>
    ;
END
ELSE
BEGIN

    UPDATE [dbo].[Settings] SET
       Value = @Value
    WHERE
    [Name] = @Name
    ;


END
;





END


GO
/****** Object:  StoredProcedure [dbo].[Table_Generate_Inserts]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROC [dbo].[Table_Generate_Inserts]
(
    @table_name varchar(776),  		-- The table/view for which the INSERT statements will be generated using the existing data
    @target_table varchar(776) = NULL, 	-- Use this parameter to specify a different table name into which the data will be inserted
    @include_column_list bit = 1,		-- Use this parameter to include/ommit column list in the generated INSERT statement
    @from varchar(800) = NULL, 		-- Use this parameter to filter the rows based on a filter condition (using WHERE)
    @include_timestamp bit = 0, 		-- Specify 1 for this parameter, if you want to include the TIMESTAMP/ROWVERSION column's data in the INSERT statement
    @debug_mode bit = 0,			-- If @debug_mode is set to 1, the SQL statements constructed by this procedure will be printed for later examination
    @owner varchar(64) = NULL,		-- Use this parameter if you are not the owner of the table
    @ommit_images bit = 0,			-- Use this parameter to generate INSERT statements by omitting the 'image' columns
    @ommit_identity bit = 0,		-- Use this parameter to ommit the identity columns
    @top int = NULL,			-- Use this parameter to generate INSERT statements only for the TOP n rows
    @cols_to_include varchar(max) = NULL,	-- List of columns to be included in the INSERT statement
    @cols_to_exclude varchar(max) = NULL,	-- List of columns to be excluded from the INSERT statement
    @disable_constraints bit = 0,		-- When 1, disables foreign key constraints and enables them after the INSERT statements
    @ommit_computed_cols bit = 0		-- When 1, computed columns will not be included in the INSERT statement
    
)
AS
BEGIN

/***********************************************************************************************************
Procedure:	sp_generate_inserts  (Build 22) 
        (Copyright © 2002 Narayana Vyas Kondreddi. All rights reserved.)
                                          
Purpose:	To generate INSERT statements from existing data. 
        These INSERTS can be executed to regenerate the data at some other location.
        This procedure is also useful to create a database setup, where in you can 
        script your data along with your table definitions.

Written by:	Narayana Vyas Kondreddi
            http://vyaskn.tripod.com

Acknowledgements:
        Divya Kalra	-- For beta testing
        Mark Charsley	-- For reporting a problem with scripting uniqueidentifier columns with NULL values
        Artur Zeygman	-- For helping me simplify a bit of code for handling non-dbo owned tables
        Joris Laperre   -- For reporting a regression bug in handling text/ntext columns

Tested on: 	SQL Server 7.0 and SQL Server 2000 and SQL Server 2005

Date created:	January 17th 2001 21:52 GMT

Date modified:	May 1st 2002 19:50 GMT

Email: 		vyaskn@hotmail.com

NOTE:		This procedure may not work with tables with too many columns.
        Results can be unpredictable with huge text columns or SQL Server 2000's sql_variant data types
        Whenever possible, Use @include_column_list parameter to ommit column list in the INSERT statement, for better results
        IMPORTANT: This procedure is not tested with internation data (Extended characters or Unicode). If needed
        you might want to convert the datatypes of character variables in this procedure to their respective unicode counterparts
        like nchar and nvarchar

        ALSO NOTE THAT THIS PROCEDURE IS NOT UPDATED TO WORK WITH NEW DATA TYPES INTRODUCED IN SQL SERVER 2005 / YUKON
        

Example 1:	To generate INSERT statements for table 'titles':
        
        EXEC sp_generate_inserts 'titles'

Example 2: 	To ommit the column list in the INSERT statement: (Column list is included by default)
        IMPORTANT: If you have too many columns, you are advised to ommit column list, as shown below,
        to avoid erroneous results
        
        EXEC sp_generate_inserts 'titles', @include_column_list = 0

Example 3:	To generate INSERT statements for 'titlesCopy' table from 'titles' table:

        EXEC sp_generate_inserts 'titles', 'titlesCopy'

Example 4:	To generate INSERT statements for 'titles' table for only those titles 
        which contain the word 'Computer' in them:
        NOTE: Do not complicate the FROM or WHERE clause here. It's assumed that you are good with T-SQL if you are using this parameter

        EXEC sp_generate_inserts 'titles', @from = "from titles where title like '%Computer%'"

Example 5: 	To specify that you want to include TIMESTAMP column's data as well in the INSERT statement:
        (By default TIMESTAMP column's data is not scripted)

        EXEC sp_generate_inserts 'titles', @include_timestamp = 1

Example 6:	To print the debug information:
  
        EXEC sp_generate_inserts 'titles', @debug_mode = 1

Example 7: 	If you are not the owner of the table, use @owner parameter to specify the owner name
        To use this option, you must have SELECT permissions on that table

        EXEC sp_generate_inserts Nickstable, @owner = 'Nick'

Example 8: 	To generate INSERT statements for the rest of the columns excluding images
        When using this otion, DO NOT set @include_column_list parameter to 0.

        EXEC sp_generate_inserts imgtable, @ommit_images = 1

Example 9: 	To generate INSERT statements excluding (ommiting) IDENTITY columns:
        (By default IDENTITY columns are included in the INSERT statement)

        EXEC sp_generate_inserts mytable, @ommit_identity = 1

Example 10: 	To generate INSERT statements for the TOP 10 rows in the table:
        
        EXEC sp_generate_inserts mytable, @top = 10

Example 11: 	To generate INSERT statements with only those columns you want:
        
        EXEC sp_generate_inserts titles, @cols_to_include = "'title','title_id','au_id'"

Example 12: 	To generate INSERT statements by omitting certain columns:
        
        EXEC sp_generate_inserts titles, @cols_to_exclude = "'title','title_id','au_id'"

Example 13:	To avoid checking the foreign key constraints while loading data with INSERT statements:
        
        EXEC sp_generate_inserts titles, @disable_constraints = 1

Example 14: 	To exclude computed columns from the INSERT statement:
        EXEC sp_generate_inserts MyTable, @ommit_computed_cols = 1
***********************************************************************************************************/

SET NOCOUNT ON

--Making sure user only uses either @cols_to_include or @cols_to_exclude
IF ((@cols_to_include IS NOT NULL) AND (@cols_to_exclude IS NOT NULL))
    BEGIN
        RAISERROR('Use either @cols_to_include or @cols_to_exclude. Do not use both the parameters at once',16,1)
        RETURN -1 --Failure. Reason: Both @cols_to_include and @cols_to_exclude parameters are specified
    END

--Making sure the @cols_to_include and @cols_to_exclude parameters are receiving values in proper format
IF ((@cols_to_include IS NOT NULL) AND (PATINDEX('''%''',@cols_to_include) = 0))
    BEGIN
        RAISERROR('Invalid use of @cols_to_include property',16,1)
        PRINT 'Specify column names surrounded by single quotes and separated by commas'
        PRINT 'Eg: EXEC sp_generate_inserts titles, @cols_to_include = "''title_id'',''title''"'
        RETURN -1 --Failure. Reason: Invalid use of @cols_to_include property
    END

IF ((@cols_to_exclude IS NOT NULL) AND (PATINDEX('''%''',@cols_to_exclude) = 0))
    BEGIN
        RAISERROR('Invalid use of @cols_to_exclude property',16,1)
        PRINT 'Specify column names surrounded by single quotes and separated by commas'
        PRINT 'Eg: EXEC sp_generate_inserts titles, @cols_to_exclude = "''title_id'',''title''"'
        RETURN -1 --Failure. Reason: Invalid use of @cols_to_exclude property
    END


--Checking to see if the database name is specified along wih the table name
--Your database context should be local to the table for which you want to generate INSERT statements
--specifying the database name is not allowed
IF (PARSENAME(@table_name,3)) IS NOT NULL
    BEGIN
        RAISERROR('Do not specify the database name. Be in the required database and just specify the table name.',16,1)
        RETURN -1 --Failure. Reason: Database name is specified along with the table name, which is not allowed
    END

--Checking for the existence of 'user table' or 'view'
--This procedure is not written to work on system tables
--To script the data in system tables, just create a view on the system tables and script the view instead

IF @owner IS NULL
    BEGIN
        IF ((OBJECT_ID(@table_name,'U') IS NULL) AND (OBJECT_ID(@table_name,'V') IS NULL)) 
            BEGIN
                RAISERROR('User table or view not found.',16,1)
                PRINT 'You may see this error, if you are not the owner of this table or view. In that case use @owner parameter to specify the owner name.'
                PRINT 'Make sure you have SELECT permission on that table or view.'
                RETURN -1 --Failure. Reason: There is no user table or view with this name
            END
    END
ELSE
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @table_name AND (TABLE_TYPE = 'BASE TABLE' OR TABLE_TYPE = 'VIEW') AND TABLE_SCHEMA = @owner)
            BEGIN
                RAISERROR('User table or view not found.',16,1)
                PRINT 'You may see this error, if you are not the owner of this table. In that case use @owner parameter to specify the owner name.'
                PRINT 'Make sure you have SELECT permission on that table or view.'
                RETURN -1 --Failure. Reason: There is no user table or view with this name		
            END
    END

--Variable declarations
DECLARE	@Column_ID int, 		
        @Column_List varchar(max), 
        @Column_Name varchar(128), 
        @Start_Insert varchar(786), 
        @Data_Type varchar(128), 
        @Actual_Values varchar(max),	--This is the string that will be finally executed to generate INSERT statements
        @IDN varchar(128)		--Will contain the IDENTITY column's name in the table

--Variable Initialization
SET @IDN = ''
SET @Column_ID = 0
SET @Column_Name = ''
SET @Column_List = ''
SET @Actual_Values = ''

IF @owner IS NULL 
    BEGIN
        SET @Start_Insert = 'INSERT INTO ' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']' 
    END
ELSE
    BEGIN
        SET @Start_Insert = 'INSERT ' + '[' + LTRIM(RTRIM(@owner)) + '].' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']' 		
    END


--To get the first column's ID

SELECT	@Column_ID = MIN(ORDINAL_POSITION) 	
FROM	INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
WHERE 	TABLE_NAME = @table_name AND
(@owner IS NULL OR TABLE_SCHEMA = @owner)



--Loop through all the columns of the table, to get the column names and their data types
WHILE @Column_ID IS NOT NULL
    BEGIN
        SELECT 	@Column_Name = QUOTENAME(COLUMN_NAME), 
        @Data_Type = DATA_TYPE 
        FROM 	INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
        WHERE 	ORDINAL_POSITION = @Column_ID AND 
        TABLE_NAME = @table_name AND
        (@owner IS NULL OR TABLE_SCHEMA = @owner)



        IF @cols_to_include IS NOT NULL --Selecting only user specified columns
        BEGIN
            IF CHARINDEX( '''' + SUBSTRING(@Column_Name,2,LEN(@Column_Name)-2) + '''',@cols_to_include) = 0 
            BEGIN
                GOTO SKIP_LOOP
            END
        END

        IF @cols_to_exclude IS NOT NULL --Selecting only user specified columns
        BEGIN
            IF CHARINDEX( '''' + SUBSTRING(@Column_Name,2,LEN(@Column_Name)-2) + '''',@cols_to_exclude) <> 0 
            BEGIN
                GOTO SKIP_LOOP
            END
        END

        --Making sure to output SET IDENTITY_INSERT ON/OFF in case the table has an IDENTITY column
        IF (SELECT COLUMNPROPERTY( OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name),SUBSTRING(@Column_Name,2,LEN(@Column_Name) - 2),'IsIdentity')) = 1 
        BEGIN
            IF @ommit_identity = 0 --Determing whether to include or exclude the IDENTITY column
                SET @IDN = @Column_Name
            ELSE
                GOTO SKIP_LOOP			
        END
        
        --Making sure whether to output computed columns or not
        IF @ommit_computed_cols = 1
        BEGIN
            IF (SELECT COLUMNPROPERTY( OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name),SUBSTRING(@Column_Name,2,LEN(@Column_Name) - 2),'IsComputed')) = 1 
            BEGIN
                GOTO SKIP_LOOP					
            END
        END
        
        --Tables with columns of IMAGE data type are not supported for obvious reasons
        IF(@Data_Type in ('image'))
            BEGIN
                IF (@ommit_images = 0)
                    BEGIN
                        RAISERROR('Tables with image columns are not supported.',16,1)
                        PRINT 'Use @ommit_images = 1 parameter to generate INSERTs for the rest of the columns.'
                        PRINT 'DO NOT ommit Column List in the INSERT statements. If you ommit column list using @include_column_list=0, the generated INSERTs will fail.'
                        RETURN -1 --Failure. Reason: There is a column with image data type
                    END
                ELSE
                    BEGIN
                    GOTO SKIP_LOOP
                    END
            END

        --Determining the data type of the column and depending on the data type, the VALUES part of
        --the INSERT statement is generated. Care is taken to handle columns with NULL values. Also
        --making sure, not to lose any data from flot, real, money, smallmomey, datetime columns
        SET @Actual_Values = @Actual_Values  +
        CASE 
            WHEN @Data_Type IN ('char','varchar','nchar','nvarchar') 
                THEN 
                    'COALESCE('''''''' + REPLACE(RTRIM(' + @Column_Name + '),'''''''','''''''''''')+'''''''',''NULL'')'
            WHEN @Data_Type IN ('datetime','smalldatetime') 
                THEN 
                    'COALESCE('''''''' + RTRIM(CONVERT(char,' + @Column_Name + ',109))+'''''''',''NULL'')'
            WHEN @Data_Type IN ('uniqueidentifier') 
                THEN  
                    'COALESCE('''''''' + REPLACE(CONVERT(char(255),RTRIM(' + @Column_Name + ')),'''''''','''''''''''')+'''''''',''NULL'')'
            WHEN @Data_Type IN ('text','ntext') 
                THEN  
                    'COALESCE('''''''' + REPLACE(CONVERT(char(8000),' + @Column_Name + '),'''''''','''''''''''')+'''''''',''NULL'')'					
            WHEN @Data_Type IN ('binary','varbinary') 
                THEN  
                    'COALESCE(RTRIM(CONVERT(char,' + 'CONVERT(int,' + @Column_Name + '))),''NULL'')'  
            WHEN @Data_Type IN ('timestamp','rowversion') 
                THEN  
                    CASE 
                        WHEN @include_timestamp = 0 
                            THEN 
                                '''DEFAULT''' 
                            ELSE 
                                'COALESCE(RTRIM(CONVERT(char,' + 'CONVERT(int,' + @Column_Name + '))),''NULL'')'  
                    END
            WHEN @Data_Type IN ('float','real','money','smallmoney')
                THEN
                    'COALESCE(LTRIM(RTRIM(' + 'CONVERT(char, ' +  @Column_Name  + ',2)' + ')),''NULL'')' 
            ELSE 
                'COALESCE(LTRIM(RTRIM(' + 'CONVERT(char, ' +  @Column_Name  + ')' + ')),''NULL'')' 
        END   + '+' +  ''',''' + ' + '
        
        --Generating the column list for the INSERT statement
        SET @Column_List = @Column_List +  @Column_Name + ','	

        SKIP_LOOP: --The label used in GOTO

        SELECT 	@Column_ID = MIN(ORDINAL_POSITION) 
        FROM 	INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
        WHERE 	TABLE_NAME = @table_name AND 
        ORDINAL_POSITION > @Column_ID AND
        (@owner IS NULL OR TABLE_SCHEMA = @owner)


    --Loop ends here!
    END

--To get rid of the extra characters that got concatenated during the last run through the loop
SET @Column_List = LEFT(@Column_List,len(@Column_List) - 1)
SET @Actual_Values = LEFT(@Actual_Values,len(@Actual_Values) - 6)

IF LTRIM(@Column_List) = '' 
    BEGIN
        RAISERROR('No columns to select. There should at least be one column to generate the output',16,1)
        RETURN -1 --Failure. Reason: Looks like all the columns are ommitted using the @cols_to_exclude parameter
    END

--Forming the final string that will be executed, to output the INSERT statements
IF (@include_column_list <> 0)
    BEGIN
        SET @Actual_Values = 
            'SELECT ' +  
            CASE WHEN @top IS NULL OR @top < 0 THEN '' ELSE ' TOP ' + LTRIM(STR(@top)) + ' ' END + 
            '''' + RTRIM(@Start_Insert) + 
            ' ''+' + '''(' + RTRIM(@Column_List) +  '''+' + ''')''' + 
            ' +''VALUES(''+ ' +  @Actual_Values  + '+'')''' + ' ' + 
            COALESCE(@from,' FROM ' + CASE WHEN @owner IS NULL THEN '' ELSE '[' + LTRIM(RTRIM(@owner)) + '].' END + '[' + rtrim(@table_name) + ']' + '(NOLOCK)')
    END
ELSE IF (@include_column_list = 0)
    BEGIN
        SET @Actual_Values = 
            'SELECT ' + 
            CASE WHEN @top IS NULL OR @top < 0 THEN '' ELSE ' TOP ' + LTRIM(STR(@top)) + ' ' END + 
            '''' + RTRIM(@Start_Insert) + 
            ' '' +''VALUES(''+ ' +  @Actual_Values + '+'')''' + ' ' + 
            COALESCE(@from,' FROM ' + CASE WHEN @owner IS NULL THEN '' ELSE '[' + LTRIM(RTRIM(@owner)) + '].' END + '[' + rtrim(@table_name) + ']' + '(NOLOCK)')
    END	

--Determining whether to ouput any debug information
IF @debug_mode =1
    BEGIN
        PRINT '/*****START OF DEBUG INFORMATION*****'
        PRINT 'Beginning of the INSERT statement:'
        PRINT @Start_Insert
        PRINT ''
        PRINT 'The column list:'
        PRINT @Column_List
        PRINT ''
        PRINT 'The SELECT statement executed to generate the INSERTs'
        PRINT @Actual_Values
        PRINT ''
        PRINT '*****END OF DEBUG INFORMATION*****/'
        PRINT ''
    END
        
PRINT '--INSERTs generated by ''sp_generate_inserts'' stored procedure written by Vyas'
PRINT '--Build number: 22'
PRINT '--Problems/Suggestions? Contact Vyas @ vyaskn@hotmail.com'
PRINT '--http://vyaskn.tripod.com'
PRINT ''
PRINT 'SET NOCOUNT ON'
PRINT ''


--Determining whether to print IDENTITY_INSERT or not
IF (@IDN <> '')
    BEGIN
        PRINT 'SET IDENTITY_INSERT ' + QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + QUOTENAME(@table_name) + ' ON'
        PRINT 'GO'
        PRINT ''
    END


IF @disable_constraints = 1 AND (OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name, 'U') IS NOT NULL)
    BEGIN
        IF @owner IS NULL
            BEGIN
                SELECT 	'ALTER TABLE ' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' NOCHECK CONSTRAINT ALL' AS '--Code to disable constraints temporarily'
            END
        ELSE
            BEGIN
                SELECT 	'ALTER TABLE ' + QUOTENAME(@owner) + '.' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' NOCHECK CONSTRAINT ALL' AS '--Code to disable constraints temporarily'
            END

        PRINT 'GO'
    END

PRINT ''
PRINT 'PRINT ''Inserting values into ' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']' + ''''


--All the hard work pays off here!!! You'll get your INSERT statements, when the next line executes!
EXEC (@Actual_Values)

PRINT 'PRINT ''Done'''
PRINT ''


IF @disable_constraints = 1 AND (OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name, 'U') IS NOT NULL)
    BEGIN
        IF @owner IS NULL
            BEGIN
                SELECT 	'ALTER TABLE ' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' CHECK CONSTRAINT ALL'  AS '--Code to enable the previously disabled constraints'
            END
        ELSE
            BEGIN
                SELECT 	'ALTER TABLE ' + QUOTENAME(@owner) + '.' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' CHECK CONSTRAINT ALL' AS '--Code to enable the previously disabled constraints'
            END

        PRINT 'GO'
    END

PRINT ''
IF (@IDN <> '')
    BEGIN
        PRINT 'SET IDENTITY_INSERT ' + QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + QUOTENAME(@table_name) + ' OFF'
        PRINT 'GO'
    END

PRINT 'SET NOCOUNT OFF'


SET NOCOUNT OFF
RETURN 0 --Success. We are done!
END




GO
/****** Object:  StoredProcedure [dbo].[User_Setting_Create]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[User_Setting_Create]
    -- Add the parameters for the stored procedure here
     @Name nvarchar(60) 
    ,@DataType nchar(1) = 'S'
    ,@DisplayName nvarchar(60) = NULL
    ,@DisplayOrder int = NULL
    ,@Description nvarchar(max) = NULL

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

IF(@DisplayName IS NULL) SET @DisplayName = @Name;
IF(@DisplayOrder IS NULL) SET @DisplayOrder = 0;
IF(@Description IS NULL) SET @Description = @Name;

    -- Insert statements for procedure here
IF(SELECT COUNT(*) FROM dbo.UserSetting WHERE Name = @Name) = 0
BEGIN -- INSERT

INSERT INTO [dbo].[UserSetting]
           ([UserSettingId]
           ,[Name]
           ,[DataType]
           ,[DisplayName]
           ,[DisplayOrder]
           ,[Description])
SELECT
           (SELECT ISNULL(MAX(UserSettingId), 0)+ 1 FROM [UserSetting]) -- UserSettingId, int,>
           ,@Name --, nvarchar(60),>
           ,@DataType --, nchar(1),>
           ,@DisplayName --, nvarchar(60),>
           ,@DisplayOrder --, int,>
           ,@Description --, nvarchar(max),>
;

END
ELSE
BEGIN -- UPDATE

UPDATE [dbo].[UserSetting]
   SET 
       [DataType] = @DataType --, nchar(1),>
      ,[DisplayName] = @DisplayName --, nvarchar(60),>
      ,[DisplayOrder] = @DisplayOrder --, int,>
      ,[Description] = @Description --, nvarchar(max),>
 WHERE
[Name] = @Name
;


END;





END


GO
/****** Object:  StoredProcedure [dbo].[User_Settings_GetValue_ByName]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[User_Settings_GetValue_ByName]
    -- Add the parameters for the stored procedure here
     @UserId int
    ,@Name nvarchar(60)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT
[Value]
FROM 
[dbo].[UserSettings]
WHERE
[Name] = @Name
AND
UserId = @UserId
;

END


GO
/****** Object:  StoredProcedure [dbo].[User_Settings_Update_Value]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	
-- Create new settings if no exists create new one with default values if no params exists.
-- =============================================
CREATE PROCEDURE [dbo].[User_Settings_Update_Value]
    -- Add the parameters for the stored procedure here
     @UserId int
    ,@Name nvarchar(60) 
    ,@Value nvarchar(240) 
    ,@DataType nchar(1) = 'S'
    ,@DisplayName nvarchar(60) = NULL
    ,@DisplayOrder int = NULL
    ,@Description nvarchar(max) = NULL

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

IF(@DisplayName IS NULL) SET @DisplayName = @Name;
IF(@DisplayOrder IS NULL) SET @DisplayOrder = 0;
IF(@Description IS NULL) SET @Description = @Name;

    -- Insert statements for procedure here
IF(SELECT COUNT(*) FROM dbo.UserSetting WHERE Name = @Name) = 0
BEGIN -- INSERT IN SETTING TABLE IF NO EXISTS.

INSERT INTO [dbo].[UserSetting]
           ([UserSettingId]
           ,[Name]
           ,[DataType]
           ,[DisplayName]
           ,[DisplayOrder]
           ,[Description])
SELECT
           (SELECT ISNULL(MAX(UserSettingId), 0)+ 1 FROM [UserSetting] ) -- UserSettingId, int,>
           ,@Name --, nvarchar(60),>
           ,@DataType --, nchar(1),>
           ,@DisplayName --, nvarchar(60),>
           ,@DisplayOrder --, int,>
           ,@Description --, nvarchar(max),>
;
END



IF(SELECT COUNT(*) FROM dbo.UserSettings WHERE Name = @Name AND UserId = @UserId) = 0
BEGIN -- INSERT

INSERT INTO [dbo].[UserSettings]
           (
             Name
          ,Value
          ,UserId
)
SELECT
            @Name --, nvarchar(60),>
           ,@Value --, nvarchar(240),>
           ,@UserId --, int
;
END
ELSE
BEGIN -- UPDATE

UPDATE [dbo].[UserSettings]
   SET 
       [Value] = @Value --, nvarchar(240),>
 WHERE
[Name] = @Name
AND
 UserId = @UserId
;


END;


END


GO
/****** Object:  StoredProcedure [dbo].[Utils_CountAllTableRowsInDatabase]    Script Date: 3/30/2020 8:32:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Utils_CountAllTableRowsInDatabase]
    -- Add the parameters for the stored procedure here

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT      SCHEMA_NAME(A.schema_id) + '.' +
        --A.Name, SUM(B.rows) AS 'RowCount'  Use AVG instead of SUM
          A.Name, AVG(B.rows) AS 'RowCount'
FROM        sys.objects A
INNER JOIN sys.partitions B ON A.object_id = B.object_id
WHERE       A.type = 'U'
GROUP BY    A.schema_id, A.Name
;

END
GO
USE [master]
GO
ALTER DATABASE [Quorum] SET  READ_WRITE 
GO
