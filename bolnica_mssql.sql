USE [master]
GO
/****** Object:  Database [bolnica]    Script Date: 9/17/2026 5:57:55 AM ******/
CREATE DATABASE [bolnica]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'bolnica', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\bolnica.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'bolnica_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\bolnica_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [bolnica] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [bolnica].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [bolnica] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [bolnica] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [bolnica] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [bolnica] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [bolnica] SET ARITHABORT OFF 
GO
ALTER DATABASE [bolnica] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [bolnica] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [bolnica] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [bolnica] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [bolnica] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [bolnica] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [bolnica] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [bolnica] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [bolnica] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [bolnica] SET  ENABLE_BROKER 
GO
ALTER DATABASE [bolnica] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [bolnica] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [bolnica] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [bolnica] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [bolnica] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [bolnica] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [bolnica] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [bolnica] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [bolnica] SET  MULTI_USER 
GO
ALTER DATABASE [bolnica] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [bolnica] SET DB_CHAINING OFF 
GO
ALTER DATABASE [bolnica] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [bolnica] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [bolnica] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [bolnica] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [bolnica] SET QUERY_STORE = ON
GO
ALTER DATABASE [bolnica] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [bolnica]
GO
/****** Object:  Table [dbo].[doktor]    Script Date: 9/17/2026 5:57:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[doktor](
	[doktor_id] [int] IDENTITY(1,1) NOT NULL,
	[ime] [nvarchar](50) NOT NULL,
	[prezime] [nvarchar](50) NOT NULL,
	[odeljenje_id] [int] NOT NULL,
	[specijalizacija] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[doktor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lek]    Script Date: 9/17/2026 5:57:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lek](
	[lek_id] [int] IDENTITY(1,1) NOT NULL,
	[naziv] [nvarchar](100) NOT NULL,
	[cena_po_jedinici] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[lek_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[medicinski_karton]    Script Date: 9/17/2026 5:57:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[medicinski_karton](
	[karton_id] [int] IDENTITY(1,1) NOT NULL,
	[pacijent_id] [int] NOT NULL,
	[datum_upisa] [datetime] NOT NULL,
	[dijagnoza] [nvarchar](255) NULL,
	[terapija] [nvarchar](max) NULL,
	[napomena] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[karton_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[odeljenje]    Script Date: 9/17/2026 5:57:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[odeljenje](
	[odeljenje_id] [int] IDENTITY(1,1) NOT NULL,
	[naziv_odeljenja] [nvarchar](100) NOT NULL,
	[sef_doktor_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[odeljenje_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[osiguranje]    Script Date: 9/17/2026 5:57:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[osiguranje](
	[broj_polise] [nvarchar](30) NOT NULL,
	[pacijent_id] [int] NOT NULL,
	[naziv_fonda] [nvarchar](100) NOT NULL,
	[procenat_pokrica] [decimal](5, 2) NOT NULL,
	[godisnji_max] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[broj_polise] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pacijenti]    Script Date: 9/17/2026 5:57:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pacijenti](
	[pacijent_id] [int] IDENTITY(1,1) NOT NULL,
	[ime] [nvarchar](50) NOT NULL,
	[prezime] [nvarchar](50) NOT NULL,
	[datum_rodjenja] [date] NOT NULL,
	[jmbg] [char](13) NOT NULL,
	[lbo] [char](11) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[pacijent_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pregled]    Script Date: 9/17/2026 5:57:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pregled](
	[pregled_id] [int] IDENTITY(1,1) NOT NULL,
	[pacijent_id] [int] NOT NULL,
	[doktor_id] [int] NOT NULL,
	[datum_vreme] [datetime] NOT NULL,
	[status] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[pregled_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[recept]    Script Date: 9/17/2026 5:57:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[recept](
	[recept_id] [int] IDENTITY(1,1) NOT NULL,
	[doktor_id] [int] NOT NULL,
	[pacijent_id] [int] NOT NULL,
	[lek_id] [int] NOT NULL,
	[datum_izdavanja] [datetime] NOT NULL,
	[kolicina] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[recept_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[doktor] ON 

INSERT [dbo].[doktor] ([doktor_id], [ime], [prezime], [odeljenje_id], [specijalizacija]) VALUES (1, N'Nikola', N'Bogdanovic', 1, N'Neurolog - asistent')
INSERT [dbo].[doktor] ([doktor_id], [ime], [prezime], [odeljenje_id], [specijalizacija]) VALUES (2, N'Dragan', N'Popovic', 2, N'Kardiolog - nacelnik')
INSERT [dbo].[doktor] ([doktor_id], [ime], [prezime], [odeljenje_id], [specijalizacija]) VALUES (3, N'Jelena', N'Jovanovic', 2, N'Kardiolog - specijalista')
INSERT [dbo].[doktor] ([doktor_id], [ime], [prezime], [odeljenje_id], [specijalizacija]) VALUES (4, N'Marko', N'Simic', 2, N'Kardiolog')
INSERT [dbo].[doktor] ([doktor_id], [ime], [prezime], [odeljenje_id], [specijalizacija]) VALUES (5, N'Zoran', N'Kovacevic', 3, N'Ortoped')
INSERT [dbo].[doktor] ([doktor_id], [ime], [prezime], [odeljenje_id], [specijalizacija]) VALUES (6, N'Ana', N'Petrovic', 4, N'Pedijatar')
INSERT [dbo].[doktor] ([doktor_id], [ime], [prezime], [odeljenje_id], [specijalizacija]) VALUES (7, N'Mirjana', N'Lazic', 1, N'Neurolog')
SET IDENTITY_INSERT [dbo].[doktor] OFF
GO
SET IDENTITY_INSERT [dbo].[lek] ON 

INSERT [dbo].[lek] ([lek_id], [naziv], [cena_po_jedinici]) VALUES (1, N'Brufen 400mg', CAST(350.00 AS Decimal(10, 2)))
INSERT [dbo].[lek] ([lek_id], [naziv], [cena_po_jedinici]) VALUES (2, N'Paracetamol 500mg', CAST(220.00 AS Decimal(10, 2)))
INSERT [dbo].[lek] ([lek_id], [naziv], [cena_po_jedinici]) VALUES (3, N'Panklav 2X 1000mg', CAST(780.00 AS Decimal(10, 2)))
INSERT [dbo].[lek] ([lek_id], [naziv], [cena_po_jedinici]) VALUES (4, N'Bensedin 5mg', CAST(180.00 AS Decimal(10, 2)))
INSERT [dbo].[lek] ([lek_id], [naziv], [cena_po_jedinici]) VALUES (5, N'Prospan sirup', CAST(650.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [dbo].[lek] OFF
GO
SET IDENTITY_INSERT [dbo].[odeljenje] ON 

INSERT [dbo].[odeljenje] ([odeljenje_id], [naziv_odeljenja], [sef_doktor_id]) VALUES (1, N'Neurologija', 1)
INSERT [dbo].[odeljenje] ([odeljenje_id], [naziv_odeljenja], [sef_doktor_id]) VALUES (2, N'Kardiologija', 2)
INSERT [dbo].[odeljenje] ([odeljenje_id], [naziv_odeljenja], [sef_doktor_id]) VALUES (3, N'Ortopedija', 5)
INSERT [dbo].[odeljenje] ([odeljenje_id], [naziv_odeljenja], [sef_doktor_id]) VALUES (4, N'Pedijatrija', 6)
SET IDENTITY_INSERT [dbo].[odeljenje] OFF
GO
INSERT [dbo].[osiguranje] ([broj_polise], [pacijent_id], [naziv_fonda], [procenat_pokrica], [godisnji_max]) VALUES (N'POL-1001', 1, N'RFZO', CAST(100.00 AS Decimal(5, 2)), NULL)
INSERT [dbo].[osiguranje] ([broj_polise], [pacijent_id], [naziv_fonda], [procenat_pokrica], [godisnji_max]) VALUES (N'POL-1002', 2, N'RFZO', CAST(100.00 AS Decimal(5, 2)), NULL)
INSERT [dbo].[osiguranje] ([broj_polise], [pacijent_id], [naziv_fonda], [procenat_pokrica], [godisnji_max]) VALUES (N'POL-1003', 3, N'Uniqa Osiguranje', CAST(90.00 AS Decimal(5, 2)), CAST(200000.00 AS Decimal(10, 2)))
INSERT [dbo].[osiguranje] ([broj_polise], [pacijent_id], [naziv_fonda], [procenat_pokrica], [godisnji_max]) VALUES (N'POL-1004', 4, N'Generali Osiguranje', CAST(85.00 AS Decimal(5, 2)), CAST(150000.00 AS Decimal(10, 2)))
INSERT [dbo].[osiguranje] ([broj_polise], [pacijent_id], [naziv_fonda], [procenat_pokrica], [godisnji_max]) VALUES (N'POL-1005', 5, N'Wiener Städtische', CAST(80.00 AS Decimal(5, 2)), CAST(100000.00 AS Decimal(10, 2)))
INSERT [dbo].[osiguranje] ([broj_polise], [pacijent_id], [naziv_fonda], [procenat_pokrica], [godisnji_max]) VALUES (N'POL-1006', 6, N'RFZO', CAST(100.00 AS Decimal(5, 2)), NULL)
INSERT [dbo].[osiguranje] ([broj_polise], [pacijent_id], [naziv_fonda], [procenat_pokrica], [godisnji_max]) VALUES (N'POL-1007', 7, N'DDOR Novi Sad', CAST(80.00 AS Decimal(5, 2)), CAST(100000.00 AS Decimal(10, 2)))
INSERT [dbo].[osiguranje] ([broj_polise], [pacijent_id], [naziv_fonda], [procenat_pokrica], [godisnji_max]) VALUES (N'POL-1008', 8, N'RFZO', CAST(100.00 AS Decimal(5, 2)), NULL)
INSERT [dbo].[osiguranje] ([broj_polise], [pacijent_id], [naziv_fonda], [procenat_pokrica], [godisnji_max]) VALUES (N'POL-1009', 9, N'Dunav Osiguranje', CAST(75.00 AS Decimal(5, 2)), CAST(80000.00 AS Decimal(10, 2)))
INSERT [dbo].[osiguranje] ([broj_polise], [pacijent_id], [naziv_fonda], [procenat_pokrica], [godisnji_max]) VALUES (N'POL-1010', 10, N'RFZO', CAST(100.00 AS Decimal(5, 2)), NULL)
GO
SET IDENTITY_INSERT [dbo].[pacijenti] ON 

INSERT [dbo].[pacijenti] ([pacijent_id], [ime], [prezime], [datum_rodjenja], [jmbg], [lbo]) VALUES (1, N'Filip', N'Djordjevic', CAST(N'2003-04-27' AS Date), N'2704003123456', N'10123456787')
INSERT [dbo].[pacijenti] ([pacijent_id], [ime], [prezime], [datum_rodjenja], [jmbg], [lbo]) VALUES (2, N'Tamara', N'Milenkovic', CAST(N'1995-11-12' AS Date), N'1211995715023', N'11234567890')
INSERT [dbo].[pacijenti] ([pacijent_id], [ime], [prezime], [datum_rodjenja], [jmbg], [lbo]) VALUES (3, N'Marija', N'Pavlovic', CAST(N'1988-06-15' AS Date), N'1506988715012', N'80912345678')
INSERT [dbo].[pacijenti] ([pacijent_id], [ime], [prezime], [datum_rodjenja], [jmbg], [lbo]) VALUES (4, N'Luka', N'Dimitrijevic', CAST(N'1991-03-20' AS Date), N'2003991710045', N'70891234567')
INSERT [dbo].[pacijenti] ([pacijent_id], [ime], [prezime], [datum_rodjenja], [jmbg], [lbo]) VALUES (5, N'Jelena', N'Nikolic', CAST(N'1985-09-05' AS Date), N'0509985715089', N'60798123456')
INSERT [dbo].[pacijenti] ([pacijent_id], [ime], [prezime], [datum_rodjenja], [jmbg], [lbo]) VALUES (6, N'Sara', N'Milic', CAST(N'2015-02-18' AS Date), N'1802015715034', N'50698712345')
INSERT [dbo].[pacijenti] ([pacijent_id], [ime], [prezime], [datum_rodjenja], [jmbg], [lbo]) VALUES (7, N'Petar', N'Vasic', CAST(N'1979-12-30' AS Date), N'3012979710012', N'40596871234')
INSERT [dbo].[pacijenti] ([pacijent_id], [ime], [prezime], [datum_rodjenja], [jmbg], [lbo]) VALUES (8, N'Ivana', N'Jankovic', CAST(N'1993-07-22' AS Date), N'2207993715067', N'30495867123')
INSERT [dbo].[pacijenti] ([pacijent_id], [ime], [prezime], [datum_rodjenja], [jmbg], [lbo]) VALUES (9, N'Milan', N'Ilic', CAST(N'1968-04-10' AS Date), N'1004968710023', N'20394857612')
INSERT [dbo].[pacijenti] ([pacijent_id], [ime], [prezime], [datum_rodjenja], [jmbg], [lbo]) VALUES (10, N'Marko', N'Stojkovic', CAST(N'1975-08-14' AS Date), N'1408975710034', N'10293847561')
SET IDENTITY_INSERT [dbo].[pacijenti] OFF
GO
SET IDENTITY_INSERT [dbo].[pregled] ON 

INSERT [dbo].[pregled] ([pregled_id], [pacijent_id], [doktor_id], [datum_vreme], [status]) VALUES (1, 10, 2, CAST(N'2026-09-15T09:30:00.000' AS DateTime), N'Zakazan')
INSERT [dbo].[pregled] ([pregled_id], [pacijent_id], [doktor_id], [datum_vreme], [status]) VALUES (2, 9, 2, CAST(N'2026-09-15T10:15:00.000' AS DateTime), N'Zakazan')
INSERT [dbo].[pregled] ([pregled_id], [pacijent_id], [doktor_id], [datum_vreme], [status]) VALUES (3, 8, 7, CAST(N'2026-09-16T11:00:00.000' AS DateTime), N'Zakazan')
INSERT [dbo].[pregled] ([pregled_id], [pacijent_id], [doktor_id], [datum_vreme], [status]) VALUES (4, 7, 5, CAST(N'2026-09-17T08:45:00.000' AS DateTime), N'Zakazan')
INSERT [dbo].[pregled] ([pregled_id], [pacijent_id], [doktor_id], [datum_vreme], [status]) VALUES (5, 6, 6, CAST(N'2026-09-18T12:30:00.000' AS DateTime), N'Zakazan')
INSERT [dbo].[pregled] ([pregled_id], [pacijent_id], [doktor_id], [datum_vreme], [status]) VALUES (6, 5, 3, CAST(N'2026-09-20T09:00:00.000' AS DateTime), N'Zakazan')
INSERT [dbo].[pregled] ([pregled_id], [pacijent_id], [doktor_id], [datum_vreme], [status]) VALUES (7, 4, 3, CAST(N'2026-09-20T10:30:00.000' AS DateTime), N'Zakazan')
INSERT [dbo].[pregled] ([pregled_id], [pacijent_id], [doktor_id], [datum_vreme], [status]) VALUES (8, 3, 4, CAST(N'2026-09-21T11:15:00.000' AS DateTime), N'Zakazan')
INSERT [dbo].[pregled] ([pregled_id], [pacijent_id], [doktor_id], [datum_vreme], [status]) VALUES (9, 1, 1, CAST(N'2026-09-22T08:45:00.000' AS DateTime), N'Zakazan')
INSERT [dbo].[pregled] ([pregled_id], [pacijent_id], [doktor_id], [datum_vreme], [status]) VALUES (10, 2, 1, CAST(N'2026-09-22T12:00:00.000' AS DateTime), N'Zakazan')
INSERT [dbo].[pregled] ([pregled_id], [pacijent_id], [doktor_id], [datum_vreme], [status]) VALUES (12, 6, 2, CAST(N'2026-09-21T07:44:00.000' AS DateTime), N'Zakazan')
SET IDENTITY_INSERT [dbo].[pregled] OFF
GO
ALTER TABLE [dbo].[doktor]  WITH CHECK ADD  CONSTRAINT [FK_doktor_odeljenje] FOREIGN KEY([odeljenje_id])
REFERENCES [dbo].[odeljenje] ([odeljenje_id])
GO
ALTER TABLE [dbo].[doktor] CHECK CONSTRAINT [FK_doktor_odeljenje]
GO
ALTER TABLE [dbo].[medicinski_karton]  WITH CHECK ADD  CONSTRAINT [FK_karton_pacijent] FOREIGN KEY([pacijent_id])
REFERENCES [dbo].[pacijenti] ([pacijent_id])
GO
ALTER TABLE [dbo].[medicinski_karton] CHECK CONSTRAINT [FK_karton_pacijent]
GO
ALTER TABLE [dbo].[odeljenje]  WITH NOCHECK ADD  CONSTRAINT [FK_odeljenje_sef] FOREIGN KEY([sef_doktor_id])
REFERENCES [dbo].[doktor] ([doktor_id])
GO
ALTER TABLE [dbo].[odeljenje] CHECK CONSTRAINT [FK_odeljenje_sef]
GO
ALTER TABLE [dbo].[osiguranje]  WITH CHECK ADD  CONSTRAINT [FK_osiguranje_pacijent] FOREIGN KEY([pacijent_id])
REFERENCES [dbo].[pacijenti] ([pacijent_id])
GO
ALTER TABLE [dbo].[osiguranje] CHECK CONSTRAINT [FK_osiguranje_pacijent]
GO
ALTER TABLE [dbo].[pregled]  WITH CHECK ADD  CONSTRAINT [FK_pregled_doktor] FOREIGN KEY([doktor_id])
REFERENCES [dbo].[doktor] ([doktor_id])
GO
ALTER TABLE [dbo].[pregled] CHECK CONSTRAINT [FK_pregled_doktor]
GO
ALTER TABLE [dbo].[pregled]  WITH CHECK ADD  CONSTRAINT [FK_pregled_pacijent] FOREIGN KEY([pacijent_id])
REFERENCES [dbo].[pacijenti] ([pacijent_id])
GO
ALTER TABLE [dbo].[pregled] CHECK CONSTRAINT [FK_pregled_pacijent]
GO
ALTER TABLE [dbo].[recept]  WITH CHECK ADD  CONSTRAINT [FK_recept_doktor] FOREIGN KEY([doktor_id])
REFERENCES [dbo].[doktor] ([doktor_id])
GO
ALTER TABLE [dbo].[recept] CHECK CONSTRAINT [FK_recept_doktor]
GO
ALTER TABLE [dbo].[recept]  WITH CHECK ADD  CONSTRAINT [FK_recept_lek] FOREIGN KEY([lek_id])
REFERENCES [dbo].[lek] ([lek_id])
GO
ALTER TABLE [dbo].[recept] CHECK CONSTRAINT [FK_recept_lek]
GO
ALTER TABLE [dbo].[recept]  WITH CHECK ADD  CONSTRAINT [FK_recept_pacijent] FOREIGN KEY([pacijent_id])
REFERENCES [dbo].[pacijenti] ([pacijent_id])
GO
ALTER TABLE [dbo].[recept] CHECK CONSTRAINT [FK_recept_pacijent]
GO
USE [master]
GO
ALTER DATABASE [bolnica] SET  READ_WRITE 
GO
