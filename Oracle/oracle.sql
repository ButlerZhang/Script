/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     2020/6/8 10:17:18                            */
/*==============================================================*/


drop index TABLE_A_UI1;

drop table TABLE_A cascade constraints;

drop index TABLE_B_UIDX1;

drop table TABLE_B cascade constraints;

/*==============================================================*/
/* Table: TABLE_A                                             */
/*==============================================================*/
create table TABLE_A 
(
   USER_CODE            NUMBER(19)           not null,
   USE_SCOPE            CHAR(1)              not null,
   AUTH_TYPE            CHAR(1)              not null,
   AUTH_DATA            VARCHAR2(256)        not null,
   SET_DATE             NUMBER(10)           not null,
   FAIL_NUM             NUMBER(6)            default 0 not null,
   CHK_FLAG             CHAR(1)              not null,
   AUTH_DATA_TYPE       CHAR(1)              not null
);

/*==============================================================*/
/* Index: TABLE_A_UI1                                          */
/*==============================================================*/
create unique index TABLE_A_UI1 on TABLE_A (
   USER_CODE ASC,
   USE_SCOPE ASC,
   AUTH_TYPE ASC
);

/*==============================================================*/
/* Table: TABLE_B                                           */
/*==============================================================*/
create table TABLE_B 
(
   CHANNEL_ID           VARCHAR2(2)          default '0' not null,
   CHANNEL_NAME         VARCHAR2(64)         not null,
   QUE_ID               NUMBER(10)           default 0 not null,
   REMARK               VARCHAR2(128)        not null
);

/*==============================================================*/
/* Index: TABLE_B_UIDX1                                     */
/*==============================================================*/
create unique index TABLE_B_UIDX1 on TABLE_B (
   CHANNEL_ID ASC
);
