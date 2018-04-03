-- Create table
create table INCB_COMMUTATOR_TYPE
(
  id_commutator_type NUMBER not null,
  v_vendor           VARCHAR2(255),
  v_model            VARCHAR2(255),
  n_port             NUMBER(10),
  v_description      VARCHAR2(255),
  b_deleted          NUMBER(1) default 0 not null,
  v_prefix_mac       VARCHAR2(255)
);
-- Add comments to the table 
comment on table INCB_COMMUTATOR_TYPE is 'Типы коммутаторов';
-- Add comments to the columns 
comment on column INCB_COMMUTATOR_TYPE.id_commutator_type is 'Код типа коммутатора';
comment on column INCB_COMMUTATOR_TYPE.v_vendor is 'Производитель';
comment on column INCB_COMMUTATOR_TYPE.v_model is 'Модель';
comment on column INCB_COMMUTATOR_TYPE.n_port is 'Количество портов';
comment on column INCB_COMMUTATOR_TYPE.v_description is 'Описание';
comment on column INCB_COMMUTATOR_TYPE.v_prefix_mac is 'Префикс для MAC-адреса';
comment on column INCB_COMMUTATOR_TYPE.b_deleted is 'Признак удалённости записи';

-- Create table
create table INCB_COMMUTATOR
(
  id_commutator      NUMBER(10) not null,
  ip_address         VARCHAR2(255) not null,
  id_commutator_type NUMBER(10) not null,
  v_description      VARCHAR2(255),
  b_deleted          NUMBER(1) default 0 not null,
  v_mac_address      VARCHAR2(64) not null,
  v_community_read   VARCHAR2(64) not null,
  v_community_write  VARCHAR2(64) not null,
  remote_id          VARCHAR2(255),
  b_need_convert_hex NUMBER(1) default 1,
  remote_id_hex      VARCHAR2(255)
);
-- Add comments to the table 
comment on table INCB_COMMUTATOR is 'Заведенные коммутаторы';

comment on column INCB_COMMUTATOR.id_commutator is 'Уникальный код коммутатора';
comment on column INCB_COMMUTATOR.ip_address is 'IP коммутатора';
comment on column INCB_COMMUTATOR.id_commutator_type is 'Тип коммутатора';
comment on column INCB_COMMUTATOR.v_description is 'Описание коммутатора';
comment on column INCB_COMMUTATOR.b_deleted is 'Признак удалённости записи';
comment on column INCB_COMMUTATOR.v_mac_address is 'MAC адрес';
comment on column INCB_COMMUTATOR.v_community_read is 'Доступ на чтение';
comment on column INCB_COMMUTATOR.v_community_write is 'Доступ на запись';
comment on column INCB_COMMUTATOR.remote_id is 'Идентификатор коммутатора во внешней системе';
comment on column INCB_COMMUTATOR.b_need_convert_hex is 'Признак использования remote_id в hex';
comment on column INCB_COMMUTATOR.remote_id_hex is 'Идентификатор коммутатора во внешней системе (в hex формате)';

create sequence s_incb_commutator start with 2000 increment by 1 cache 20;
create sequence s_incb_commutator_type start with 2007 increment by 1 cache 20;

alter session set NLS_LANGUAGE='RUSSIAN';
alter session set NLS_TERRITORY='RUSSIA';
alter session set NLS_CURRENCY='р.';
alter session set NLS_ISO_CURRENCY='RUSSIA';
alter session set NLS_NUMERIC_CHARACTERS='.,';
alter session set NLS_CALENDAR='GREGORIAN';
alter session set NLS_DATE_FORMAT='YYYY-MM-DD';
alter session set NLS_DATE_LANGUAGE='RUSSIAN';
alter session set NLS_SORT='BINARY';
alter session set NLS_TIME_FORMAT='HH24:MI:SSXFF';
alter session set NLS_TIMESTAMP_FORMAT='YYYY-MM-DD HH24:MI:SSXFF';
alter session set NLS_TIME_TZ_FORMAT='HH24:MI:SSXFF TZR';
alter session set NLS_TIMESTAMP_TZ_FORMAT='YYYY-MM-DD HH24:MI:SSXFF TZR';
alter session set NLS_DUAL_CURRENCY='р.';
alter session set NLS_COMP='BINARY';
alter session set NLS_LENGTH_SEMANTICS='BYTE';
alter session set NLS_NCHAR_CONV_EXCP='FALSE';

insert into incb_commutator_type (ID_COMMUTATOR_TYPE, V_VENDOR, V_MODEL, N_PORT, V_DESCRIPTION, B_DELETED, V_PREFIX_MAC)
values (2000, 'Тестовый', 'Тестовый', 24, null, 1, null);

insert into incb_commutator_type (ID_COMMUTATOR_TYPE, V_VENDOR, V_MODEL, N_PORT, V_DESCRIPTION, B_DELETED, V_PREFIX_MAC)
values (2001, 'Huawei', 'S2326TP-EI', 24, null, 0, null);

insert into incb_commutator_type (ID_COMMUTATOR_TYPE, V_VENDOR, V_MODEL, N_PORT, V_DESCRIPTION, B_DELETED, V_PREFIX_MAC)
values (2002, 'D-Link', '3200-28', 24, null, 0, null);

insert into incb_commutator_type (ID_COMMUTATOR_TYPE, V_VENDOR, V_MODEL, N_PORT, V_DESCRIPTION, B_DELETED, V_PREFIX_MAC)
values (2003, 'D-Link', '3028', 24, null, 0, null);

insert into incb_commutator_type (ID_COMMUTATOR_TYPE, V_VENDOR, V_MODEL, N_PORT, V_DESCRIPTION, B_DELETED, V_PREFIX_MAC)
values (2004, 'D-Link', '1100-16', 16, null, 0, null);

insert into incb_commutator_type (ID_COMMUTATOR_TYPE, V_VENDOR, V_MODEL, N_PORT, V_DESCRIPTION, B_DELETED, V_PREFIX_MAC)
values (2005, 'Huawei', 'S2303', 24, null, 0, null);

insert into incb_commutator_type (ID_COMMUTATOR_TYPE, V_VENDOR, V_MODEL, N_PORT, V_DESCRIPTION, B_DELETED, V_PREFIX_MAC)
values (2006, 'LINCSYS', 'LINCSYS', 24, null, 0, null);


