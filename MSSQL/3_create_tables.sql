/*
Navicat SQL Server Data Transfer
Source Server         : SQLServer2017
Source Server Version : 140000
Source Host           : 192.168.3.169:1433
Source Database       : create_sql
Source Schema         : dbo
Target Server Type    : SQL Server
Target Server Version : 140000
File Encoding         : 65001
Date: 2021-11-07 15:16:20
*/
-- ----------------------------
-- Table structure for [dbo].[area]
-- ----------------------------
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[area]') AND type in (N'U'))
BEGIN
  DROP TABLE [dbo].[area]
END
GO

CREATE TABLE [dbo].[area] (
[area_code] nvarchar(32) NOT NULL ,
[description] nvarchar(128) NOT NULL ,
[last_update_time] datetime2(7) NOT NULL ,
[last_updated_by] nvarchar(32) NOT NULL 
)
GO
