-- Create table
create table FW_CONTRACTS
(
  id_contract_inst         NUMBER(10) not null,
  dt_stop                  TIMESTAMP(0) WITH LOCAL TIME ZONE not null,
  dt_start                 TIMESTAMP(0) WITH LOCAL TIME ZONE not null,
  id_rec                   NUMBER,
  id_client_inst           NUMBER(10) not null,
  id_currency              NUMBER(10),
  v_status                 CHAR(1) default 'A' not null,
  dt_reg_event             TIMESTAMP(0) WITH LOCAL TIME ZONE,
  v_description            VARCHAR2(255),
  id_department            NUMBER(10),
  id_category              NUMBER(10),
  v_ext_ident              VARCHAR2(150)
);
-- Add comments to the table 
comment on table FW_CONTRACTS
  is 'Контракты';
-- Add comments to the columns 
comment on column FW_CONTRACTS.id_contract_inst
  is 'Идентификатор контракта';
comment on column FW_CONTRACTS.dt_stop
  is 'Дата конца действия записи';
comment on column FW_CONTRACTS.dt_start
  is 'Дата начала действия записи';
comment on column FW_CONTRACTS.id_rec
  is 'Идентификатор записи';
comment on column FW_CONTRACTS.id_client_inst
  is 'Идентификатор клиента';
comment on column FW_CONTRACTS.v_status
  is 'Статус
   А активен,
   B заблокирован,
   С расторжен,
   D удален';
comment on column FW_CONTRACTS.dt_reg_event
  is 'Дата регистрации';
comment on column FW_CONTRACTS.v_description
  is 'Описание контракта';
comment on column FW_CONTRACTS.id_department
  is 'Код департамента из миграционной таблицы MIGR_DEPARTMENTS';
comment on column FW_CONTRACTS.id_category
  is 'Код котегории контракта';
comment on column FW_CONTRACTS.v_ext_ident
  is 'Внешний идентификатор контракта';
  alter table FW_CONTRACTS
  add primary key (id_rec);
  
  
 -- Create table
create table TRANS_EXTERNAL
(
  id_trans                    NUMBER(10) not null,
  id_contract                 NUMBER(10) not null,
  id_trans_type               NUMBER(10) not null,
  id_source                   NUMBER(10) not null,
  f_sum                       NUMBER not null,
  v_status                    CHAR(1) default 'A' not null,
  id_repperiod_creation       NUMBER(10) not null,
  id_repperiod_deletion       NUMBER(10),
  id_manager                  NUMBER(10) not null,
  id_manager_delete           NUMBER(10),
  dt_event                    TIMESTAMP(0) WITH LOCAL TIME ZONE not null
)
;
-- Add comments to the table 
comment on table TRANS_EXTERNAL
  is 'Основная таблица финансовой системы. Служит для хранения платежей, поступающих в систему.';
-- Add comments to the columns 
comment on column TRANS_EXTERNAL.id_trans
  is 'Уникальный код платежа';
comment on column TRANS_EXTERNAL.id_contract
  is 'Код контракта';
comment on column TRANS_EXTERNAL.id_trans_type
  is 'Уникальный код типа проводки.';
comment on column TRANS_EXTERNAL.id_source
  is 'Уникальный код источника платежа';


comment on column TRANS_EXTERNAL.v_status
  is 'Статус:
     A - активный
     D - удалён';
comment on column TRANS_EXTERNAL.id_repperiod_creation
  is 'Уникальный код отчётного периода создания платежа';
comment on column TRANS_EXTERNAL.id_repperiod_deletion
  is 'Уникальный код отчётного периода удаления платежа';
comment on column TRANS_EXTERNAL.id_manager
  is 'Код оператора, внёсшего платёж';
comment on column TRANS_EXTERNAL.id_manager_delete
  is 'Код оператора, удалившего платёж';
comment on column TRANS_EXTERNAL.dt_event
  is 'Дата фактического поступления платежа в систему';

alter table TRANS_EXTERNAL
  add primary key (ID_TRANS);

  -- Create table
create table FW_DEPARTMENTS
(
  id_department  NUMBER(10) not null,
  id_parent      NUMBER(10),
  v_name         VARCHAR2(128 CHAR) not null,
  b_deleted      NUMBER(1) default 0 not null
)
;
-- Add comments to the table 
comment on table FW_DEPARTMENTS
  is 'Список департаментов.
На основе дерева департаментов выполняется разграничение доступа пользователей.
Также департаменты оказывают влияение на процесс списания абон. платы (в рамках разных временных зон).';
-- Add comments to the columns 
comment on column FW_DEPARTMENTS.id_department
  is 'Уникальный код департамента';
comment on column FW_DEPARTMENTS.id_parent
  is 'Ссылка на код, являющийся родителем';
comment on column FW_DEPARTMENTS.v_name
  is 'Уникальное наменование';

-- Create/Recreate primary, unique and foreign key constraints 
alter table FW_DEPARTMENTS
  add primary key (ID_DEPARTMENT);
  
-- Create table
create table FW_IDENTIFIERS
(
  id_identifier         NUMBER(10) not null,
  id_service_identifier NUMBER(10) not null,
  v_value               VARCHAR2(128 CHAR) not null,
  v_status              CHAR(1 CHAR) default 'N' not null,
  v_pass                VARCHAR2(64 CHAR),
  b_deleted             NUMBER(1) default 0 not null,
  v_ext_ident           VARCHAR2(20 CHAR)
)
;
-- Add comments to the table 
comment on table FW_IDENTIFIERS
  is 'Хранилище идентификаторов';
-- Add comments to the columns 
comment on column FW_IDENTIFIERS.id_identifier
  is 'Уникальный ключ идентификатора';
comment on column FW_IDENTIFIERS.id_service_identifier
  is 'Первичный ключ';
comment on column FW_IDENTIFIERS.v_value
  is 'Значение идентификатора ( например телефонный номер или IP адресс)';
comment on column FW_IDENTIFIERS.v_status
  is 'Статус идентификатора
W - в режиме ожидания (в отстойнике)
N - новый
U - используется
R - зарезервирован';
comment on column FW_IDENTIFIERS.v_pass
  is 'Поле для пароля ассоциируемого с данным идентификатором.';
comment on column FW_IDENTIFIERS.b_deleted
  is 'Признак удалённости';
comment on column FW_IDENTIFIERS.v_ext_ident
  is 'Внешний идентификатор для внешних систем';


-- Create/Recreate primary, unique and foreign key constraints 
alter table FW_IDENTIFIERS
  add primary key (ID_IDENTIFIER);
alter table FW_IDENTIFIERS
  add check (V_STATUS IN ('N', 'U', 'R', 'W'));
alter table FW_IDENTIFIERS
  add check (B_DELETED IN (0, 1));

-- Create table
create table FW_SERVICE_IDENTIFIERS
(
  id_rec                     NUMBER not null,
  id_service_identifier_inst NUMBER(10) not null,
  id_service_identifier      NUMBER(10),
  dt_start                   TIMESTAMP(0) WITH LOCAL TIME ZONE not null,
  dt_updated                 TIMESTAMP(0) WITH LOCAL TIME ZONE,
  dt_stop                    TIMESTAMP(0) WITH LOCAL TIME ZONE not null,
  id_service_inst            NUMBER(10),
  b_deleted                  NUMBER(1) default 0 not null,
  id_manager                 NUMBER(10) not null,
  id_identifier              NUMBER(10) not null,
  v_status                   CHAR(1) not null
);
-- Add comments to the table 
comment on table FW_SERVICE_IDENTIFIERS
  is 'Идентификаторы услуг (экземпляры)';
-- Add comments to the columns 
comment on column FW_SERVICE_IDENTIFIERS.id_service_identifier_inst
  is 'Экземпляр идентификатора услуги';
comment on column FW_SERVICE_IDENTIFIERS.id_service_identifier
  is 'Идентификатор услуги';
comment on column FW_SERVICE_IDENTIFIERS.dt_start
  is 'Дата начала действия идентификатора';
comment on column FW_SERVICE_IDENTIFIERS.dt_updated
  is 'Дата последней модификации конкретной строчки';
comment on column FW_SERVICE_IDENTIFIERS.dt_stop
  is 'Дата окончания действия идентификатора';
comment on column FW_SERVICE_IDENTIFIERS.id_service_inst
  is 'Идентификатор сущности услуги';
comment on column FW_SERVICE_IDENTIFIERS.b_deleted
  is 'Признак удалёной записи';
comment on column FW_SERVICE_IDENTIFIERS.id_manager
  is 'Идентификатор менаджера  или оператора производившего изменения';
comment on column FW_SERVICE_IDENTIFIERS.id_identifier
  is 'Уникальный ключ идентификатора';


alter table FW_SERVICE_IDENTIFIERS
  add primary key (ID_REC);

alter table FW_SERVICE_IDENTIFIERS
  add check (B_DELETED IN (0, 1));

  
-- Create table
create table FW_SERVICE_IDENTIFIER
(
  id_service_identifier NUMBER(10) not null,
  v_name                VARCHAR2(255) not null,
  v_descr               VARCHAR2(255),
  v_mnemonic            VARCHAR2(16),
  b_deleted             NUMBER(1) default 0 not null
)
;
-- Add comments to the table 
comment on table FW_SERVICE_IDENTIFIER
  is 'Каталог типов идентификаторов услуг';
-- Add comments to the columns 
comment on column FW_SERVICE_IDENTIFIER.id_service_identifier
  is 'Первичный ключ';
comment on column FW_SERVICE_IDENTIFIER.v_name
  is 'Название';
comment on column FW_SERVICE_IDENTIFIER.v_descr
  is 'Описание';
comment on column FW_SERVICE_IDENTIFIER.v_mnemonic
  is 'Мнемоника котрую будет использовать загрузчик для распознования типа идентификатора указанного в файле статистики';
comment on column FW_SERVICE_IDENTIFIER.b_deleted
  is 'Признак удалёной записи';
-- Create/Recreate primary, unique and foreign key constraints 
alter table FW_SERVICE_IDENTIFIER
  add primary key (ID_SERVICE_IDENTIFIER);
  
-- Create table
create table FW_PRODUCT_CONTENT
(
  id_product_content NUMBER(10) not null,
  dt_start           TIMESTAMP(0) WITH LOCAL TIME ZONE not null,
  dt_stop            TIMESTAMP(0) WITH LOCAL TIME ZONE not null,
  id_rec             NUMBER,
  id_product         NUMBER(10) not null,
  id_service         NUMBER(10) not null,
  id_service_parent  NUMBER(10),
  b_add_service      NUMBER(1) default 0 not null,
  b_deleted          NUMBER(1) default 0 not null
)
;
-- Add comments to the table 
comment on table FW_PRODUCT_CONTENT
  is 'Таблица наполнения типа продукта.';
-- Add comments to the columns 
comment on column FW_PRODUCT_CONTENT.id_product_content
  is 'Код наполнения продукта';
comment on column FW_PRODUCT_CONTENT.dt_start
  is 'Дата начала наполнения продукта';
comment on column FW_PRODUCT_CONTENT.dt_stop
  is 'Дата окончания наполнения продукта';
comment on column FW_PRODUCT_CONTENT.id_rec
  is 'Уникальный код записи по всей базе';
comment on column FW_PRODUCT_CONTENT.id_product
  is 'Первичный ключ (идентификатор продукта)';
comment on column FW_PRODUCT_CONTENT.id_service
  is 'Код типа услуги';
comment on column FW_PRODUCT_CONTENT.id_service_parent
  is 'Код родительского типа услуги если он есть.';

comment on column FW_PRODUCT_CONTENT.b_add_service
  is 'Признак того что услуга либо основная либо дополнительная.
(0 - основная, 1 - дополнительная)';

comment on column FW_PRODUCT_CONTENT.b_deleted
  is 'Признак удаленности записи';


-- Create/Recreate primary, unique and foreign key constraints 
alter table FW_PRODUCT_CONTENT
  add primary key (ID_PRODUCT_CONTENT, DT_START, DT_STOP);

-- Create table
create table FW_SERVICES
(
  id_contract_inst        NUMBER(10) not null,
  id_service_inst         NUMBER(10) not null,
  b_deleted               NUMBER(1) default 0 not null,
  dt_stop                 TIMESTAMP(0) WITH LOCAL TIME ZONE not null,
  dt_start                TIMESTAMP(0) WITH LOCAL TIME ZONE not null,
  id_rec                  NUMBER,
  id_subscriber_inst      NUMBER(10),
  id_product_inst         NUMBER(10) not null,
  id_tariff_plan          NUMBER(10),
  id_parent_inst          NUMBER(10),
  id_dependency_inst      NUMBER(10),
  id_service              NUMBER(10),
  id_flow                 NUMBER(10),
  id_manager              NUMBER(10),
  dt_updated              TIMESTAMP(0) WITH LOCAL TIME ZONE default CURRENT_TIMESTAMP not null,
  dt_plan                 TIMESTAMP(0) WITH LOCAL TIME ZONE,
  v_ext_ident             VARCHAR2(32 CHAR),
  v_status                CHAR(1 CHAR) default 'A' not null,
  dt_init                 TIMESTAMP(0) WITH LOCAL TIME ZONE
);
-- Add comments to the table 
comment on table FW_SERVICES is 'Таблица экземпляров услуг';
-- Add comments to the columns 
comment on column FW_SERVICES.id_contract_inst is 'Код экземпляра контракта';
comment on column FW_SERVICES.id_service_inst is 'Код экземпляра услуги';
comment on column FW_SERVICES.b_deleted is 'Признак удалённой записи';
comment on column FW_SERVICES.dt_stop is 'Дата окончания действия услуги';
comment on column FW_SERVICES.dt_start is 'Дата начала действия услуги';
comment on column FW_SERVICES.id_rec is 'Уникальный код записи по всей базе';
comment on column FW_SERVICES.id_subscriber_inst is 'Код экземпляра абонента';
comment on column FW_SERVICES.id_product_inst is 'Код экземпляра продукта';
comment on column FW_SERVICES.id_tariff_plan is 'Код тарифного плана продукта';
comment on column FW_SERVICES.id_parent_inst is 'Код экземпляра услуги родителя';
comment on column FW_SERVICES.id_dependency_inst is 'Код экземпляра услуги, от которого зависит';
comment on column FW_SERVICES.id_service is 'Код типа услуги';
comment on column FW_SERVICES.id_flow is 'Код заказа';
comment on column FW_SERVICES.id_manager is 'Код пользователя';
comment on column FW_SERVICES.dt_updated is 'Дата последнего обновления записи в таблице';
comment on column FW_SERVICES.dt_plan is 'Дата планового подключеная услуги';
comment on column FW_SERVICES.v_ext_ident is 'Идентификатор записи для внешней системы';
comment on column FW_SERVICES.v_status is 'Статус услуги: "A" - активный; "D" - удаленный';
comment on column FW_SERVICES.dt_init is 'Дата фактического подключеная услуги';
 
-- Create sequence 
create sequence S_FW_PRODUCT_CONTENT
minvalue 1
maxvalue 9999999999999999999999999999
start with 2000
increment by 1
cache 20;  

-- Create sequence 
create sequence S_REC
minvalue 1
maxvalue 9999999999999999999999999999
start with 2000
increment by 1
cache 20;    

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


insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2000, '2015-04-01 00:00:00', '2500-01-01 00:00:00', 2932528, 2000, 2200, null, 0, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2020, '2015-04-01 00:00:00', '2500-01-01 00:00:00', 4828050, 2020, 2220, null, 0, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2035, '2015-04-01 00:00:00', '2500-01-01 00:00:00', 4828069, 2000, 2174, 2200, 1, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2036, '2015-04-01 00:00:00', '2500-01-01 00:00:00', 4828070, 2000, 2174, 2201, 1, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2037, '2015-04-01 00:00:00', '2500-01-01 00:00:00', 4828071, 2000, 2174, 2221, 1, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2038, '2015-04-01 00:00:00', '2500-01-01 00:00:00', 4828072, 2000, 2174, 2226, 1, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2127, '2015-04-01 00:00:00', '2500-01-01 00:00:00', 8779532, 2000, 2174, 2227, 1, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2001, '2015-04-01 00:00:00', '2500-01-01 00:00:00', 2932529, 2000, 2201, null, 0, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2550, '2015-05-01 00:00:00', '2500-01-01 00:00:00', 53817536, 2163, 2577, 2576, 1, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2601, '2016-09-29 10:47:28', '2016-09-29 10:48:36', 54508952, 2020, 2587, null, 0, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2601, '2016-09-29 10:48:36', '2500-01-01 00:00:00', 54508952, 2020, 2587, null, 0, 1);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2840, '2017-06-01 00:00:00', '2500-01-01 00:00:00', 61482668, 2000, 2767, null, 0, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2600, '2016-09-01 00:00:00', '2500-01-01 00:00:00', 54501314, 2182, 2587, null, 0, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2920, '2018-02-12 18:47:27', '2018-02-12 18:51:38', 64006342, 2080, 2869, 2440, 1, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2920, '2018-02-12 18:51:38', '2500-01-01 00:00:00', 64006342, 2080, 2869, 2440, 1, 1);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2373, '2015-01-01 00:00:00', '2500-01-01 00:00:00', 45838572, 2080, 2452, 2440, 1, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2940, '2015-02-28 15:56:56', '2500-01-01 00:00:00', 64277030, 2080, 2869, 2440, 1, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2942, '2018-02-28 15:58:51', '2500-01-01 00:00:00', 64277032, 2080, 2871, 2440, 1, 0);

insert into fw_product_content (ID_PRODUCT_CONTENT, DT_START, DT_STOP, ID_REC, ID_PRODUCT, ID_SERVICE, ID_SERVICE_PARENT, B_ADD_SERVICE, B_DELETED)
values (2942, '2015-02-28 15:59:40', '2018-02-28 15:58:51', 64277033, 2080, 2871, 2440, 1, 0);


insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1733840, 3755791, 0, '2017-05-22 00:00:00', '2015-09-01 00:00:00', 34457285, 1446557, 1695660, 2020, null, null, 2220, 45805, 2183, '2015-09-22 10:15:02', null, '847259', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1733840, 3755791, 0, '2015-09-01 00:00:00', '2015-05-01 00:00:00', 20977295, 1446557, 1695660, 2022, null, null, 2220, null, 2, '2015-06-13 01:13:39', null, '847259', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1733840, 3755791, 0, '2018-01-01 00:00:00', '2017-05-22 00:00:00', 60051915, 1446557, 1695660, 2649, null, null, 2220, 354378, 2921, '2017-05-22 13:30:21', null, '847259', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1733840, 3755791, 0, '2018-02-12 00:00:00', '2018-01-01 00:00:00', 63222457, 1446557, 1695660, 2020, null, null, 2220, null, 2, '2017-12-26 13:27:18', null, '847259', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1733840, 3755791, 0, '2018-03-01 00:00:00', '2018-02-12 00:00:00', 64000598, 1446557, 1695660, 2649, null, null, 2220, 491054, 2507, '2018-02-12 11:08:54', null, '847259', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1733840, 3755791, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 63999811, 1446557, 1695660, 2649, null, null, 2220, 491012, 2507, '2018-02-12 10:45:37', null, '847259', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1662658, 3761417, 0, '2017-02-01 00:00:00', '2015-05-01 00:00:00', 20988544, 1554622, 1701283, 2022, null, null, 2220, null, 2, '2015-06-13 01:13:50', null, '854939', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1662658, 3761417, 0, '2018-02-02 00:00:00', '2017-02-01 00:00:00', 58501936, 1554622, 1701283, 2020, null, null, 2220, 293189, 2597, '2017-02-03 15:58:19', null, '854939', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1662658, 3761417, 0, '2500-01-01 00:00:00', '2018-03-02 00:00:00', 63905926, 1554622, 1701283, 2649, null, null, 2220, 484362, 51260, '2018-02-02 14:39:33', null, '854939', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1662658, 3761417, 0, '2018-03-02 00:00:00', '2018-02-02 00:00:00', 63906048, 1554622, 1701283, 2649, null, null, 2220, 484368, 51260, '2018-02-02 14:46:23', null, '854939', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1760265, 3777069, 0, '2018-02-01 00:00:00', '2015-05-01 00:00:00', 21019838, 1491287, 1716925, 2020, null, null, 2220, null, 2, '2015-06-13 01:14:25', null, '876811', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1760265, 3777069, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 63882180, 1491287, 1716925, 2649, null, null, 2220, 482906, 51260, '2018-02-01 08:44:21', null, '876811', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1760265, 3777069, 0, '2018-03-01 00:00:00', '2018-02-01 00:00:00', 63882262, 1491287, 1716925, 2649, null, null, 2220, 482915, 51260, '2018-02-01 08:53:51', null, '876811', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2390693, 6382818, 0, '2018-03-01 00:00:00', '2017-11-01 00:00:00', 62433602, 2432719, 2766301, 2492, null, null, 2587, 411683, 2062, '2017-10-06 14:54:14', null, '6382818', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2390693, 6382818, 0, '2017-11-01 00:00:00', '2017-09-29 00:00:00', 62352824, 2432719, 2766301, 2490, null, null, 2587, 406129, 2062, '2017-09-29 11:29:24', null, '6382818', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2390693, 6382818, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 63981581, 2432719, 2766301, 2494, null, null, 2587, 489301, 2062, '2018-02-09 11:36:00', null, '6382818', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2396898, 6451006, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 63085972, 2439335, 2773260, 2002, null, null, 2201, 444828, 50467, '2017-12-07 11:57:08', null, '6451006', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400592, 6507368, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 63723070, 2447056, 2781357, 2002, null, null, 2200, 476105, 47907, '2018-01-26 11:46:57', null, '6507368', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2401904, 6524937, 0, '2500-01-01 00:00:00', '2018-02-28 00:00:00', 63922156, 2449158, 2783607, 2002, null, null, 2200, 485546, 52582, '2018-02-05 11:30:39', null, '6524937', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2402081, 6526375, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 63940127, 2449389, 2783867, 2002, null, null, 2200, 486494, 50467, '2018-02-06 11:51:22', null, '6526375', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2402332, 6528314, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 63960798, 2449700, 2784197, 2002, null, null, 2200, 487848, 50467, '2018-02-07 17:05:42', null, '6528314', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2402374, 6528752, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 63967363, 2449749, 2784257, 2002, null, null, 2201, 488265, 50467, '2018-02-08 11:00:02', null, '6528752', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2402173, 6529216, 0, '2500-01-01 00:00:00', '2018-03-29 00:00:00', 63971655, 2449494, 2784340, 2002, null, null, 2200, 486936, 52582, '2018-02-08 15:21:57', null, '6529216', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2402620, 6530617, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 63985751, 2450014, 2784554, 2002, null, null, 2200, 489727, 50467, '2018-02-09 16:46:40', null, '6530617', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2402620, 6530618, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 63985753, 2450014, 2784554, 2002, 6530617, null, 2174, 489727, 50467, '2018-02-09 16:46:40', null, '6530618', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2402620, 6530619, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 63985777, 2450014, 2784555, 2020, null, null, 2220, 489727, 50467, '2018-02-09 16:46:44', null, '6530619', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2402645, 6530841, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 63989293, 2450042, 2784556, 2002, null, null, 2201, 490026, 50467, '2018-02-10 15:04:24', null, '6530841', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533907, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046237, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533907', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533908, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046238, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533908', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533909, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046239, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533909', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533910, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046240, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533910', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533911, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046241, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533911', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533912, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046242, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533912', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533913, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046243, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533913', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533914, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046244, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533914', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533915, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046245, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533915', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533916, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046246, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533916', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533917, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046247, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533917', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533918, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046248, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533918', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533919, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046249, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533919', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533920, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046250, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533920', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533921, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046251, 2447808, 2782144, 2472, 6514031, null, 2577, 493939, 2112, '2018-02-15 17:04:56', null, '6533921', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533922, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046252, 2447808, 2782144, 2472, 6514031, null, 2578, 493939, 2112, '2018-02-15 17:04:56', null, '6533922', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533923, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046253, 2447808, 2782144, 2472, 6514031, null, 2578, 493939, 2112, '2018-02-15 17:04:56', null, '6533923', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533924, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046254, 2447808, 2782144, 2472, 6514031, null, 2578, 493939, 2112, '2018-02-15 17:04:56', null, '6533924', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2403224, 6534719, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64056323, 2450807, 2785312, 2002, null, null, 2200, 494780, 47907, '2018-02-16 11:01:49', null, '6534719', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2403536, 6537947, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64095384, 2451187, 2785753, 2002, null, null, 2200, 497330, 50467, '2018-02-20 09:48:47', null, '6537947', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2403549, 6538090, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64096926, 2451214, 2785784, 2002, null, null, 2201, 497398, 50467, '2018-02-20 10:33:02', null, '6538090', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2357326, 6541789, 0, '2500-01-01 00:00:00', '2018-02-26 13:49:29', 64138904, 2395889, 2723721, 2468, 6008138, null, 2452, null, 2, '2018-02-26 13:49:29', null, '6541789', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2370776, 6541790, 0, '2500-01-01 00:00:00', '2018-02-26 13:49:31', 64138910, 2411980, 2742252, 2531, 6174952, null, 2452, null, 2, '2018-02-26 13:49:31', null, '6541790', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2378650, 6541791, 0, '2500-01-01 00:00:00', '2018-02-26 13:49:32', 64138912, 2420162, 2751956, 2525, 6250112, null, 2452, null, 2, '2018-02-26 13:49:32', null, '6541791', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2394845, 6541795, 0, '2018-02-28 16:57:26', '2018-02-28 16:56:10', 64277082, 2437050, 2770633, 2525, 6424871, null, 2869, 501346, 2, '2018-02-28 16:56:10', null, '6541795', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2394845, 6541795, 0, '2500-01-01 00:00:00', '2018-02-28 16:57:26', 64277085, 2437050, 2770633, 2525, 6424871, null, 2869, 501349, 2, '2018-02-28 16:57:26', null, '6541795', 'D', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2394845, 6541796, 0, '2500-01-01 00:00:00', '2018-02-28 16:57:50', 64277086, 2437050, 2770633, 2525, 6424871, null, 2871, 501350, 2, '2018-02-28 16:57:50', null, '6541796', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2404007, 6541814, 0, '2500-01-01 00:00:00', '2018-04-01 00:00:00', 64283115, 2451719, 2786324, 2401, null, null, 2767, 501918, 2, '2018-03-02 17:34:13', null, '6541814', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2404008, 6541834, 0, '2500-01-01 00:00:00', '2018-04-01 00:00:00', 64292088, 2451738, 2786325, 2401, null, null, 2767, 502766, 2, '2018-03-05 17:57:45', null, '6541834', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1660299, 6541854, 0, '2500-01-01 00:00:00', '2018-03-23 00:00:00', 64345672, 1615680, 2786340, 2002, null, null, 2767, 507719, 51137, '2018-03-23 09:32:33', null, '6541854', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1806895, 3526930, 0, '2500-01-01 00:00:00', '2016-05-01 00:00:00', 20519992, 1522671, 1467218, 2002, null, null, 2222, null, 2, '2015-06-13 01:05:21', null, '26095', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1829008, 3528932, 0, '2500-01-01 00:00:00', '2015-03-21 00:00:00', 20523994, 1528972, 1469218, 2002, null, null, 2222, null, 2, '2015-06-13 01:05:26', null, '30865', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1820969, 3536727, 0, '2016-06-02 00:00:00', '2015-05-27 00:00:00', 20539564, 1560581, 1476993, 2002, null, null, 2225, null, 2, '2015-06-13 01:05:44', null, '48956', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1820969, 3536727, 0, '2500-01-01 00:00:00', '2016-06-02 00:00:00', 50307712, 1560581, 1476993, 2002, null, null, 2225, 179640, 2122, '2016-06-14 14:42:28', null, '3536727', 'D', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1806083, 3539565, 0, '2500-01-01 00:00:00', '2016-11-04 00:00:00', 20545229, 1508124, 1479820, 2002, null, null, 2227, null, 2, '2015-06-13 01:05:49', null, '55507', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1819660, 3539955, 0, '2016-02-12 00:00:00', '2015-05-01 00:00:00', 20546008, 1542651, 1480209, 2002, null, null, 2223, null, 2, '2015-06-13 01:05:50', null, '56370', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1819660, 3539955, 0, '2500-01-01 00:00:00', '2016-02-12 00:00:00', 47787369, 1542651, 1480209, 2002, null, null, 2223, 115044, 2, '2016-03-02 11:33:03', null, '3539955', 'D', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1812729, 3541863, 0, '2016-04-28 00:00:00', '2015-05-01 00:00:00', 20549816, 1541780, 1482109, 2002, null, null, 2205, null, 2, '2015-11-06 12:35:41', null, '60647', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1812729, 3541863, 0, '2500-01-01 00:00:00', '2016-04-28 00:00:00', 49654276, 1541780, 1482109, 2002, null, null, 2205, 162865, 2476, '2016-05-18 10:40:13', null, '3541863', 'D', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1712353, 3548122, 0, '2016-02-01 00:00:00', '2015-05-01 00:00:00', 20562314, 1438194, 1488348, 2002, null, null, 2221, null, 2, '2015-06-13 01:06:08', null, '75238', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1712353, 3548122, 0, '2500-01-01 00:00:00', '2016-02-01 00:00:00', 47848989, 1438194, 1488348, 2043, null, null, 2221, 117984, 2088, '2016-03-03 16:21:12', null, '75238', 'A', null);


insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1849215, 3548337, 0, '2015-07-15 00:00:00', '2015-05-01 00:00:00', 20562744, 1577920, 1488563, 2002, null, null, 2221, null, 2, '2015-06-13 01:06:09', null, '75757', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1849215, 3548337, 0, '2500-01-01 00:00:00', '2016-02-01 00:00:00', 47841158, 1577920, 1488563, 2043, null, null, 2221, 117597, 2088, '2016-03-03 15:09:28', null, '75757', 'D', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1849215, 3548337, 0, '2016-02-01 00:00:00', '2015-07-15 00:00:00', 49845459, 1577920, 1488563, 2002, null, null, 2221, 166847, 2599, '2016-05-23 13:45:20', null, '3548337', 'D', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1712724, 3550139, 0, '2016-08-21 00:00:00', '2015-05-01 00:00:00', 20566347, 1436772, 1490364, 2002, null, null, 2225, null, 2, '2015-06-13 01:06:14', null, '79449', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (1712724, 3550139, 0, '2500-01-01 00:00:00', '2016-08-21 00:00:00', 54394328, 1436772, 1490364, 2002, null, null, 2225, 224804, 2200, '2016-09-19 14:17:17', null, '3550139', 'D', null);


insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6514031, 0, '2500-01-01 00:00:00', '2018-01-01 00:00:00', 63785387, 2447808, 2782144, 2472, null, null, 2576, 478423, 2112, '2018-01-29 15:59:22', null, '6514031', 'A', null);

insert into fw_services (ID_CONTRACT_INST, ID_SERVICE_INST, B_DELETED, DT_STOP, DT_START, ID_REC, ID_SUBSCRIBER_INST, ID_PRODUCT_INST, ID_TARIFF_PLAN, ID_PARENT_INST, ID_DEPENDENCY_INST, ID_SERVICE, ID_FLOW, ID_MANAGER, DT_UPDATED, DT_PLAN, V_EXT_IDENT, V_STATUS, DT_INIT)
values (2400969, 6533924, 0, '2500-01-01 00:00:00', '2018-03-01 00:00:00', 64046254, 2447808, 2782144, 2472, 6514031, null, 2578, 493939, 2112, '2018-02-15 17:04:56', null, '6533924', 'A', null);

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397072, 4, '73656634347', 'U', null, 0, '3397072');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397073, 4, '73656634348', 'U', null, 0, '3397073');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397074, 4, '73656634349', 'U', null, 0, '3397074');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397075, 4, '73656634350', 'U', null, 0, '3397075');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397076, 4, '73656634351', 'U', null, 0, '3397076');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397077, 4, '73656634352', 'U', null, 0, '3397077');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397078, 4, '73656634353', 'U', null, 0, '3397078');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397079, 4, '73656634354', 'U', null, 0, '3397079');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397080, 4, '73656634355', 'U', null, 0, '3397080');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397081, 4, '73656634356', 'U', null, 0, '3397081');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397082, 4, '73656634357', 'U', null, 0, '3397082');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397083, 4, '73656634358', 'U', null, 0, '3397083');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397084, 4, '73656634359', 'U', null, 0, '3397084');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397085, 4, '73656634360', 'U', null, 0, '3397085');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397086, 4, '73656634361', 'U', null, 0, '3397086');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397087, 4, '73656634362', 'U', null, 0, '3397087');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397088, 4, '73656634363', 'U', null, 0, '3397088');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397089, 4, '73656634364', 'U', null, 0, '3397089');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397090, 4, '73656634365', 'U', null, 0, '3397090');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397091, 4, '73656634366', 'U', null, 0, '3397091');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397092, 4, '73656634367', 'U', null, 0, '3397092');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397093, 4, '73656634368', 'U', null, 0, '3397093');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397094, 4, '73656634369', 'U', null, 0, '3397094');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397095, 4, '73656634370', 'U', null, 0, '3397095');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397096, 4, '73656634371', 'U', null, 0, '3397096');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397097, 4, '73656634372', 'U', null, 0, '3397097');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397098, 4, '73656634373', 'U', null, 0, '3397098');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397099, 4, '73656634374', 'U', null, 0, '3397099');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397100, 4, '73656634375', 'U', null, 0, '3397100');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397101, 4, '73656634376', 'U', null, 0, '3397101');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397102, 4, '73656634377', 'U', null, 0, '3397102');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397103, 4, '73656634378', 'U', null, 0, '3397103');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397104, 4, '73656634379', 'U', null, 0, '3397104');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397105, 4, '73656634380', 'U', null, 0, '3397105');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397106, 4, '73656634381', 'U', null, 0, '3397106');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397107, 4, '73656634382', 'U', null, 0, '3397107');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397108, 4, '73656634383', 'U', null, 0, '3397108');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397109, 4, '73656634384', 'U', null, 0, '3397109');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397110, 4, '73656634385', 'U', null, 0, '3397110');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397111, 4, '73656634386', 'U', null, 0, '3397111');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397112, 4, '73656634387', 'U', null, 0, '3397112');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397113, 4, '73656634388', 'U', null, 0, '3397113');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397114, 4, '73656634389', 'U', null, 0, '3397114');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397115, 4, '73656634390', 'U', null, 0, '3397115');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397116, 4, '73656634391', 'U', null, 0, '3397116');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397117, 4, '73656634392', 'U', null, 0, '3397117');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397118, 4, '73656634393', 'U', null, 0, '3397118');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397119, 4, '73656634394', 'U', null, 0, '3397119');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397120, 4, '73656634395', 'N', null, 0, '3397120');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397121, 4, '73656634396', 'U', null, 0, '3397121');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397122, 4, '73656634397', 'U', null, 0, '3397122');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397123, 4, '73656634398', 'U', null, 0, '3397123');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397124, 4, '73656634399', 'U', null, 0, '3397124');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397125, 4, '73656634400', 'U', null, 0, '3397125');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397126, 4, '73656634401', 'U', null, 0, '3397126');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397127, 4, '73656634402', 'U', null, 0, '3397127');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397128, 4, '73656634403', 'N', null, 0, '3397128');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397129, 4, '73656634404', 'U', null, 0, '3397129');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397130, 4, '73656634405', 'U', null, 0, '3397130');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397131, 4, '73656634406', 'U', null, 0, '3397131');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397132, 4, '73656634407', 'U', null, 0, '3397132');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397133, 4, '73656634408', 'U', null, 0, '3397133');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397134, 4, '73656634409', 'U', null, 0, '3397134');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397135, 4, '73656634410', 'U', null, 0, '3397135');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397136, 4, '73656634411', 'U', null, 0, '3397136');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397137, 4, '73656634412', 'U', null, 0, '3397137');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397138, 4, '73656634413', 'U', null, 0, '3397138');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397139, 4, '73656634414', 'U', null, 0, '3397139');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397140, 4, '73656634415', 'U', null, 0, '3397140');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397141, 4, '73656634416', 'U', null, 0, '3397141');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397142, 4, '73656634417', 'U', null, 0, '3397142');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397143, 4, '73656634418', 'U', null, 0, '3397143');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397144, 4, '73656634419', 'U', null, 0, '3397144');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397145, 4, '73656634420', 'U', null, 0, '3397145');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397146, 4, '73656634421', 'U', null, 0, '3397146');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397147, 4, '73656634422', 'U', null, 0, '3397147');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397148, 4, '73656634423', 'U', null, 0, '3397148');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397149, 4, '73656634424', 'U', null, 0, '3397149');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397150, 4, '73656634425', 'U', null, 0, '3397150');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397151, 4, '73656634426', 'U', null, 0, '3397151');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397152, 4, '73656634427', 'U', null, 0, '3397152');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397153, 4, '73656634428', 'U', null, 0, '3397153');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397154, 4, '73656634429', 'U', null, 0, '3397154');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397155, 4, '73656634430', 'U', null, 0, '3397155');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397156, 4, '73656634431', 'U', null, 0, '3397156');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397157, 4, '73656634432', 'U', null, 0, '3397157');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397158, 4, '73656634433', 'U', null, 0, '3397158');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397159, 4, '73656634434', 'U', null, 0, '3397159');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397160, 4, '73656634435', 'U', null, 0, '3397160');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397161, 4, '73656634436', 'U', null, 0, '3397161');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397162, 4, '73656634437', 'U', null, 0, '3397162');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397163, 4, '73656634438', 'N', null, 0, '3397163');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397164, 4, '73656634439', 'N', null, 0, '3397164');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397165, 4, '73656634440', 'U', null, 0, '3397165');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397166, 4, '73656634441', 'U', null, 0, '3397166');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397167, 4, '73656634442', 'U', null, 0, '3397167');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397168, 4, '73656634443', 'U', null, 0, '3397168');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397169, 4, '73656634444', 'U', null, 0, '3397169');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397170, 4, '73656634445', 'U', null, 0, '3397170');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397171, 4, '73656634446', 'U', null, 0, '3397171');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397172, 4, '73656634447', 'U', null, 0, '3397172');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397173, 4, '73656634448', 'U', null, 0, '3397173');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397174, 4, '73656634449', 'U', null, 0, '3397174');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397175, 4, '73656634450', 'U', null, 0, '3397175');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397176, 4, '73656634451', 'U', null, 0, '3397176');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397177, 4, '73656634452', 'U', null, 0, '3397177');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397178, 4, '73656634453', 'U', null, 0, '3397178');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397179, 4, '73656634454', 'U', null, 0, '3397179');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397180, 4, '73656634455', 'U', null, 0, '3397180');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397181, 4, '73656634456', 'U', null, 0, '3397181');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397182, 4, '73656634457', 'U', null, 0, '3397182');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397183, 4, '73656634458', 'U', null, 0, '3397183');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397184, 4, '73656634459', 'U', null, 0, '3397184');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397185, 4, '73656634460', 'U', null, 0, '3397185');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397186, 4, '73656634461', 'U', null, 0, '3397186');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397187, 4, '73656634462', 'U', null, 0, '3397187');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397188, 4, '73656634463', 'U', null, 0, '3397188');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397189, 4, '73656634464', 'U', null, 0, '3397189');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397190, 4, '73656634465', 'U', null, 0, '3397190');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397191, 4, '73656634466', 'U', null, 0, '3397191');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397192, 4, '73656634467', 'N', null, 0, '3397192');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397193, 4, '73656634468', 'U', null, 0, '3397193');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397194, 4, '73656634469', 'U', null, 0, '3397194');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397195, 4, '73656634470', 'U', null, 0, '3397195');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397196, 4, '73656634471', 'U', null, 0, '3397196');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397197, 4, '73656634472', 'U', null, 0, '3397197');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397198, 4, '73656634473', 'U', null, 0, '3397198');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397199, 4, '73656634474', 'U', null, 0, '3397199');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397200, 4, '73656634475', 'U', null, 0, '3397200');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397201, 4, '73656634476', 'U', null, 0, '3397201');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397202, 4, '73656634477', 'U', null, 0, '3397202');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397203, 4, '73656634478', 'U', null, 0, '3397203');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397204, 4, '73656634479', 'U', null, 0, '3397204');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397205, 4, '73656634480', 'U', null, 0, '3397205');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397206, 4, '73656634481', 'U', null, 0, '3397206');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397207, 4, '73656634482', 'U', null, 0, '3397207');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397208, 4, '73656634483', 'U', null, 0, '3397208');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397209, 4, '73656634484', 'U', null, 0, '3397209');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397210, 4, '73656634485', 'U', null, 0, '3397210');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397211, 4, '73656634486', 'U', null, 0, '3397211');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397212, 4, '73656634487', 'U', null, 0, '3397212');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397213, 4, '73656634488', 'U', null, 0, '3397213');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397214, 4, '73656634489', 'U', null, 0, '3397214');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397215, 4, '73656634490', 'U', null, 0, '3397215');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397216, 4, '73656634491', 'U', null, 0, '3397216');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397217, 4, '73656634492', 'U', null, 0, '3397217');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397218, 4, '73656634493', 'U', null, 0, '3397218');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397219, 4, '73656634494', 'U', null, 0, '3397219');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397220, 4, '73656634495', 'U', null, 0, '3397220');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397221, 4, '73656634496', 'U', null, 0, '3397221');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397222, 4, '73656634497', 'U', null, 0, '3397222');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397223, 4, '73656634498', 'U', null, 0, '3397223');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397224, 4, '73656634499', 'U', null, 0, '3397224');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397225, 4, '73656634500', 'U', null, 0, '3397225');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397226, 4, '73656634501', 'U', null, 0, '3397226');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397227, 4, '73656634502', 'U', null, 0, '3397227');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397228, 4, '73656634503', 'U', null, 0, '3397228');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397229, 4, '73656634504', 'U', null, 0, '3397229');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397230, 4, '73656634505', 'U', null, 0, '3397230');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397231, 4, '73656634506', 'U', null, 0, '3397231');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397232, 4, '73656634507', 'U', null, 0, '3397232');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397233, 4, '73656634508', 'U', null, 0, '3397233');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397234, 4, '73656634509', 'U', null, 0, '3397234');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397235, 4, '73656634510', 'U', null, 0, '3397235');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397236, 4, '73656634511', 'U', null, 0, '3397236');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397237, 4, '73656634512', 'U', null, 0, '3397237');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397238, 4, '73656634513', 'U', null, 0, '3397238');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397239, 4, '73656634514', 'U', null, 0, '3397239');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397240, 4, '73656634515', 'U', null, 0, '3397240');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397241, 4, '73656634516', 'U', null, 0, '3397241');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3397242, 4, '73656634517', 'U', null, 0, '3397242');



insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457103, 4, '73652507900', 'N', null, 0, '3457103');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457104, 4, '73652507901', 'N', null, 0, '3457104');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457105, 4, '73652507902', 'N', null, 0, '3457105');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457106, 4, '73652507903', 'N', null, 0, '3457106');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457107, 4, '73652507904', 'N', null, 0, '3457107');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457108, 4, '73652507905', 'N', null, 0, '3457108');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457109, 4, '73652507906', 'N', null, 0, '3457109');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457110, 4, '73652507907', 'N', null, 0, '3457110');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457111, 4, '73652507908', 'N', null, 0, '3457111');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457112, 4, '73652507909', 'N', null, 0, '3457112');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457113, 4, '73652507910', 'N', null, 0, '3457113');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457114, 4, '73652507911', 'N', null, 0, '3457114');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457115, 4, '73652507912', 'N', null, 0, '3457115');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457116, 4, '73652507913', 'N', null, 0, '3457116');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457117, 4, '73652507914', 'N', null, 0, '3457117');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457118, 4, '73652507915', 'N', null, 0, '3457118');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457119, 4, '73652507916', 'N', null, 0, '3457119');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457120, 4, '73652507917', 'N', null, 0, '3457120');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457121, 4, '73652507918', 'N', null, 0, '3457121');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457122, 4, '73652507919', 'N', null, 0, '3457122');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457123, 4, '73652507920', 'N', null, 0, '3457123');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457124, 4, '73652507921', 'N', null, 0, '3457124');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457125, 4, '73652507922', 'N', null, 0, '3457125');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457126, 4, '73652507923', 'N', null, 0, '3457126');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457127, 4, '73652507924', 'N', null, 0, '3457127');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457128, 4, '73652507925', 'N', null, 0, '3457128');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457129, 4, '73652507926', 'N', null, 0, '3457129');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457130, 4, '73652507927', 'N', null, 0, '3457130');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457131, 4, '73652507928', 'N', null, 0, '3457131');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457132, 4, '73652507929', 'N', null, 0, '3457132');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457133, 4, '73652507930', 'N', null, 0, '3457133');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457134, 4, '73652507931', 'N', null, 0, '3457134');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457135, 4, '73652507932', 'N', null, 0, '3457135');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457136, 4, '73652507933', 'N', null, 0, '3457136');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457137, 4, '73652507934', 'N', null, 0, '3457137');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457138, 4, '73652507935', 'N', null, 0, '3457138');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457139, 4, '73652507936', 'N', null, 0, '3457139');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457140, 4, '73652507937', 'N', null, 0, '3457140');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457141, 4, '73652507938', 'N', null, 0, '3457141');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457142, 4, '73652507939', 'N', null, 0, '3457142');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457143, 4, '73652507940', 'N', null, 0, '3457143');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457144, 4, '73652507941', 'N', null, 0, '3457144');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457145, 4, '73652507942', 'N', null, 0, '3457145');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457146, 4, '73652507943', 'N', null, 0, '3457146');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457147, 4, '73652507944', 'N', null, 0, '3457147');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457148, 4, '73652507945', 'N', null, 0, '3457148');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457149, 4, '73652507946', 'N', null, 0, '3457149');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457150, 4, '73652507947', 'N', null, 0, '3457150');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457151, 4, '73652507948', 'N', null, 0, '3457151');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457152, 4, '73652507949', 'N', null, 0, '3457152');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457153, 4, '73652507950', 'N', null, 0, '3457153');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457154, 4, '73652507951', 'N', null, 0, '3457154');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457155, 4, '73652507952', 'N', null, 0, '3457155');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457156, 4, '73652507953', 'N', null, 0, '3457156');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457157, 4, '73652507954', 'N', null, 0, '3457157');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457158, 4, '73652507955', 'N', null, 0, '3457158');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457159, 4, '73652507956', 'N', null, 0, '3457159');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457160, 4, '73652507957', 'N', null, 0, '3457160');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457161, 4, '73652507958', 'N', null, 0, '3457161');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457162, 4, '73652507959', 'N', null, 0, '3457162');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457163, 4, '73652507960', 'N', null, 0, '3457163');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457164, 4, '73652507961', 'N', null, 0, '3457164');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457165, 4, '73652507962', 'N', null, 0, '3457165');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457166, 4, '73652507963', 'N', null, 0, '3457166');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457167, 4, '73652507964', 'N', null, 0, '3457167');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457168, 4, '73652507965', 'N', null, 0, '3457168');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457169, 4, '73652507966', 'N', null, 0, '3457169');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457170, 4, '73652507967', 'N', null, 0, '3457170');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457171, 4, '73652507968', 'N', null, 0, '3457171');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457172, 4, '73652507969', 'N', null, 0, '3457172');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457173, 4, '73652507970', 'N', null, 0, '3457173');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457174, 4, '73652507971', 'N', null, 0, '3457174');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457175, 4, '73652507972', 'N', null, 0, '3457175');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457176, 4, '73652507973', 'N', null, 0, '3457176');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457177, 4, '73652507974', 'N', null, 0, '3457177');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457178, 4, '73652507975', 'N', null, 0, '3457178');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457179, 4, '73652507976', 'N', null, 0, '3457179');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457180, 4, '73652507977', 'N', null, 0, '3457180');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457181, 4, '73652507978', 'N', null, 0, '3457181');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457182, 4, '73652507979', 'N', null, 0, '3457182');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457183, 4, '73652507980', 'N', null, 0, '3457183');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457184, 4, '73652507981', 'N', null, 0, '3457184');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457185, 4, '73652507982', 'N', null, 0, '3457185');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457186, 4, '73652507983', 'N', null, 0, '3457186');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457187, 4, '73652507984', 'N', null, 0, '3457187');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457188, 4, '73652507985', 'N', null, 0, '3457188');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457189, 4, '73652507986', 'N', null, 0, '3457189');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457190, 4, '73652507987', 'N', null, 0, '3457190');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457191, 4, '73652507988', 'N', null, 0, '3457191');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457192, 4, '73652507989', 'N', null, 0, '3457192');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457193, 4, '73652507990', 'N', null, 0, '3457193');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457194, 4, '73652507991', 'N', null, 0, '3457194');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457195, 4, '73652507992', 'N', null, 0, '3457195');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457196, 4, '73652507993', 'N', null, 0, '3457196');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457197, 4, '73652507994', 'N', null, 0, '3457197');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457198, 4, '73652507995', 'N', null, 0, '3457198');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457199, 4, '73652507996', 'N', null, 0, '3457199');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457200, 4, '73652507997', 'N', null, 0, '3457200');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457201, 4, '73652507998', 'N', null, 0, '3457201');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457202, 4, '73652507999', 'N', null, 0, '3457202');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457203, 4, '73652508000', 'N', null, 0, '3457203');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457204, 4, '73652508001', 'N', null, 0, '3457204');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457205, 4, '73652508002', 'N', null, 0, '3457205');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457206, 4, '73652508003', 'N', null, 0, '3457206');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457207, 4, '73652508004', 'N', null, 0, '3457207');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457208, 4, '73652508005', 'N', null, 0, '3457208');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457209, 4, '73652508006', 'N', null, 0, '3457209');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457210, 4, '73652508007', 'N', null, 0, '3457210');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457211, 4, '73652508008', 'N', null, 0, '3457211');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457212, 4, '73652508009', 'N', null, 0, '3457212');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457213, 4, '73652508010', 'N', null, 0, '3457213');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457214, 4, '73652508011', 'N', null, 0, '3457214');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457215, 4, '73652508012', 'N', null, 0, '3457215');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457216, 4, '73652508013', 'N', null, 0, '3457216');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457217, 4, '73652508014', 'N', null, 0, '3457217');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457218, 4, '73652508015', 'N', null, 0, '3457218');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457219, 4, '73652508016', 'N', null, 0, '3457219');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457220, 4, '73652508017', 'N', null, 0, '3457220');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457221, 4, '73652508018', 'N', null, 0, '3457221');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457222, 4, '73652508019', 'N', null, 0, '3457222');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457223, 4, '73652508020', 'N', null, 0, '3457223');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457224, 4, '73652508021', 'N', null, 0, '3457224');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457225, 4, '73652508022', 'N', null, 0, '3457225');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457226, 4, '73652508023', 'N', null, 0, '3457226');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457227, 4, '73652508024', 'N', null, 0, '3457227');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457228, 4, '73652508025', 'N', null, 0, '3457228');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457229, 4, '73652508026', 'N', null, 0, '3457229');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457230, 4, '73652508027', 'N', null, 0, '3457230');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457231, 4, '73652508028', 'N', null, 0, '3457231');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457232, 4, '73652508029', 'N', null, 0, '3457232');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457233, 4, '73652508030', 'N', null, 0, '3457233');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457234, 4, '73652508031', 'N', null, 0, '3457234');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457235, 4, '73652508032', 'N', null, 0, '3457235');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457236, 4, '73652508033', 'N', null, 0, '3457236');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457237, 4, '73652508034', 'N', null, 0, '3457237');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457238, 4, '73652508035', 'N', null, 0, '3457238');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457239, 4, '73652508036', 'N', null, 0, '3457239');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457240, 4, '73652508037', 'N', null, 0, '3457240');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457241, 4, '73652508038', 'N', null, 0, '3457241');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457242, 4, '73652508039', 'N', null, 0, '3457242');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457243, 4, '73652508040', 'N', null, 0, '3457243');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457244, 4, '73652508041', 'N', null, 0, '3457244');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457245, 4, '73652508042', 'N', null, 0, '3457245');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457246, 4, '73652508043', 'N', null, 0, '3457246');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457247, 4, '73652508044', 'N', null, 0, '3457247');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457248, 4, '73652508045', 'N', null, 0, '3457248');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457249, 4, '73652508046', 'N', null, 0, '3457249');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457250, 4, '73652508047', 'N', null, 0, '3457250');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457251, 4, '73652508048', 'N', null, 0, '3457251');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457252, 4, '73652508049', 'N', null, 0, '3457252');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457253, 4, '73652508050', 'N', null, 0, '3457253');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457254, 4, '73652508051', 'N', null, 0, '3457254');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457255, 4, '73652508052', 'N', null, 0, '3457255');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457256, 4, '73652508053', 'N', null, 0, '3457256');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457257, 4, '73652508054', 'N', null, 0, '3457257');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457258, 4, '73652508055', 'N', null, 0, '3457258');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457259, 4, '73652508056', 'N', null, 0, '3457259');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457260, 4, '73652508057', 'N', null, 0, '3457260');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457261, 4, '73652508058', 'N', null, 0, '3457261');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457262, 4, '73652508059', 'N', null, 0, '3457262');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457263, 4, '73652508060', 'N', null, 0, '3457263');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457264, 4, '73652508061', 'N', null, 0, '3457264');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457265, 4, '73652508062', 'N', null, 0, '3457265');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457266, 4, '73652508063', 'N', null, 0, '3457266');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457267, 4, '73652508064', 'N', null, 0, '3457267');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457268, 4, '73652508065', 'N', null, 0, '3457268');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457269, 4, '73652508066', 'N', null, 0, '3457269');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457270, 4, '73652508067', 'N', null, 0, '3457270');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457271, 4, '73652508068', 'N', null, 0, '3457271');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457272, 4, '73652508069', 'N', null, 0, '3457272');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457273, 4, '73652508070', 'N', null, 0, '3457273');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457274, 4, '73652508071', 'N', null, 0, '3457274');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457275, 4, '73652508072', 'N', null, 0, '3457275');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457276, 4, '73652508073', 'N', null, 0, '3457276');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457277, 4, '73652508074', 'N', null, 0, '3457277');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457278, 4, '73652508075', 'N', null, 0, '3457278');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457279, 4, '73652508076', 'N', null, 0, '3457279');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457280, 4, '73652508077', 'N', null, 0, '3457280');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457281, 4, '73652508078', 'N', null, 0, '3457281');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457282, 4, '73652508079', 'N', null, 0, '3457282');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457283, 4, '73652508080', 'N', null, 0, '3457283');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457284, 4, '73652508081', 'N', null, 0, '3457284');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457285, 4, '73652508082', 'N', null, 0, '3457285');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457286, 4, '73652508083', 'N', null, 0, '3457286');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457287, 4, '73652508084', 'N', null, 0, '3457287');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457288, 4, '73652508085', 'N', null, 0, '3457288');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457289, 4, '73652508086', 'N', null, 0, '3457289');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457290, 4, '73652508087', 'N', null, 0, '3457290');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457291, 4, '73652508088', 'N', null, 0, '3457291');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457292, 4, '73652508089', 'N', null, 0, '3457292');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457293, 4, '73652508090', 'N', null, 0, '3457293');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457294, 4, '73652508091', 'N', null, 0, '3457294');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457295, 4, '73652508092', 'N', null, 0, '3457295');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457296, 4, '73652508093', 'N', null, 0, '3457296');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457297, 4, '73652508094', 'N', null, 0, '3457297');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457298, 4, '73652508095', 'N', null, 0, '3457298');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457299, 4, '73652508096', 'N', null, 0, '3457299');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457300, 4, '73652508097', 'N', null, 0, '3457300');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457301, 4, '73652508098', 'N', null, 0, '3457301');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457302, 4, '73652508099', 'N', null, 0, '3457302');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457303, 4, '73652508100', 'N', null, 0, '3457303');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457304, 4, '73652508101', 'N', null, 0, '3457304');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457305, 4, '73652508102', 'N', null, 0, '3457305');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457306, 4, '73652508103', 'N', null, 0, '3457306');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457307, 4, '73652508104', 'N', null, 0, '3457307');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3457308, 4, '73652508105', 'N', null, 0, '3457308');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428329, 4, '73656935455', 'U', null, 0, '3428329');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428330, 4, '73656935456', 'N', null, 0, '3428330');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428331, 4, '73656935457', 'U', null, 0, '3428331');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428332, 4, '73656935458', 'U', null, 0, '3428332');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428333, 4, '73656935459', 'N', null, 0, '3428333');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428334, 4, '73656935460', 'U', null, 0, '3428334');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428335, 4, '73656935461', 'U', null, 0, '3428335');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428336, 4, '73656935462', 'U', null, 0, '3428336');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428337, 4, '73656935463', 'U', null, 0, '3428337');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428338, 4, '73656935464', 'U', null, 0, '3428338');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428339, 4, '73656935465', 'U', null, 0, '3428339');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428340, 4, '73656935466', 'N', null, 0, '3428340');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428341, 4, '73656935467', 'N', null, 0, '3428341');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428342, 4, '73656935468', 'U', null, 0, '3428342');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428343, 4, '73656935469', 'U', null, 0, '3428343');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428344, 4, '73656936559', 'U', null, 0, '3428344');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428345, 4, '73656936560', 'U', null, 0, '3428345');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428346, 4, '73656936561', 'N', null, 0, '3428346');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428347, 4, '73656936562', 'N', null, 0, '3428347');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428348, 4, '73656936563', 'U', null, 0, '3428348');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428349, 4, '73656936564', 'N', null, 0, '3428349');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428350, 4, '73656936565', 'N', null, 0, '3428350');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428351, 4, '73656936566', 'U', null, 0, '3428351');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428352, 4, '73656936567', 'U', null, 0, '3428352');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428353, 4, '73656936568', 'U', null, 0, '3428353');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428354, 4, '73656936569', 'N', null, 0, '3428354');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428355, 4, '73656936570', 'N', null, 0, '3428355');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428356, 4, '73656936571', 'U', null, 0, '3428356');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428357, 4, '73656936572', 'U', null, 0, '3428357');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428358, 4, '73656936573', 'U', null, 0, '3428358');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428359, 4, '73656936574', 'U', null, 0, '3428359');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428360, 4, '73656936575', 'N', null, 0, '3428360');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428361, 4, '73656936576', 'N', null, 0, '3428361');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428362, 4, '73656936577', 'U', null, 0, '3428362');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428363, 4, '73656936578', 'U', null, 0, '3428363');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428364, 4, '73656936579', 'N', null, 0, '3428364');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428365, 4, '73656936580', 'U', null, 0, '3428365');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428366, 4, '73656936581', 'U', null, 0, '3428366');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428367, 4, '73656936582', 'U', null, 0, '3428367');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428368, 4, '73656936583', 'N', null, 0, '3428368');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428369, 4, '73656936584', 'U', null, 0, '3428369');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428370, 4, '73656936585', 'U', null, 0, '3428370');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428371, 4, '73656936586', 'N', null, 0, '3428371');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428372, 4, '73656936587', 'N', null, 0, '3428372');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428373, 4, '73656936588', 'U', null, 0, '3428373');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428374, 4, '73656936589', 'U', null, 0, '3428374');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428375, 4, '73656936590', 'U', null, 0, '3428375');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428376, 4, '73656936591', 'U', null, 0, '3428376');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428377, 4, '73656960502', 'N', null, 0, '3428377');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428378, 4, '73656960503', 'N', null, 0, '3428378');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428379, 4, '73656960504', 'U', null, 0, '3428379');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428380, 4, '73656960505', 'N', null, 0, '3428380');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428381, 4, '73656960506', 'U', null, 0, '3428381');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428382, 4, '73656960507', 'N', null, 0, '3428382');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428383, 4, '73656960508', 'U', null, 0, '3428383');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428384, 4, '73656960509', 'U', null, 0, '3428384');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428385, 4, '73656960510', 'U', null, 0, '3428385');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428386, 4, '73656960511', 'U', null, 0, '3428386');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428387, 4, '73656960512', 'U', null, 0, '3428387');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428388, 4, '73656960513', 'U', null, 0, '3428388');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428389, 4, '73656960514', 'U', null, 0, '3428389');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428390, 4, '73656960515', 'U', null, 0, '3428390');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428391, 4, '73656960516', 'U', null, 0, '3428391');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428392, 4, '73656960517', 'U', null, 0, '3428392');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428393, 4, '73656960518', 'N', null, 0, '3428393');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428394, 4, '73656960519', 'U', null, 0, '3428394');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428395, 4, '73656960520', 'U', null, 0, '3428395');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428396, 4, '73656960521', 'N', null, 0, '3428396');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428397, 4, '73656960522', 'U', null, 0, '3428397');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428398, 4, '73656960523', 'U', null, 0, '3428398');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428399, 4, '73656960524', 'U', null, 0, '3428399');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428400, 4, '73656960525', 'U', null, 0, '3428400');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428401, 4, '73656960526', 'U', null, 0, '3428401');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428402, 4, '73656960527', 'N', null, 0, '3428402');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428403, 4, '73656960528', 'U', null, 0, '3428403');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428404, 4, '73656960529', 'N', null, 0, '3428404');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428405, 4, '73656960530', 'N', null, 0, '3428405');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428406, 4, '73656960531', 'N', null, 0, '3428406');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428407, 4, '73656960532', 'N', null, 0, '3428407');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428408, 4, '73656960533', 'U', null, 0, '3428408');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428409, 4, '73656960534', 'N', null, 0, '3428409');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428410, 4, '73656960535', 'U', null, 0, '3428410');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428411, 4, '73656960536', 'U', null, 0, '3428411');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428412, 4, '73656960537', 'U', null, 0, '3428412');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428413, 4, '73656960538', 'U', null, 0, '3428413');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428414, 4, '73656960539', 'U', null, 0, '3428414');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428415, 4, '73656960540', 'U', null, 0, '3428415');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428416, 4, '73656960541', 'N', null, 0, '3428416');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428417, 4, '73656960542', 'U', null, 0, '3428417');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428418, 4, '73656960543', 'U', null, 0, '3428418');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428419, 4, '73656960544', 'U', null, 0, '3428419');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428420, 4, '73656960545', 'U', null, 0, '3428420');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428421, 4, '73656960546', 'N', null, 0, '3428421');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428422, 4, '73656960547', 'U', null, 0, '3428422');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428423, 4, '73656960548', 'U', null, 0, '3428423');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428424, 4, '73656960549', 'U', null, 0, '3428424');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428425, 4, '73656960550', 'U', null, 0, '3428425');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428426, 4, '73656960551', 'U', null, 0, '3428426');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428427, 4, '73656960552', 'U', null, 0, '3428427');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428428, 4, '73656960553', 'N', null, 0, '3428428');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428429, 4, '73656960554', 'U', null, 0, '3428429');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428430, 4, '73656960555', 'N', null, 0, '3428430');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428431, 4, '73656960556', 'U', null, 0, '3428431');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428432, 4, '73656960557', 'U', null, 0, '3428432');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428433, 4, '73656960558', 'U', null, 0, '3428433');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428434, 4, '73656960559', 'U', null, 0, '3428434');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428435, 4, '73656960560', 'U', null, 0, '3428435');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428436, 4, '73656960561', 'N', null, 0, '3428436');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428437, 4, '73656960562', 'U', null, 0, '3428437');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428438, 4, '73656960563', 'U', null, 0, '3428438');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428439, 4, '73656960564', 'U', null, 0, '3428439');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428440, 4, '73656960565', 'U', null, 0, '3428440');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428441, 4, '73656960566', 'U', null, 0, '3428441');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428442, 4, '73656960567', 'U', null, 0, '3428442');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428443, 4, '73656960568', 'U', null, 0, '3428443');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428444, 4, '73656960569', 'N', null, 0, '3428444');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428445, 4, '73656960570', 'U', null, 0, '3428445');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428446, 4, '73656960571', 'N', null, 0, '3428446');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428447, 4, '73656960572', 'N', null, 0, '3428447');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428448, 4, '73656960573', 'U', null, 0, '3428448');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428449, 4, '73656960574', 'U', null, 0, '3428449');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428450, 4, '73656960575', 'U', null, 0, '3428450');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428451, 4, '73656960576', 'N', null, 0, '3428451');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428452, 4, '73656960577', 'U', null, 0, '3428452');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428453, 4, '73656960578', 'N', null, 0, '3428453');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428454, 4, '73656960579', 'U', null, 0, '3428454');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428455, 4, '73656960580', 'U', null, 0, '3428455');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428456, 4, '73656960581', 'U', null, 0, '3428456');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428457, 4, '73656960582', 'U', null, 0, '3428457');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428458, 4, '73656960583', 'U', null, 0, '3428458');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428459, 4, '73656960584', 'N', null, 0, '3428459');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428460, 4, '73656960585', 'U', null, 0, '3428460');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428461, 4, '73656960586', 'U', null, 0, '3428461');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428462, 4, '73656960587', 'U', null, 0, '3428462');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428463, 4, '73656960588', 'U', null, 0, '3428463');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428464, 4, '73656960589', 'U', null, 0, '3428464');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428465, 4, '73656960590', 'U', null, 0, '3428465');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428466, 4, '73656960591', 'U', null, 0, '3428466');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428467, 4, '73656960592', 'U', null, 0, '3428467');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428468, 4, '73656960593', 'U', null, 0, '3428468');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428469, 4, '73656960594', 'U', null, 0, '3428469');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428470, 4, '73656960595', 'U', null, 0, '3428470');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428471, 4, '73656960596', 'U', null, 0, '3428471');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428472, 4, '73656960597', 'N', null, 0, '3428472');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428473, 4, '73656960598', 'U', null, 0, '3428473');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428474, 4, '73656960599', 'U', null, 0, '3428474');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428475, 4, '73656960600', 'U', null, 0, '3428475');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428476, 4, '73656960601', 'U', null, 0, '3428476');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428477, 4, '73656960602', 'U', null, 0, '3428477');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428478, 4, '73656960603', 'U', null, 0, '3428478');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428479, 4, '73656960604', 'U', null, 0, '3428479');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428480, 4, '73656960605', 'U', null, 0, '3428480');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428481, 4, '73656960606', 'N', null, 0, '3428481');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428482, 4, '73656960607', 'U', null, 0, '3428482');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428483, 4, '73656960608', 'U', null, 0, '3428483');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428484, 4, '73656960609', 'U', null, 0, '3428484');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428485, 4, '73656960610', 'N', null, 0, '3428485');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428486, 4, '73656960611', 'U', null, 0, '3428486');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428487, 4, '73656960612', 'N', null, 0, '3428487');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428488, 4, '73656960613', 'N', null, 0, '3428488');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428489, 4, '73656960614', 'U', null, 0, '3428489');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428490, 4, '73656960615', 'U', null, 0, '3428490');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428491, 4, '73656960616', 'N', null, 0, '3428491');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428492, 4, '73656960617', 'N', null, 0, '3428492');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428493, 4, '73656960618', 'N', null, 0, '3428493');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428494, 4, '73656960619', 'U', null, 0, '3428494');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428495, 4, '73656960620', 'U', null, 0, '3428495');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428496, 4, '73656960621', 'N', null, 0, '3428496');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428497, 4, '73656960622', 'N', null, 0, '3428497');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428498, 4, '73656960623', 'U', null, 0, '3428498');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428499, 4, '73656960624', 'U', null, 0, '3428499');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428500, 4, '73656960625', 'N', null, 0, '3428500');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428501, 4, '73656960626', 'N', null, 0, '3428501');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428502, 4, '73656960627', 'U', null, 0, '3428502');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428503, 4, '73656960628', 'U', null, 0, '3428503');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428504, 4, '73656960629', 'U', null, 0, '3428504');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428505, 4, '73656960630', 'U', null, 0, '3428505');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428506, 4, '73656960631', 'U', null, 0, '3428506');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428507, 4, '73656960632', 'U', null, 0, '3428507');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428508, 4, '73656960633', 'U', null, 0, '3428508');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428509, 4, '73656960634', 'U', null, 0, '3428509');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428510, 4, '73656960635', 'U', null, 0, '3428510');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428511, 4, '73656960636', 'U', null, 0, '3428511');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428512, 4, '73656960637', 'U', null, 0, '3428512');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428513, 4, '73656960638', 'U', null, 0, '3428513');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428514, 4, '73656960639', 'U', null, 0, '3428514');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428515, 4, '73656960640', 'U', null, 0, '3428515');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428516, 4, '73656960641', 'U', null, 0, '3428516');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428517, 4, '73656960642', 'U', null, 0, '3428517');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428518, 4, '73656960643', 'U', null, 0, '3428518');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428519, 4, '73656960644', 'U', null, 0, '3428519');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428520, 4, '73656960645', 'U', null, 0, '3428520');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428521, 4, '73656960646', 'N', null, 0, '3428521');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428522, 4, '73656960647', 'N', null, 0, '3428522');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428523, 4, '73656960648', 'U', null, 0, '3428523');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428524, 4, '73656960649', 'U', null, 0, '3428524');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428525, 4, '73656960650', 'U', null, 0, '3428525');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428526, 4, '73656960651', 'U', null, 0, '3428526');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428527, 4, '73656960652', 'U', null, 0, '3428527');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428528, 4, '73656960653', 'U', null, 0, '3428528');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428529, 4, '73656960654', 'U', null, 0, '3428529');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428530, 4, '73656960655', 'U', null, 0, '3428530');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428531, 4, '73656960656', 'N', null, 0, '3428531');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428532, 4, '73656960657', 'U', null, 0, '3428532');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428533, 4, '73656960658', 'U', null, 0, '3428533');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428534, 4, '73656960659', 'U', null, 0, '3428534');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3428535, 4, '73656960660', 'U', null, 0, '3428535');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431227, 4, '73656952443', 'U', null, 0, '3431227');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431228, 4, '73656952444', 'U', null, 0, '3431228');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431229, 4, '73656952445', 'U', null, 0, '3431229');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431230, 4, '73656952446', 'U', null, 0, '3431230');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431231, 4, '73656952447', 'U', null, 0, '3431231');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431232, 4, '73656952448', 'N', null, 0, '3431232');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431233, 4, '73656952449', 'N', null, 0, '3431233');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431234, 4, '73656952450', 'U', null, 0, '3431234');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431235, 4, '73656952451', 'N', null, 0, '3431235');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431236, 4, '73656952452', 'U', null, 0, '3431236');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431237, 4, '73656952453', 'U', null, 0, '3431237');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431238, 4, '73656957898', 'U', null, 0, '3431238');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431239, 4, '73656957899', 'U', null, 0, '3431239');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431240, 4, '73656957900', 'U', null, 0, '3431240');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431241, 4, '73656957901', 'N', null, 0, '3431241');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431242, 4, '73656957902', 'U', null, 0, '3431242');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431243, 4, '73656957903', 'U', null, 0, '3431243');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431244, 4, '73656957904', 'U', null, 0, '3431244');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431245, 4, '73656957905', 'N', null, 0, '3431245');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431246, 4, '73656957906', 'U', null, 0, '3431246');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431247, 4, '73656957907', 'U', null, 0, '3431247');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431248, 4, '73656957908', 'N', null, 0, '3431248');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431249, 4, '73656957909', 'U', null, 0, '3431249');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431250, 4, '73656957910', 'U', null, 0, '3431250');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431251, 4, '73656957911', 'U', null, 0, '3431251');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431252, 4, '73656957912', 'U', null, 0, '3431252');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431253, 4, '73656957913', 'U', null, 0, '3431253');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431254, 4, '73656957914', 'U', null, 0, '3431254');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431255, 4, '73656957915', 'N', null, 0, '3431255');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431256, 4, '73656957916', 'U', null, 0, '3431256');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431257, 4, '73656957917', 'U', null, 0, '3431257');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431258, 4, '73656957918', 'N', null, 0, '3431258');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431259, 4, '73656957919', 'U', null, 0, '3431259');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431260, 4, '73656957920', 'U', null, 0, '3431260');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431261, 4, '73656957921', 'U', null, 0, '3431261');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431262, 4, '73656957922', 'U', null, 0, '3431262');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431263, 4, '73656957923', 'U', null, 0, '3431263');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431264, 4, '73656957924', 'U', null, 0, '3431264');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431265, 4, '73656957925', 'U', null, 0, '3431265');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431266, 4, '73656957926', 'U', null, 0, '3431266');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431267, 4, '73656957927', 'U', null, 0, '3431267');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431268, 4, '73656957928', 'N', null, 0, '3431268');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431269, 4, '73656957929', 'U', null, 0, '3431269');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431270, 4, '73656957930', 'U', null, 0, '3431270');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431271, 4, '73656957931', 'U', null, 0, '3431271');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431272, 4, '73656957932', 'U', null, 0, '3431272');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431273, 4, '73656957933', 'U', null, 0, '3431273');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431274, 4, '73656957934', 'U', null, 0, '3431274');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431275, 4, '73656957935', 'U', null, 0, '3431275');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431276, 4, '73656957936', 'U', null, 0, '3431276');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431277, 4, '73656957937', 'N', null, 0, '3431277');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431278, 4, '73656957938', 'U', null, 0, '3431278');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431279, 4, '73656957939', 'U', null, 0, '3431279');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431280, 4, '73656957940', 'U', null, 0, '3431280');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431281, 4, '73656957941', 'N', null, 0, '3431281');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431282, 4, '73656957942', 'N', null, 0, '3431282');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431283, 4, '73656957943', 'N', null, 0, '3431283');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431284, 4, '73656957944', 'N', null, 0, '3431284');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431285, 4, '73656957945', 'U', null, 0, '3431285');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431286, 4, '73656957946', 'U', null, 0, '3431286');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431287, 4, '73656957947', 'U', null, 0, '3431287');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431288, 4, '73656957948', 'N', null, 0, '3431288');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431289, 4, '73656957949', 'U', null, 0, '3431289');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431290, 4, '73656957950', 'U', null, 0, '3431290');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431291, 4, '73656957951', 'U', null, 0, '3431291');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431292, 4, '73656957952', 'U', null, 0, '3431292');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431293, 4, '73656957953', 'N', null, 0, '3431293');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431294, 4, '73656957954', 'U', null, 0, '3431294');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431295, 4, '73656957955', 'U', null, 0, '3431295');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431296, 4, '73656957956', 'U', null, 0, '3431296');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431297, 4, '73656957957', 'U', null, 0, '3431297');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431298, 4, '73656957958', 'U', null, 0, '3431298');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431299, 4, '73656957959', 'U', null, 0, '3431299');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431300, 4, '73656957960', 'U', null, 0, '3431300');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431301, 4, '73656957961', 'U', null, 0, '3431301');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431302, 4, '73656957962', 'U', null, 0, '3431302');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431303, 4, '73656957963', 'N', null, 0, '3431303');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431304, 4, '73656957964', 'N', null, 0, '3431304');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431305, 4, '73656957965', 'U', null, 0, '3431305');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431306, 4, '73656957966', 'U', null, 0, '3431306');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431307, 4, '73656957967', 'U', null, 0, '3431307');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431308, 4, '73656957968', 'U', null, 0, '3431308');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431309, 4, '73656957969', 'N', null, 0, '3431309');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431310, 4, '73656957970', 'U', null, 0, '3431310');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431311, 4, '73656957971', 'U', null, 0, '3431311');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431312, 4, '73656957972', 'U', null, 0, '3431312');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431313, 4, '73656957973', 'U', null, 0, '3431313');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431314, 4, '73656957974', 'U', null, 0, '3431314');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431315, 4, '73656957975', 'U', null, 0, '3431315');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431316, 4, '73656957976', 'U', null, 0, '3431316');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431317, 4, '73656957977', 'N', null, 0, '3431317');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431318, 4, '73656957978', 'U', null, 0, '3431318');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431319, 4, '73656957979', 'U', null, 0, '3431319');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431320, 4, '73656957980', 'U', null, 0, '3431320');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431321, 4, '73656957981', 'N', null, 0, '3431321');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431322, 4, '73656957982', 'N', null, 0, '3431322');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431323, 4, '73656957983', 'U', null, 0, '3431323');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431324, 4, '73656957984', 'U', null, 0, '3431324');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431325, 4, '73656957985', 'N', null, 0, '3431325');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431326, 4, '73656957986', 'N', null, 0, '3431326');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431327, 4, '73656957987', 'U', null, 0, '3431327');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431328, 4, '73656957988', 'N', null, 0, '3431328');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431329, 4, '73656957989', 'N', null, 0, '3431329');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431330, 4, '73656957990', 'U', null, 0, '3431330');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431331, 4, '73656957991', 'U', null, 0, '3431331');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431332, 4, '73656957992', 'U', null, 0, '3431332');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431333, 4, '73656957993', 'U', null, 0, '3431333');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431334, 4, '73656957994', 'U', null, 0, '3431334');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431335, 4, '73656957995', 'N', null, 0, '3431335');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431336, 4, '73656957996', 'U', null, 0, '3431336');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431337, 4, '73656957997', 'U', null, 0, '3431337');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431338, 4, '73656957998', 'U', null, 0, '3431338');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431339, 4, '73656957999', 'U', null, 0, '3431339');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431340, 4, '73656958000', 'U', null, 0, '3431340');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431341, 4, '73656958001', 'U', null, 0, '3431341');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431342, 4, '73656958002', 'N', null, 0, '3431342');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431343, 4, '73656958003', 'U', null, 0, '3431343');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431344, 4, '73656958004', 'U', null, 0, '3431344');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431345, 4, '73656958005', 'U', null, 0, '3431345');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431346, 4, '73656958006', 'U', null, 0, '3431346');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431347, 4, '73656958007', 'N', null, 0, '3431347');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431348, 4, '73656958008', 'U', null, 0, '3431348');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431349, 4, '73656958009', 'U', null, 0, '3431349');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431350, 4, '73656958010', 'U', null, 0, '3431350');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431351, 4, '73656958011', 'N', null, 0, '3431351');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431352, 4, '73656958012', 'N', null, 0, '3431352');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431353, 4, '73656958013', 'U', null, 0, '3431353');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431354, 4, '73656958014', 'U', null, 0, '3431354');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431355, 4, '73656958015', 'U', null, 0, '3431355');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431356, 4, '73656958016', 'N', null, 0, '3431356');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431357, 4, '73656958017', 'U', null, 0, '3431357');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431358, 4, '73656958018', 'U', null, 0, '3431358');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431359, 4, '73656958019', 'U', null, 0, '3431359');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431360, 4, '73656958020', 'U', null, 0, '3431360');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431361, 4, '73656958021', 'U', null, 0, '3431361');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431362, 4, '73656958022', 'N', null, 0, '3431362');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431363, 4, '73656958023', 'U', null, 0, '3431363');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431364, 4, '73656958024', 'U', null, 0, '3431364');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431365, 4, '73656958025', 'U', null, 0, '3431365');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431366, 4, '73656958026', 'N', null, 0, '3431366');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431367, 4, '73656958027', 'N', null, 0, '3431367');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431368, 4, '73656958028', 'N', null, 0, '3431368');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431369, 4, '73656958029', 'U', null, 0, '3431369');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431370, 4, '73656958030', 'N', null, 0, '3431370');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431371, 4, '73656958031', 'N', null, 0, '3431371');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431372, 4, '73656958032', 'U', null, 0, '3431372');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431373, 4, '73656958033', 'U', null, 0, '3431373');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431374, 4, '73656958034', 'U', null, 0, '3431374');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431375, 4, '73656958035', 'U', null, 0, '3431375');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431376, 4, '73656958036', 'U', null, 0, '3431376');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431377, 4, '73656958037', 'N', null, 0, '3431377');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431378, 4, '73656958038', 'U', null, 0, '3431378');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431379, 4, '73656958039', 'U', null, 0, '3431379');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431380, 4, '73656958040', 'U', null, 0, '3431380');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431381, 4, '73656958041', 'U', null, 0, '3431381');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431382, 4, '73656958042', 'U', null, 0, '3431382');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431383, 4, '73656958043', 'U', null, 0, '3431383');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431384, 4, '73656958044', 'N', null, 0, '3431384');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431385, 4, '73656958045', 'U', null, 0, '3431385');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431386, 4, '73656958046', 'U', null, 0, '3431386');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431387, 4, '73656958047', 'N', null, 0, '3431387');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431388, 4, '73656958048', 'U', null, 0, '3431388');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431389, 4, '73652493055', 'N', null, 0, '3431389');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431390, 4, '73652493056', 'U', null, 0, '3431390');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431391, 4, '73652493057', 'U', null, 0, '3431391');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431392, 4, '73652493058', 'U', null, 0, '3431392');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431393, 4, '73652493059', 'U', null, 0, '3431393');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431394, 4, '73652493060', 'U', null, 0, '3431394');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431395, 4, '73652493061', 'U', null, 0, '3431395');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431396, 4, '73652493062', 'U', null, 0, '3431396');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431397, 4, '73652493063', 'U', null, 0, '3431397');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431398, 4, '73652493064', 'U', null, 0, '3431398');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431399, 4, '73652493065', 'U', null, 0, '3431399');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431400, 4, '73652493066', 'U', null, 0, '3431400');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431401, 4, '73652493067', 'U', null, 0, '3431401');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431402, 4, '73652493068', 'U', null, 0, '3431402');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431403, 4, '73652493069', 'U', null, 0, '3431403');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431404, 4, '73652493070', 'U', null, 0, '3431404');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431405, 4, '73652493071', 'U', null, 0, '3431405');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431406, 4, '73652493072', 'N', null, 0, '3431406');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431407, 4, '73652493073', 'U', null, 0, '3431407');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431408, 4, '73652493074', 'N', null, 0, '3431408');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431409, 4, '73652493075', 'N', null, 0, '3431409');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431410, 4, '73652493076', 'N', null, 0, '3431410');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431411, 4, '73652493077', 'U', null, 0, '3431411');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431412, 4, '73652493078', 'U', null, 0, '3431412');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431413, 4, '73652493079', 'U', null, 0, '3431413');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431414, 4, '73652493080', 'U', null, 0, '3431414');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431415, 4, '73652493081', 'N', null, 0, '3431415');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431416, 4, '73652493082', 'N', null, 0, '3431416');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431417, 4, '73652493083', 'U', null, 0, '3431417');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431418, 4, '73652493084', 'U', null, 0, '3431418');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431419, 4, '73652493085', 'U', null, 0, '3431419');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431420, 4, '73652493086', 'U', null, 0, '3431420');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431421, 4, '73652493087', 'U', null, 0, '3431421');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431422, 4, '73652493088', 'U', null, 0, '3431422');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431423, 4, '73652493089', 'N', null, 0, '3431423');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431424, 4, '73652493090', 'U', null, 0, '3431424');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431425, 4, '73652493091', 'N', null, 0, '3431425');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431426, 4, '73652493092', 'U', null, 0, '3431426');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431427, 4, '73652493093', 'U', null, 0, '3431427');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431428, 4, '73652493094', 'N', null, 0, '3431428');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431429, 4, '73652493095', 'N', null, 0, '3431429');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431430, 4, '73652493096', 'N', null, 0, '3431430');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431431, 4, '73652493097', 'U', null, 0, '3431431');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431432, 4, '73652493098', 'U', null, 0, '3431432');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431433, 4, '73652493099', 'U', null, 0, '3431433');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434953, 4, '73656962008', 'U', null, 0, '3434953');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434954, 4, '73656962009', 'U', null, 0, '3434954');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434955, 4, '73656962010', 'N', null, 0, '3434955');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434956, 4, '73656962011', 'U', null, 0, '3434956');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434957, 4, '73656962012', 'U', null, 0, '3434957');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434958, 4, '73656962013', 'N', null, 0, '3434958');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434959, 4, '73656962014', 'U', null, 0, '3434959');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434960, 4, '73656962015', 'U', null, 0, '3434960');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434961, 4, '73656962016', 'U', null, 0, '3434961');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434962, 4, '73656962017', 'U', null, 0, '3434962');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434963, 4, '73656962018', 'U', null, 0, '3434963');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434964, 4, '73656962019', 'U', null, 0, '3434964');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434965, 4, '73656962020', 'U', null, 0, '3434965');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434966, 4, '73656962021', 'U', null, 0, '3434966');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434967, 4, '73656962022', 'U', null, 0, '3434967');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434968, 4, '73656962023', 'U', null, 0, '3434968');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434969, 4, '73656962024', 'U', null, 0, '3434969');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434970, 4, '73656962025', 'U', null, 0, '3434970');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434971, 4, '73656962026', 'U', null, 0, '3434971');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434972, 4, '73656962027', 'U', null, 0, '3434972');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434973, 4, '73656962028', 'U', null, 0, '3434973');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434974, 4, '73656962029', 'U', null, 0, '3434974');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434975, 4, '73656962030', 'U', null, 0, '3434975');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434976, 4, '73656962031', 'U', null, 0, '3434976');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434977, 4, '73656962032', 'U', null, 0, '3434977');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434978, 4, '73656962033', 'U', null, 0, '3434978');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434979, 4, '73656962034', 'U', null, 0, '3434979');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434980, 4, '73656962035', 'U', null, 0, '3434980');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434981, 4, '73656962036', 'N', null, 0, '3434981');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434982, 4, '73656962037', 'U', null, 0, '3434982');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434983, 4, '73656962038', 'U', null, 0, '3434983');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434984, 4, '73656962039', 'N', null, 0, '3434984');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434985, 4, '73656962040', 'N', null, 0, '3434985');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434986, 4, '73656962041', 'U', null, 0, '3434986');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434987, 4, '73656962042', 'N', null, 0, '3434987');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434988, 4, '73656962043', 'N', null, 0, '3434988');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434989, 4, '73656962044', 'N', null, 0, '3434989');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434990, 4, '73656962045', 'U', null, 0, '3434990');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434991, 4, '73656962046', 'U', null, 0, '3434991');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434992, 4, '73656962047', 'U', null, 0, '3434992');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434993, 4, '73656962048', 'U', null, 0, '3434993');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434994, 4, '73656962049', 'U', null, 0, '3434994');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434995, 4, '73656962050', 'N', null, 0, '3434995');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434996, 4, '73656962051', 'U', null, 0, '3434996');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434997, 4, '73656962052', 'U', null, 0, '3434997');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434998, 4, '73656962053', 'N', null, 0, '3434998');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3434999, 4, '73656962054', 'U', null, 0, '3434999');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435000, 4, '73656962055', 'N', null, 0, '3435000');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435001, 4, '73656962056', 'U', null, 0, '3435001');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435002, 4, '73656962057', 'U', null, 0, '3435002');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435003, 4, '73656962058', 'U', null, 0, '3435003');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435004, 4, '73656962059', 'U', null, 0, '3435004');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435005, 4, '73656962060', 'U', null, 0, '3435005');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435006, 4, '73656962061', 'U', null, 0, '3435006');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435007, 4, '73656962062', 'U', null, 0, '3435007');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435008, 4, '73656962063', 'U', null, 0, '3435008');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435009, 4, '73656939441', 'N', null, 0, '3435009');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435010, 4, '73656939442', 'U', null, 0, '3435010');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435011, 4, '73656939443', 'N', null, 0, '3435011');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435012, 4, '73656939444', 'N', null, 0, '3435012');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435013, 4, '73656939445', 'N', null, 0, '3435013');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435014, 4, '73656939446', 'U', null, 0, '3435014');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435015, 4, '73656939447', 'N', null, 0, '3435015');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435016, 4, '73656939448', 'N', null, 0, '3435016');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435017, 4, '73656939449', 'N', null, 0, '3435017');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435018, 4, '73656939450', 'U', null, 0, '3435018');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435019, 4, '73656939451', 'N', null, 0, '3435019');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435020, 4, '73656939452', 'N', null, 0, '3435020');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435021, 4, '73656939453', 'U', null, 0, '3435021');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435022, 4, '73656939454', 'N', null, 0, '3435022');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435023, 4, '73656939455', 'U', null, 0, '3435023');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435024, 4, '73656939456', 'U', null, 0, '3435024');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435025, 4, '73656939457', 'U', null, 0, '3435025');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435026, 4, '73656939458', 'N', null, 0, '3435026');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435027, 4, '73656939459', 'N', null, 0, '3435027');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435028, 4, '73656939460', 'U', null, 0, '3435028');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435029, 4, '73656939461', 'U', null, 0, '3435029');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435030, 4, '73656939462', 'N', null, 0, '3435030');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435031, 4, '73656929300', 'U', null, 0, '3435031');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435032, 4, '73656929301', 'U', null, 0, '3435032');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435033, 4, '73656929302', 'U', null, 0, '3435033');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435034, 4, '73656929303', 'N', null, 0, '3435034');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435035, 4, '73656929304', 'U', null, 0, '3435035');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435036, 4, '73656929305', 'U', null, 0, '3435036');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435037, 4, '73656929306', 'U', null, 0, '3435037');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435038, 4, '73656929307', 'U', null, 0, '3435038');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435039, 4, '73656929308', 'U', null, 0, '3435039');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435040, 4, '73656929309', 'U', null, 0, '3435040');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435041, 4, '73656929310', 'U', null, 0, '3435041');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435042, 4, '73656929311', 'N', null, 0, '3435042');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435043, 4, '73656929312', 'U', null, 0, '3435043');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435044, 4, '73656929313', 'U', null, 0, '3435044');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435045, 4, '73656929314', 'U', null, 0, '3435045');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435046, 4, '73656929315', 'U', null, 0, '3435046');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435047, 4, '73656929316', 'U', null, 0, '3435047');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435048, 4, '73656929317', 'N', null, 0, '3435048');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435049, 4, '73656929318', 'U', null, 0, '3435049');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435050, 4, '73656929319', 'U', null, 0, '3435050');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435051, 4, '73656929320', 'U', null, 0, '3435051');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435052, 4, '73656929321', 'U', null, 0, '3435052');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435053, 4, '73656929322', 'N', null, 0, '3435053');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435054, 4, '73656929323', 'N', null, 0, '3435054');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435055, 4, '73656929324', 'U', null, 0, '3435055');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435056, 4, '73656929325', 'U', null, 0, '3435056');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435057, 4, '73656929326', 'N', null, 0, '3435057');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435058, 4, '73656929327', 'U', null, 0, '3435058');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435059, 4, '73656929328', 'U', null, 0, '3435059');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435060, 4, '73656929329', 'U', null, 0, '3435060');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435061, 4, '73656929330', 'U', null, 0, '3435061');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435062, 4, '73656929331', 'U', null, 0, '3435062');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435063, 4, '73656929332', 'U', null, 0, '3435063');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435064, 4, '73656929333', 'U', null, 0, '3435064');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435065, 4, '73656929334', 'U', null, 0, '3435065');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435066, 4, '73656929335', 'U', null, 0, '3435066');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435067, 4, '73656929336', 'U', null, 0, '3435067');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435068, 4, '73656929337', 'U', null, 0, '3435068');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435069, 4, '73656929338', 'U', null, 0, '3435069');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435070, 4, '73656929339', 'U', null, 0, '3435070');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435071, 4, '73656929340', 'U', null, 0, '3435071');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435072, 4, '73656929341', 'U', null, 0, '3435072');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435073, 4, '73656929342', 'U', null, 0, '3435073');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435074, 4, '73656929343', 'U', null, 0, '3435074');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435075, 4, '73656929344', 'U', null, 0, '3435075');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435076, 4, '73656929345', 'U', null, 0, '3435076');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435077, 4, '73656929346', 'U', null, 0, '3435077');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435078, 4, '73656929347', 'U', null, 0, '3435078');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435079, 4, '73656929348', 'U', null, 0, '3435079');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435080, 4, '73656929349', 'U', null, 0, '3435080');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435081, 4, '73656929350', 'U', null, 0, '3435081');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435082, 4, '73656929351', 'U', null, 0, '3435082');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435083, 4, '73656929352', 'U', null, 0, '3435083');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435084, 4, '73656929353', 'U', null, 0, '3435084');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435085, 4, '73656929354', 'U', null, 0, '3435085');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435086, 4, '73656929355', 'U', null, 0, '3435086');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435087, 4, '73656929356', 'N', null, 0, '3435087');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435088, 4, '73656929357', 'U', null, 0, '3435088');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435089, 4, '73656929358', 'U', null, 0, '3435089');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435090, 4, '73656929359', 'U', null, 0, '3435090');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435091, 4, '73656929360', 'U', null, 0, '3435091');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435092, 4, '73656929361', 'U', null, 0, '3435092');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435093, 4, '73656929362', 'U', null, 0, '3435093');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435094, 4, '73656929363', 'N', null, 0, '3435094');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435095, 4, '73656929364', 'U', null, 0, '3435095');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435096, 4, '73656929365', 'U', null, 0, '3435096');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435097, 4, '73656929366', 'U', null, 0, '3435097');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435098, 4, '73656929367', 'U', null, 0, '3435098');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435099, 4, '73656929368', 'U', null, 0, '3435099');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435100, 4, '73656929369', 'U', null, 0, '3435100');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435101, 4, '73656929370', 'U', null, 0, '3435101');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435102, 4, '73656929371', 'U', null, 0, '3435102');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435103, 4, '73656929372', 'U', null, 0, '3435103');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435104, 4, '73656929373', 'U', null, 0, '3435104');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435105, 4, '73656929374', 'U', null, 0, '3435105');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435106, 4, '73656929375', 'U', null, 0, '3435106');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435107, 4, '73656929376', 'U', null, 0, '3435107');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435108, 4, '73656929377', 'U', null, 0, '3435108');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435109, 4, '73656929378', 'U', null, 0, '3435109');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435110, 4, '73656929379', 'N', null, 0, '3435110');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435111, 4, '73656929380', 'U', null, 0, '3435111');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435112, 4, '73656929381', 'U', null, 0, '3435112');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435113, 4, '73656929382', 'U', null, 0, '3435113');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435114, 4, '73656929383', 'U', null, 0, '3435114');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435115, 4, '73656929384', 'U', null, 0, '3435115');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435116, 4, '73656929385', 'U', null, 0, '3435116');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435117, 4, '73656929386', 'N', null, 0, '3435117');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435118, 4, '73656929387', 'U', null, 0, '3435118');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435119, 4, '73656929388', 'U', null, 0, '3435119');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435120, 4, '73656929389', 'U', null, 0, '3435120');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435121, 4, '73656929390', 'U', null, 0, '3435121');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435122, 4, '73656929391', 'U', null, 0, '3435122');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435123, 4, '73656929392', 'U', null, 0, '3435123');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435124, 4, '73656929393', 'U', null, 0, '3435124');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435125, 4, '73656929394', 'U', null, 0, '3435125');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435126, 4, '73656929395', 'U', null, 0, '3435126');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435127, 4, '73656929396', 'N', null, 0, '3435127');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435128, 4, '73656929397', 'U', null, 0, '3435128');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435129, 4, '73656929398', 'U', null, 0, '3435129');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435130, 4, '73656929399', 'U', null, 0, '3435130');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435131, 4, '73656929400', 'U', null, 0, '3435131');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435132, 4, '73656929401', 'N', null, 0, '3435132');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435133, 4, '73656929402', 'U', null, 0, '3435133');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435134, 4, '73656929403', 'U', null, 0, '3435134');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435135, 4, '73656929404', 'U', null, 0, '3435135');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435136, 4, '73656929405', 'U', null, 0, '3435136');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435137, 4, '73656929406', 'U', null, 0, '3435137');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435138, 4, '73656929407', 'U', null, 0, '3435138');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435139, 4, '73656929408', 'U', null, 0, '3435139');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435140, 4, '73656929409', 'U', null, 0, '3435140');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435141, 4, '73656929410', 'U', null, 0, '3435141');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435142, 4, '73656929411', 'U', null, 0, '3435142');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435143, 4, '73656929412', 'N', null, 0, '3435143');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435144, 4, '73656929413', 'N', null, 0, '3435144');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435145, 4, '73656929414', 'U', null, 0, '3435145');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435146, 4, '73656929415', 'N', null, 0, '3435146');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435147, 4, '73656929416', 'U', null, 0, '3435147');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435148, 4, '73656929417', 'N', null, 0, '3435148');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435149, 4, '73656929418', 'U', null, 0, '3435149');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435150, 4, '73656929419', 'U', null, 0, '3435150');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435151, 4, '73656929420', 'U', null, 0, '3435151');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435152, 4, '73656929421', 'U', null, 0, '3435152');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435153, 4, '73656929422', 'U', null, 0, '3435153');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435154, 4, '73656929423', 'U', null, 0, '3435154');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435155, 4, '73656929424', 'U', null, 0, '3435155');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435156, 4, '73656929425', 'U', null, 0, '3435156');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435157, 4, '73656929426', 'U', null, 0, '3435157');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435158, 4, '73656929427', 'U', null, 0, '3435158');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3435159, 4, '73656929428', 'U', null, 0, '3435159');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425017, 4, '73656962951', 'N', null, 0, '3425017');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425018, 4, '73656962952', 'U', null, 0, '3425018');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425019, 4, '73656962953', 'N', null, 0, '3425019');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425020, 4, '73656962954', 'N', null, 0, '3425020');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425021, 4, '73656962955', 'U', null, 0, '3425021');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425022, 4, '73656962956', 'U', null, 0, '3425022');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425023, 4, '73656962957', 'U', null, 0, '3425023');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425024, 4, '73656962958', 'U', null, 0, '3425024');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425025, 4, '73656962959', 'U', null, 0, '3425025');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425026, 4, '73656962960', 'U', null, 0, '3425026');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425027, 4, '73656962961', 'N', null, 0, '3425027');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425028, 4, '73656962962', 'U', null, 0, '3425028');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425029, 4, '73656962963', 'U', null, 0, '3425029');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425030, 4, '73656962964', 'U', null, 0, '3425030');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425031, 4, '73656962965', 'N', null, 0, '3425031');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425032, 4, '73656962966', 'N', null, 0, '3425032');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425033, 4, '73656962967', 'U', null, 0, '3425033');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425034, 4, '73656962968', 'N', null, 0, '3425034');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425035, 4, '73656962969', 'N', null, 0, '3425035');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425036, 4, '73656962970', 'U', null, 0, '3425036');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425037, 4, '73656962971', 'U', null, 0, '3425037');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425038, 4, '73656962972', 'U', null, 0, '3425038');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425039, 4, '73656962973', 'U', null, 0, '3425039');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425040, 4, '73656962974', 'N', null, 0, '3425040');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425041, 4, '73656962975', 'N', null, 0, '3425041');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425042, 4, '73656962976', 'N', null, 0, '3425042');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425043, 4, '73656962977', 'U', null, 0, '3425043');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425044, 4, '73656962978', 'U', null, 0, '3425044');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425045, 4, '73656962979', 'N', null, 0, '3425045');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425046, 4, '73656959145', 'U', null, 0, '3425046');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425047, 4, '73656959146', 'N', null, 0, '3425047');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425048, 4, '73656959147', 'U', null, 0, '3425048');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425049, 4, '73656959148', 'U', null, 0, '3425049');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425050, 4, '73656959149', 'U', null, 0, '3425050');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425051, 4, '73656959150', 'N', null, 0, '3425051');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425052, 4, '73656959151', 'N', null, 0, '3425052');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425053, 4, '73656959152', 'U', null, 0, '3425053');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425054, 4, '73656959153', 'U', null, 0, '3425054');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425055, 4, '73656959154', 'U', null, 0, '3425055');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425056, 4, '73656959155', 'U', null, 0, '3425056');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425057, 4, '73656959156', 'U', null, 0, '3425057');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425058, 4, '73656959157', 'U', null, 0, '3425058');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425059, 4, '73656959158', 'U', null, 0, '3425059');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425060, 4, '73656959159', 'U', null, 0, '3425060');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425061, 4, '73656959160', 'N', null, 0, '3425061');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425062, 4, '73656959161', 'U', null, 0, '3425062');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425063, 4, '73656959162', 'U', null, 0, '3425063');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425064, 4, '73656959163', 'U', null, 0, '3425064');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425065, 4, '73656959164', 'U', null, 0, '3425065');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425066, 4, '73656959165', 'U', null, 0, '3425066');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425067, 4, '73656959166', 'N', null, 0, '3425067');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425068, 4, '73656959167', 'U', null, 0, '3425068');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425069, 4, '73656959168', 'U', null, 0, '3425069');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425070, 4, '73656959169', 'U', null, 0, '3425070');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425071, 4, '73656959170', 'U', null, 0, '3425071');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425072, 4, '73656959171', 'N', null, 0, '3425072');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425073, 4, '73656961524', 'U', null, 0, '3425073');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425074, 4, '73656961525', 'U', null, 0, '3425074');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425075, 4, '73656961526', 'U', null, 0, '3425075');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425076, 4, '73656961527', 'U', null, 0, '3425076');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425077, 4, '73656951885', 'U', null, 0, '3425077');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425078, 4, '73656951886', 'U', null, 0, '3425078');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425079, 4, '73656951887', 'U', null, 0, '3425079');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425080, 4, '73656951888', 'U', null, 0, '3425080');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425081, 4, '73656951889', 'U', null, 0, '3425081');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425082, 4, '73656951890', 'U', null, 0, '3425082');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425083, 4, '73656951891', 'N', null, 0, '3425083');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425084, 4, '73656951892', 'U', null, 0, '3425084');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425085, 4, '73656951893', 'U', null, 0, '3425085');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425086, 4, '73656951894', 'U', null, 0, '3425086');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425087, 4, '73656951895', 'U', null, 0, '3425087');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425088, 4, '73656951896', 'U', null, 0, '3425088');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425089, 4, '73656951897', 'U', null, 0, '3425089');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425090, 4, '73656951898', 'U', null, 0, '3425090');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425091, 4, '73656951899', 'U', null, 0, '3425091');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425092, 4, '73656951900', 'N', null, 0, '3425092');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425093, 4, '73656951901', 'N', null, 0, '3425093');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425094, 4, '73656951902', 'N', null, 0, '3425094');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425095, 4, '73656951903', 'U', null, 0, '3425095');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425096, 4, '73656951904', 'U', null, 0, '3425096');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425097, 4, '73656951905', 'U', null, 0, '3425097');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425098, 4, '73656951906', 'U', null, 0, '3425098');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425099, 4, '73656951907', 'U', null, 0, '3425099');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425100, 4, '73656951908', 'U', null, 0, '3425100');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425101, 4, '73656951909', 'N', null, 0, '3425101');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425102, 4, '73656951910', 'U', null, 0, '3425102');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425103, 4, '73656951911', 'U', null, 0, '3425103');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425104, 4, '73656951912', 'N', null, 0, '3425104');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425105, 4, '73656951913', 'U', null, 0, '3425105');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425106, 4, '73656951914', 'U', null, 0, '3425106');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425107, 4, '73656951915', 'N', null, 0, '3425107');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425108, 4, '73656951916', 'U', null, 0, '3425108');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425109, 4, '73656951917', 'U', null, 0, '3425109');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425110, 4, '73656951918', 'N', null, 0, '3425110');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425111, 4, '73656951919', 'U', null, 0, '3425111');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425112, 4, '73656951920', 'N', null, 0, '3425112');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425113, 4, '73656951921', 'U', null, 0, '3425113');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425114, 4, '73656951922', 'U', null, 0, '3425114');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425115, 4, '73656951923', 'U', null, 0, '3425115');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425116, 4, '73656951924', 'U', null, 0, '3425116');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425117, 4, '73656951925', 'U', null, 0, '3425117');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425118, 4, '73656951926', 'U', null, 0, '3425118');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425119, 4, '73656951927', 'U', null, 0, '3425119');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425120, 4, '73656951928', 'N', null, 0, '3425120');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425121, 4, '73656951929', 'U', null, 0, '3425121');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425122, 4, '73656951930', 'U', null, 0, '3425122');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425123, 4, '73656951931', 'U', null, 0, '3425123');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425124, 4, '73656951932', 'U', null, 0, '3425124');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425125, 4, '73656951933', 'U', null, 0, '3425125');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425126, 4, '73656951934', 'U', null, 0, '3425126');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425127, 4, '73656951935', 'U', null, 0, '3425127');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425128, 4, '73656951936', 'U', null, 0, '3425128');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425129, 4, '73656951937', 'U', null, 0, '3425129');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425130, 4, '73656951938', 'U', null, 0, '3425130');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425131, 4, '73656951939', 'U', null, 0, '3425131');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425132, 4, '73656951940', 'N', null, 0, '3425132');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425133, 4, '73656951941', 'U', null, 0, '3425133');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425134, 4, '73656951942', 'U', null, 0, '3425134');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425135, 4, '73656951943', 'U', null, 0, '3425135');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425136, 4, '73656951944', 'U', null, 0, '3425136');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425137, 4, '73656951945', 'N', null, 0, '3425137');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425138, 4, '73656951946', 'U', null, 0, '3425138');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425139, 4, '73656951947', 'U', null, 0, '3425139');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425140, 4, '73656951948', 'N', null, 0, '3425140');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425141, 4, '73656951949', 'U', null, 0, '3425141');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425142, 4, '73656951950', 'U', null, 0, '3425142');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425143, 4, '73656951951', 'N', null, 0, '3425143');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425144, 4, '73656951952', 'U', null, 0, '3425144');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425145, 4, '73656951953', 'U', null, 0, '3425145');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425146, 4, '73656951954', 'U', null, 0, '3425146');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425147, 4, '73656951955', 'U', null, 0, '3425147');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425148, 4, '73656951956', 'U', null, 0, '3425148');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425149, 4, '73656951957', 'U', null, 0, '3425149');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425150, 4, '73656951958', 'N', null, 0, '3425150');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425151, 4, '73656951959', 'U', null, 0, '3425151');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425152, 4, '73656951960', 'U', null, 0, '3425152');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425153, 4, '73656951961', 'U', null, 0, '3425153');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425154, 4, '73656951962', 'U', null, 0, '3425154');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425155, 4, '73656951963', 'U', null, 0, '3425155');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425156, 4, '73656951964', 'N', null, 0, '3425156');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425157, 4, '73656951965', 'U', null, 0, '3425157');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425158, 4, '73656951966', 'U', null, 0, '3425158');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425159, 4, '73656951967', 'N', null, 0, '3425159');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425160, 4, '73656951968', 'U', null, 0, '3425160');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425161, 4, '73656951969', 'U', null, 0, '3425161');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425162, 4, '73656951970', 'U', null, 0, '3425162');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425163, 4, '73656951971', 'U', null, 0, '3425163');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425164, 4, '73656951972', 'U', null, 0, '3425164');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425165, 4, '73656951973', 'N', null, 0, '3425165');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425166, 4, '73656951974', 'N', null, 0, '3425166');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425167, 4, '73656951975', 'N', null, 0, '3425167');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425168, 4, '73656951976', 'U', null, 0, '3425168');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425169, 4, '73656951977', 'U', null, 0, '3425169');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425170, 4, '73656951978', 'U', null, 0, '3425170');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425171, 4, '73656951979', 'U', null, 0, '3425171');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425172, 4, '73656951980', 'U', null, 0, '3425172');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425173, 4, '73656951981', 'U', null, 0, '3425173');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425174, 4, '73656951982', 'U', null, 0, '3425174');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425175, 4, '73656951983', 'U', null, 0, '3425175');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425176, 4, '73656951984', 'U', null, 0, '3425176');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425177, 4, '73656951985', 'N', null, 0, '3425177');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425178, 4, '73656951986', 'N', null, 0, '3425178');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425179, 4, '73656951987', 'U', null, 0, '3425179');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425180, 4, '73656951988', 'U', null, 0, '3425180');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425181, 4, '73656951989', 'U', null, 0, '3425181');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425182, 4, '73656951990', 'U', null, 0, '3425182');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425183, 4, '73656951991', 'U', null, 0, '3425183');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425184, 4, '73656951992', 'U', null, 0, '3425184');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425185, 4, '73656951993', 'U', null, 0, '3425185');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425186, 4, '73656951994', 'N', null, 0, '3425186');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425187, 4, '73656951995', 'U', null, 0, '3425187');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425188, 4, '73656951996', 'U', null, 0, '3425188');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425189, 4, '73656951997', 'U', null, 0, '3425189');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425190, 4, '73656951998', 'U', null, 0, '3425190');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425191, 4, '73656951999', 'U', null, 0, '3425191');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425192, 4, '73656952000', 'N', null, 0, '3425192');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425193, 4, '73656952001', 'U', null, 0, '3425193');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425194, 4, '73656952002', 'U', null, 0, '3425194');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425195, 4, '73656952003', 'U', null, 0, '3425195');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425196, 4, '73656952004', 'U', null, 0, '3425196');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425197, 4, '73656952005', 'N', null, 0, '3425197');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425198, 4, '73656952006', 'N', null, 0, '3425198');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425199, 4, '73656952007', 'U', null, 0, '3425199');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425200, 4, '73656952008', 'U', null, 0, '3425200');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425201, 4, '73656952009', 'U', null, 0, '3425201');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425202, 4, '73656952010', 'U', null, 0, '3425202');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425203, 4, '73656952011', 'U', null, 0, '3425203');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425204, 4, '73656952012', 'U', null, 0, '3425204');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425205, 4, '73656952013', 'U', null, 0, '3425205');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425206, 4, '73656952014', 'U', null, 0, '3425206');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425207, 4, '73656952015', 'U', null, 0, '3425207');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425208, 4, '73656952016', 'U', null, 0, '3425208');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425209, 4, '73656952017', 'U', null, 0, '3425209');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425210, 4, '73656952018', 'N', null, 0, '3425210');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425211, 4, '73656952019', 'U', null, 0, '3425211');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425212, 4, '73656952020', 'U', null, 0, '3425212');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425213, 4, '73656952021', 'U', null, 0, '3425213');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425214, 4, '73656952022', 'N', null, 0, '3425214');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425215, 4, '73656952023', 'N', null, 0, '3425215');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425216, 4, '73656952024', 'U', null, 0, '3425216');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425217, 4, '73656952025', 'U', null, 0, '3425217');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425218, 4, '73656952026', 'N', null, 0, '3425218');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425219, 4, '73656952027', 'U', null, 0, '3425219');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425220, 4, '73656952028', 'U', null, 0, '3425220');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425221, 4, '73656952029', 'N', null, 0, '3425221');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425222, 4, '73656952030', 'U', null, 0, '3425222');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3425223, 4, '73656952031', 'N', null, 0, '3425223');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431434, 4, '73652493100', 'U', null, 0, '3431434');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431435, 4, '73652493101', 'N', null, 0, '3431435');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431436, 4, '73652493102', 'N', null, 0, '3431436');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431437, 4, '73652493103', 'N', null, 0, '3431437');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431438, 4, '73652493104', 'U', null, 0, '3431438');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431439, 4, '73652493105', 'U', null, 0, '3431439');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431440, 4, '73652493106', 'U', null, 0, '3431440');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431441, 4, '73652493107', 'N', null, 0, '3431441');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431442, 4, '73652493108', 'N', null, 0, '3431442');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431443, 4, '73652493109', 'U', null, 0, '3431443');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431444, 4, '73652493110', 'N', null, 0, '3431444');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431445, 4, '73652493111', 'N', null, 0, '3431445');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431446, 4, '73652493112', 'U', null, 0, '3431446');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431447, 4, '73652493113', 'U', null, 0, '3431447');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431448, 4, '73652493114', 'U', null, 0, '3431448');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431449, 4, '73652493115', 'U', null, 0, '3431449');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431450, 4, '73652493116', 'N', null, 0, '3431450');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431451, 4, '73652493117', 'N', null, 0, '3431451');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431452, 4, '73652493118', 'U', null, 0, '3431452');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431453, 4, '73652493119', 'U', null, 0, '3431453');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431454, 4, '73652493120', 'N', null, 0, '3431454');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431455, 4, '73652493121', 'N', null, 0, '3431455');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431456, 4, '73652493122', 'N', null, 0, '3431456');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431457, 4, '73652493123', 'N', null, 0, '3431457');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431458, 4, '73652493124', 'U', null, 0, '3431458');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431459, 4, '73652493125', 'N', null, 0, '3431459');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431460, 4, '73652493126', 'U', null, 0, '3431460');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431461, 4, '73652493127', 'N', null, 0, '3431461');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431462, 4, '73652493128', 'U', null, 0, '3431462');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431463, 4, '73652493129', 'U', null, 0, '3431463');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431464, 4, '73652493130', 'U', null, 0, '3431464');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431465, 4, '73652493131', 'N', null, 0, '3431465');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431466, 4, '73652493132', 'N', null, 0, '3431466');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431467, 4, '73652493133', 'U', null, 0, '3431467');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431468, 4, '73652493134', 'U', null, 0, '3431468');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431469, 4, '73652493135', 'N', null, 0, '3431469');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431470, 4, '73652493136', 'U', null, 0, '3431470');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431471, 4, '73652493137', 'N', null, 0, '3431471');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431472, 4, '73652493138', 'U', null, 0, '3431472');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431473, 4, '73652493139', 'N', null, 0, '3431473');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431474, 4, '73652493140', 'N', null, 0, '3431474');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431475, 4, '73652493141', 'U', null, 0, '3431475');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431476, 4, '73652493142', 'N', null, 0, '3431476');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431477, 4, '73652493143', 'N', null, 0, '3431477');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431478, 4, '73652493144', 'U', null, 0, '3431478');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431479, 4, '73652493145', 'N', null, 0, '3431479');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431480, 4, '73652493146', 'N', null, 0, '3431480');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431481, 4, '73652493147', 'N', null, 0, '3431481');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431482, 4, '73652493148', 'U', null, 0, '3431482');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431483, 4, '73652493149', 'U', null, 0, '3431483');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431484, 4, '73652493150', 'U', null, 0, '3431484');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431485, 4, '73652493151', 'U', null, 0, '3431485');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431486, 4, '73652493152', 'N', null, 0, '3431486');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431487, 4, '73652493153', 'U', null, 0, '3431487');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431488, 4, '73652493154', 'N', null, 0, '3431488');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431489, 4, '73652493155', 'U', null, 0, '3431489');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431490, 4, '73652493156', 'N', null, 0, '3431490');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431491, 4, '73652493157', 'N', null, 0, '3431491');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431492, 4, '73652493158', 'U', null, 0, '3431492');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431493, 4, '73652493159', 'U', null, 0, '3431493');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431494, 4, '73652493160', 'U', null, 0, '3431494');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431495, 4, '73652493161', 'U', null, 0, '3431495');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431496, 4, '73652493162', 'U', null, 0, '3431496');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431497, 4, '73652493163', 'N', null, 0, '3431497');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431498, 4, '73652493164', 'N', null, 0, '3431498');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431499, 4, '73652493165', 'N', null, 0, '3431499');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431500, 4, '73652493166', 'U', null, 0, '3431500');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431501, 4, '73652493167', 'U', null, 0, '3431501');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431502, 4, '73652493168', 'U', null, 0, '3431502');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431503, 4, '73652493169', 'N', null, 0, '3431503');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431504, 4, '73652493170', 'U', null, 0, '3431504');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431505, 4, '73652493171', 'N', null, 0, '3431505');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431506, 4, '73652493172', 'U', null, 0, '3431506');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431507, 4, '73652493173', 'U', null, 0, '3431507');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431508, 4, '73652493174', 'N', null, 0, '3431508');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431509, 4, '73652493175', 'U', null, 0, '3431509');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431510, 4, '73652493176', 'U', null, 0, '3431510');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431511, 4, '73652493177', 'U', null, 0, '3431511');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431512, 4, '73652493178', 'N', null, 0, '3431512');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431513, 4, '73652493179', 'N', null, 0, '3431513');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431514, 4, '73652493180', 'U', null, 0, '3431514');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431515, 4, '73652493181', 'U', null, 0, '3431515');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431516, 4, '73652493182', 'U', null, 0, '3431516');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431517, 4, '73652493183', 'U', null, 0, '3431517');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431518, 4, '73652493184', 'U', null, 0, '3431518');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431519, 4, '73652493185', 'N', null, 0, '3431519');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431520, 4, '73652493186', 'N', null, 0, '3431520');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431521, 4, '73652493187', 'N', null, 0, '3431521');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431522, 4, '73652493188', 'U', null, 0, '3431522');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431523, 4, '73652493189', 'N', null, 0, '3431523');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431524, 4, '73652493190', 'U', null, 0, '3431524');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431525, 4, '73652493191', 'U', null, 0, '3431525');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431526, 4, '73652493192', 'U', null, 0, '3431526');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431527, 4, '73652493193', 'U', null, 0, '3431527');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431528, 4, '73652493194', 'U', null, 0, '3431528');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431529, 4, '73652493195', 'U', null, 0, '3431529');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431530, 4, '73652493196', 'U', null, 0, '3431530');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431531, 4, '73652493197', 'U', null, 0, '3431531');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431532, 4, '73652493198', 'U', null, 0, '3431532');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431533, 4, '73652493199', 'U', null, 0, '3431533');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431534, 4, '73652493300', 'U', null, 0, '3431534');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431535, 4, '73652493301', 'N', null, 0, '3431535');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431536, 4, '73652493302', 'U', null, 0, '3431536');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431537, 4, '73652493303', 'N', null, 0, '3431537');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431538, 4, '73652493304', 'U', null, 0, '3431538');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431539, 4, '73652493305', 'U', null, 0, '3431539');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431540, 4, '73652493306', 'N', null, 0, '3431540');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431541, 4, '73652493307', 'N', null, 0, '3431541');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431542, 4, '73652493308', 'N', null, 0, '3431542');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431543, 4, '73652493309', 'U', null, 0, '3431543');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431544, 4, '73652493310', 'U', null, 0, '3431544');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431545, 4, '73652493311', 'U', null, 0, '3431545');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431546, 4, '73652493312', 'U', null, 0, '3431546');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431547, 4, '73652493313', 'U', null, 0, '3431547');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431548, 4, '73652493314', 'U', null, 0, '3431548');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431549, 4, '73652493315', 'U', null, 0, '3431549');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431550, 4, '73652493316', 'U', null, 0, '3431550');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431551, 4, '73652493317', 'U', null, 0, '3431551');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431552, 4, '73652493318', 'U', null, 0, '3431552');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431553, 4, '73652493319', 'U', null, 0, '3431553');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431554, 4, '73652493320', 'N', null, 0, '3431554');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431555, 4, '73652493321', 'N', null, 0, '3431555');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431556, 4, '73652493322', 'U', null, 0, '3431556');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431557, 4, '73652493323', 'U', null, 0, '3431557');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431558, 4, '73652493324', 'U', null, 0, '3431558');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431559, 4, '73652493325', 'U', null, 0, '3431559');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431560, 4, '73652493326', 'U', null, 0, '3431560');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431561, 4, '73652493327', 'N', null, 0, '3431561');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431562, 4, '73652493328', 'U', null, 0, '3431562');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431563, 4, '73652493329', 'N', null, 0, '3431563');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431564, 4, '73652493330', 'U', null, 0, '3431564');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431565, 4, '73652493331', 'U', null, 0, '3431565');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431566, 4, '73652493332', 'U', null, 0, '3431566');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431567, 4, '73652493333', 'N', null, 0, '3431567');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431568, 4, '73652493334', 'U', null, 0, '3431568');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431569, 4, '73652493335', 'U', null, 0, '3431569');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431570, 4, '73652493336', 'U', null, 0, '3431570');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431571, 4, '73652493337', 'U', null, 0, '3431571');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431572, 4, '73652493338', 'U', null, 0, '3431572');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431573, 4, '73652493339', 'U', null, 0, '3431573');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431574, 4, '73652493340', 'N', null, 0, '3431574');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431575, 4, '73652493341', 'N', null, 0, '3431575');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431576, 4, '73652493342', 'U', null, 0, '3431576');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431577, 4, '73652493343', 'N', null, 0, '3431577');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431578, 4, '73652493344', 'N', null, 0, '3431578');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431579, 4, '73652493345', 'U', null, 0, '3431579');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431580, 4, '73652493346', 'U', null, 0, '3431580');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431581, 4, '73652493347', 'U', null, 0, '3431581');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431582, 4, '73652493348', 'U', null, 0, '3431582');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431583, 4, '73652493349', 'N', null, 0, '3431583');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431584, 4, '73652493350', 'U', null, 0, '3431584');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431585, 4, '73652493351', 'N', null, 0, '3431585');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431586, 4, '73652493352', 'N', null, 0, '3431586');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431587, 4, '73652493353', 'N', null, 0, '3431587');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431588, 4, '73652493354', 'U', null, 0, '3431588');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431589, 4, '73652493355', 'U', null, 0, '3431589');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431590, 4, '73652493356', 'N', null, 0, '3431590');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431591, 4, '73652493357', 'U', null, 0, '3431591');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431592, 4, '73652493358', 'U', null, 0, '3431592');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431593, 4, '73652493359', 'N', null, 0, '3431593');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431594, 4, '73652493360', 'U', null, 0, '3431594');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431595, 4, '73652493361', 'U', null, 0, '3431595');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431596, 4, '73652493362', 'U', null, 0, '3431596');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431597, 4, '73652493363', 'U', null, 0, '3431597');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431598, 4, '73652493364', 'N', null, 0, '3431598');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431599, 4, '73652493365', 'N', null, 0, '3431599');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431600, 4, '73652493366', 'U', null, 0, '3431600');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431601, 4, '73652493367', 'U', null, 0, '3431601');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431602, 4, '73652493368', 'U', null, 0, '3431602');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431603, 4, '73652493369', 'U', null, 0, '3431603');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431604, 4, '73652493370', 'U', null, 0, '3431604');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431605, 4, '73652493371', 'N', null, 0, '3431605');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431606, 4, '73652493372', 'U', null, 0, '3431606');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431607, 4, '73652493373', 'U', null, 0, '3431607');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431608, 4, '73652493374', 'U', null, 0, '3431608');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431609, 4, '73652493375', 'U', null, 0, '3431609');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431610, 4, '73652493376', 'U', null, 0, '3431610');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431611, 4, '73652493377', 'U', null, 0, '3431611');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431612, 4, '73652493378', 'U', null, 0, '3431612');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431613, 4, '73652493379', 'U', null, 0, '3431613');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431614, 4, '73652493380', 'U', null, 0, '3431614');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431615, 4, '73652493381', 'U', null, 0, '3431615');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431616, 4, '73652493382', 'U', null, 0, '3431616');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431617, 4, '73652493383', 'U', null, 0, '3431617');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431618, 4, '73652493384', 'U', null, 0, '3431618');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431619, 4, '73652493385', 'U', null, 0, '3431619');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431620, 4, '73652493386', 'N', null, 0, '3431620');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431621, 4, '73652493387', 'U', null, 0, '3431621');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431622, 4, '73652493388', 'U', null, 0, '3431622');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431623, 4, '73652493389', 'U', null, 0, '3431623');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431624, 4, '73652493390', 'U', null, 0, '3431624');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431625, 4, '73652493391', 'U', null, 0, '3431625');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431626, 4, '73652493392', 'U', null, 0, '3431626');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431627, 4, '73652493393', 'U', null, 0, '3431627');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431628, 4, '73652493394', 'U', null, 0, '3431628');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431629, 4, '73652493395', 'U', null, 0, '3431629');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431630, 4, '73652493396', 'N', null, 0, '3431630');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431631, 4, '73652493397', 'U', null, 0, '3431631');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431632, 4, '73652493398', 'U', null, 0, '3431632');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431633, 4, '73652493399', 'U', null, 0, '3431633');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431634, 4, '73652493500', 'U', null, 0, '3431634');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431635, 4, '73652493501', 'U', null, 0, '3431635');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431636, 4, '73652493502', 'U', null, 0, '3431636');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431637, 4, '73652493503', 'U', null, 0, '3431637');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431638, 4, '73652493504', 'U', null, 0, '3431638');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431639, 4, '73652493505', 'U', null, 0, '3431639');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431640, 4, '73652493506', 'U', null, 0, '3431640');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431848, 4, '73656953615', 'U', null, 0, '3431848');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431849, 4, '73656953616', 'U', null, 0, '3431849');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431850, 4, '73656953617', 'U', null, 0, '3431850');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431851, 4, '73656953618', 'U', null, 0, '3431851');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431852, 4, '73656953619', 'U', null, 0, '3431852');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431853, 4, '73656953620', 'U', null, 0, '3431853');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431854, 4, '73656953621', 'U', null, 0, '3431854');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431855, 4, '73656953622', 'U', null, 0, '3431855');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431856, 4, '73656953623', 'U', null, 0, '3431856');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431857, 4, '73656953624', 'U', null, 0, '3431857');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431858, 4, '73656953625', 'U', null, 0, '3431858');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431859, 4, '73656953626', 'U', null, 0, '3431859');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431860, 4, '73656953627', 'U', null, 0, '3431860');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431861, 4, '73656953628', 'U', null, 0, '3431861');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431862, 4, '73656953629', 'N', null, 0, '3431862');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431863, 4, '73656953630', 'U', null, 0, '3431863');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431864, 4, '73656953631', 'U', null, 0, '3431864');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431865, 4, '73656953632', 'U', null, 0, '3431865');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431866, 4, '73656953633', 'N', null, 0, '3431866');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431867, 4, '73656953634', 'U', null, 0, '3431867');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431868, 4, '73656953635', 'U', null, 0, '3431868');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431869, 4, '73656953636', 'U', null, 0, '3431869');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431870, 4, '73656953637', 'U', null, 0, '3431870');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431871, 4, '73656953638', 'U', null, 0, '3431871');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431872, 4, '73656953639', 'U', null, 0, '3431872');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431873, 4, '73656953640', 'U', null, 0, '3431873');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431874, 4, '73656953641', 'N', null, 0, '3431874');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431875, 4, '73656953642', 'N', null, 0, '3431875');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431876, 4, '73656953643', 'N', null, 0, '3431876');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431877, 4, '73656953644', 'N', null, 0, '3431877');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431878, 4, '73656953645', 'U', null, 0, '3431878');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431879, 4, '73656953646', 'N', null, 0, '3431879');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431880, 4, '73656953647', 'U', null, 0, '3431880');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431881, 4, '73656953648', 'U', null, 0, '3431881');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431882, 4, '73656953649', 'U', null, 0, '3431882');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431883, 4, '73656953650', 'U', null, 0, '3431883');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431884, 4, '73656953651', 'U', null, 0, '3431884');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431885, 4, '73656953652', 'N', null, 0, '3431885');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431886, 4, '73656953653', 'U', null, 0, '3431886');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431887, 4, '73656953654', 'N', null, 0, '3431887');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431888, 4, '73656953655', 'U', null, 0, '3431888');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431889, 4, '73656953656', 'U', null, 0, '3431889');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431890, 4, '73656953657', 'U', null, 0, '3431890');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431891, 4, '73656953658', 'U', null, 0, '3431891');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431892, 4, '73656953659', 'U', null, 0, '3431892');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431893, 4, '73656953660', 'U', null, 0, '3431893');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431894, 4, '73656953661', 'U', null, 0, '3431894');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431895, 4, '73656953662', 'U', null, 0, '3431895');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431896, 4, '73656953663', 'U', null, 0, '3431896');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431897, 4, '73656953664', 'U', null, 0, '3431897');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431898, 4, '73656953665', 'U', null, 0, '3431898');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431899, 4, '73656953666', 'U', null, 0, '3431899');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431900, 4, '73656953667', 'U', null, 0, '3431900');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431901, 4, '73656953668', 'U', null, 0, '3431901');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431902, 4, '73656953669', 'U', null, 0, '3431902');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431903, 4, '73656953670', 'U', null, 0, '3431903');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431904, 4, '73656953671', 'U', null, 0, '3431904');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431905, 4, '73656953672', 'U', null, 0, '3431905');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431906, 4, '73656953673', 'U', null, 0, '3431906');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431907, 4, '73656953674', 'N', null, 0, '3431907');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431908, 4, '73656953675', 'U', null, 0, '3431908');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431909, 4, '73656953676', 'U', null, 0, '3431909');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431910, 4, '73656953677', 'U', null, 0, '3431910');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431911, 4, '73656953678', 'U', null, 0, '3431911');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431912, 4, '73656953679', 'U', null, 0, '3431912');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431913, 4, '73656953680', 'U', null, 0, '3431913');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431914, 4, '73656953681', 'U', null, 0, '3431914');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431915, 4, '73656953682', 'U', null, 0, '3431915');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431916, 4, '73656953683', 'U', null, 0, '3431916');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431917, 4, '73656953684', 'U', null, 0, '3431917');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431918, 4, '73656953685', 'N', null, 0, '3431918');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3431919, 4, '73656953686', 'U', null, 0, '3431919');
  
  
  insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (1846440, '2018-03-15 14:27:15', '2015-05-01 00:00:00', 20172842, 3960660, 2, 'A', '2015-05-01 00:00:00', null, 2311, 2000, '0102070000195161');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (1846440, '2018-03-15 14:28:11', '2018-03-15 14:27:15', 64463690, 3960660, 2, 'A', '2015-05-01 00:00:00', null, 2311, 2000, '0102070000195162');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (1846440, '2500-01-01 00:00:00', '2018-03-15 14:28:11', 64463705, 3960660, 2, 'A', '2015-05-01 00:00:00', null, 2311, 2000, '0102070000195163');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2115422, '2016-07-01 00:00:00', '2015-05-01 00:00:00', 36329202, 3830912, 1, 'A', '2015-05-01 00:00:00', null, 2327, 1, '0103120000120150_MG');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2115422, '2018-03-15 00:00:00', '2016-07-01 00:00:00', 52403265, 3830912, 1, 'C', '2015-05-01 00:00:00', null, 2327, 1, '0103120000120150_MG');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2115422, '2500-01-01 00:00:00', '2018-03-15 00:00:00', 64446601, 3830912, null, 'C', '2015-05-01 00:00:00', null, 2327, 1, '0103120000120150_MG');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2325376, '2018-03-15 13:47:39', '2016-05-04 00:00:00', 49376369, 4085961, 1, 'A', '2016-05-04 00:00:00', null, 1, 2020, '0133000070006150_MOB');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2325376, '2500-01-01 00:00:00', '2018-03-15 13:47:39', 64463208, 4085961, 1, 'C', '2016-05-04 00:00:00', null, 1, 2020, '0133000070006150_MOB');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2340751, '2018-03-15 14:42:51', '2016-08-02 00:00:00', 53903427, 4092160, 1, 'A', '2016-08-02 00:00:00', null, 2309, 2020, '0133000000049669_MOB');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2340751, '2500-01-01 00:00:00', '2018-03-15 14:42:51', 64463902, 4092160, 1, 'C', '2016-08-02 00:00:00', null, 2309, 2020, '0133000000049669_MOB');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2369061, '2017-04-11 14:16:45', '2017-01-01 00:00:00', 58937836, 4007335, 2, 'A', '2017-02-20 00:00:00', null, 2315, 2001, '0102100000088207_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2369061, '2018-01-01 00:00:00', '2017-04-11 14:16:45', 59432866, 4007335, 2, 'A', '2017-02-20 00:00:00', null, 2315, 2001, '0102100000088207_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2369061, '2018-03-15 14:05:08', '2018-01-01 00:00:00', 64154346, 4007335, 2, 'C', '2017-02-20 00:00:00', null, 2315, 2001, '0102100000088207_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2369061, '2500-01-01 00:00:00', '2018-03-15 14:05:08', 64463384, 4007335, 2, 'C', '2018-03-13 00:00:00', null, 2315, 2001, '0102100000088207_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2374554, '2017-08-21 00:00:00', '2017-04-20 00:00:00', 59649886, 4007035, 1, 'A', '2017-04-20 00:00:00', null, 2305, 2020, '0102060000104290_MOB');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2374554, '2018-03-13 10:12:47', '2017-08-21 00:00:00', 61392437, 4007035, 1, 'A', '2017-04-20 00:00:00', null, 2305, 2020, '0102060000104290_MOB');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2374554, '2018-03-15 00:00:00', '2018-03-13 10:12:47', 64436123, 4007035, 1, 'A', '2017-02-28 00:00:00', null, 2305, 2020, '0102060000104290_MOB');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2374554, '2018-03-15 15:26:22', '2018-03-15 00:00:00', 64464136, 4007035, 1, 'A', '2018-02-28 00:00:00', null, 2305, 2020, '0102060000104290_MOB');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2374554, '2500-01-01 00:00:00', '2018-03-15 15:26:22', 64464135, 4007035, null, 'A', '2017-02-28 00:00:00', null, 2305, 2020, '0102060000104290_MOB');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2399282, '2018-03-15 14:31:22', '2018-01-01 00:00:00', 63567024, 4005528, 1, 'A', '2018-01-01 00:00:00', null, 2316, 2001, '0101030000161273_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2399282, '2500-01-01 00:00:00', '2018-03-15 14:31:22', 64463755, 4005528, null, 'A', '2018-02-09 00:00:00', null, 2316, 2001, '0101030000161273_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2400700, '2018-03-15 14:27:14', '2018-01-01 00:00:00', 63728779, 4006208, 2, 'A', '2018-01-26 00:00:00', null, 2315, 2001, '0102100000166477_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2400700, '2500-01-01 00:00:00', '2018-03-15 14:27:14', 64463689, 4006208, 2, 'A', '2018-01-26 00:00:00', null, 2315, 2001, '0102100000166477_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2400721, '2018-03-15 14:37:39', '2018-01-01 00:00:00', 63729345, 4004657, 1, 'A', '2018-01-26 00:00:00', null, 2315, 2001, '0102100000166461_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2400721, '2500-01-01 00:00:00', '2018-03-15 14:37:39', 64463819, 4004657, 1, 'A', '2018-01-26 00:00:00', null, 2315, 2001, '0102100000166461_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2402307, '2018-03-15 14:41:35', '2018-01-01 00:00:00', 63958589, 4066730, 1, 'A', '2018-02-05 00:00:00', null, 2315, 2001, '0102100000169559_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2402307, '2500-01-01 00:00:00', '2018-03-15 14:41:35', 64463858, 4066730, 2, 'A', '2018-02-05 00:00:00', null, 2315, 2001, '0102100000169559_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2402308, '2018-03-15 14:35:26', '2018-01-01 00:00:00', 63958600, 4007283, 1, 'A', '2018-01-18 00:00:00', null, 2315, 2001, '0102100000162634_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2402308, '2500-01-01 00:00:00', '2018-03-15 14:35:26', 64463786, 4007283, 2, 'A', '2018-01-18 00:00:00', null, 2315, 2001, '0102100000162634_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2403497, '2018-03-15 15:25:00', '2018-01-01 00:00:00', 64087182, 4005402, 1, 'A', '2018-02-19 00:00:00', null, 2324, 2001, '0103000000173715_MG1');

insert into fw_contracts (ID_CONTRACT_INST, DT_STOP, DT_START, ID_REC, ID_CLIENT_INST, ID_CURRENCY, V_STATUS, DT_REG_EVENT, V_DESCRIPTION, ID_DEPARTMENT, ID_CATEGORY, V_EXT_IDENT)
values (2403497, '2500-01-01 00:00:00', '2018-03-15 15:25:00', 64464128, 4005402, 1, 'A', '2018-02-19 00:00:00', null, 2324, 2001, '0103000000173715_MG1');


insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (1, null, 'ГУП РК "Крымтелеком"', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2304, 2326, 'ЦТУ АЛУШТА', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2305, 2312, 'ЦТУ АРМЯНСК', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2306, 1, 'ЦТУ №5', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2307, 1, 'ЦТУ №14', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2308, 2312, 'ЦТУ ДЖАНКОЙ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2309, 1, 'ЦТУ"ЗАПАД" ЕВПАТОРИЯ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2310, 1, 'ЦТУ"ВОСТОК" КЕРЧЬ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2311, 2312, 'ЦТУ КРАСНОГВАРДЕЙСКОЕ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2312, 1, 'ЦТУ"СЕВЕР" КРАСНОПЕРЕКОПСК', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2313, 2310, 'ЦТУ ЛЕНИНО', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2314, 2312, 'ЦТУ НИЖНЕГОРСКИЙ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2315, 2312, 'ЦТУ  ПЕРВОМАЙСКОЕ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2316, 2309, 'ЦТУ РАЗДОЛЬНОЕ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2317, 2309, 'ЦТУ САКИ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2318, 1, 'ЦТУ№1', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2319, 1, 'АРЕНДА КАНАЛОВ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2320, 1, 'АППАРАТ УПРАВЛЕНИЯ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2321, 1, 'АРЕНДА КАБЕЛЬНОЙ КАНАЛИЗАЦИИ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2322, 2310, 'ЦТУ СОВЕТСКИЙ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2323, 2326, 'ЦТУ СУДАК', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2324, 2310, 'ЦТУ ФЕОДОСИЯ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2325, 2309, 'ЦТУ ЧЕРНОМОРСКОЕ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2326, 1, 'ЦТУ"ЮГ" ЯЛТА', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2327, 2310, 'ЦТУ КИРОВСКОЕ', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2340, 1, 'СЛУЖЕБНЫЕ Аппарат управления', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2347, 2341, 'СЛУЖЕБНЫЕ Коммерческая дирекция Руководство', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2366, 2340, 'СЛУЖЕБНЫЕ Дирекция по вопросам труда и персонала', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2368, 2366, 'СЛУЖЕБНЫЕ Отдел организации нормирования и оплаты труда', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2381, 2370, 'СЛУЖЕБНЫЕ Отдел пожарной безопасности/ мобилизационной работы/ ГО и ЧС', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2385, 2382, 'СЛУЖЕБНЫЕ Отдел снабжения', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2390, 2340, 'СЛУЖЕБНЫЕ Дирекция Правовые вопросы', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2398, 2394, 'СЛУЖЕБНЫЕ Департамент по развитию IT и проектов', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2399, 2394, 'СЛУЖЕБНЫЕ Департамент поддержки IT-сервисов', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2421, 2354, 'СЛУЖЕБНЫЕ Отдел метрологии и измерений', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2460, 1, 'ИП Сулейманов Р.Р.', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2341, 2340, 'СЛУЖЕБНЫЕ Коммерческая дирекция', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2342, 2341, 'СЛУЖЕБНЫЕ Отдел маркетинга', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2343, 2341, 'СЛУЖЕБНЫЕ Отдел взаимодействия с операторами связи', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2346, 2341, 'СЛУЖЕБНЫЕ Отдел по обслуживанию потребителей', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2348, 2340, 'СЛУЖЕБНЫЕ Направление директора', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2351, 2348, 'СЛУЖЕБНЫЕ Отдел управления имущественным комплексом', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2352, 2348, 'СЛУЖЕБНЫЕ Группа при руководстве', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2354, 2340, 'СЛУЖЕБНЫЕ Техническая дирекция', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2355, 2354, 'СЛУЖЕБНЫЕ Техническая дирекция Руководство', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2357, 2354, 'СЛУЖЕБНЫЕ Отдел планирования и развития сетей', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2358, 2354, 'СЛУЖЕБНЫЕ Отдел управления и мониторинга сети', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2359, 2354, 'СЛУЖЕБНЫЕ Отдел главного энергетика', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2361, 2360, 'СЛУЖЕБНЫЕ  Финансовая дирекция Руководство', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2364, 2360, 'СЛУЖЕБНЫЕ Отдел казначейства', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2365, 2360, 'СЛУЖЕБНЫЕ Отдел тарифов и ценообразования', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2370, 2340, 'СЛУЖЕБНЫЕ Дирекция Безопасность', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2382, 2340, 'СЛУЖЕБНЫЕ Дирекция Административно-хозяйственное обеспечение', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2396, 2394, 'СЛУЖЕБНЫЕ Департамент по пакетной коммутации и технической инфраструктуры', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2400, 1, 'СЛУЖЕБНЫЕ ЦСБН', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2420, 2354, 'СЛУЖЕБНЫЕ Департамент транспортной сети', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2422, 2354, 'СЛУЖЕБНЫЕ Группа операционного сопровождения', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2442, 1, 'Дилер г.Феодосия 03-01', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2344, 2341, 'СЛУЖЕБНЫЕ Отдел продажи услуг массового сегмента', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2349, 2348, 'СЛУЖЕБНЫЕ Директорат', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2350, 2348, 'СЛУЖЕБНЫЕ Служба охраны труда', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2356, 2354, 'СЛУЖЕБНЫЕ Департамент коммутационной сети', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2362, 2360, 'СЛУЖЕБНЫЕ Бухгалтерия', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2372, 1, 'ЦТЭТТС', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2380, 2370, 'СЛУЖЕБНЫЕ Заместитель директора по безопасности', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2388, 2382, 'СЛУЖЕБНЫЕ Служба транспортных средств', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2389, 2382, 'СЛУЖЕБНЫЕ Менеджер-контактный управляющий', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2392, 2390, 'СЛУЖЕБНЫЕ Отдел договорно-правовой работы', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2393, 2390, 'СЛУЖЕБНЫЕ Отдел судебно-претензионной работы', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2441, 1, 'Дилер г.Евпатория 01-01', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2345, 2341, 'СЛУЖЕБНЫЕ Отдел продажи услуг бизнес-сегмента', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2353, 2348, 'СЛУЖЕБНЫЕ Проектно-строительный отдел', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2360, 2340, 'СЛУЖЕБНЫЕ Финансовая дирекция', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2363, 2360, 'СЛУЖЕБНЫЕ Планово-экономический отдел', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2367, 2366, 'СЛУЖЕБНЫЕ Дирекция по вопросам труда и персонала Руководство', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2369, 2366, 'СЛУЖЕБНЫЕ Отдел учёта и движения кадров', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2371, 2354, 'СЛУЖЕБНЫЕ Департамент радиосети', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2383, 2370, 'СЛУЖЕБНЫЕ Отдел безопасности', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2384, 2382, 'СЛУЖЕБНЫЕ Заместитель директора по административно-хозяйственному обеспечению', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2386, 2382, 'СЛУЖЕБНЫЕ Отдел координации закупок', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2387, 2382, 'СЛУЖЕБНЫЕ Отдел экологического и хозяйственного обеспечения', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2391, 2390, 'СЛУЖЕБНЫЕ Заместитель директора по правовым вопросам', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2394, 2340, 'СЛУЖЕБНЫЕ IT-Дирекция', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2395, 2394, 'СЛУЖЕБНЫЕ IT-Дирекция Директорат', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2397, 2394, 'СЛУЖЕБНЫЕ Департамент по IT-сервисам', 0);

insert into fw_departments (ID_DEPARTMENT, ID_PARENT, V_NAME, B_DELETED)
values (2440, 1, 'Дилер ЦТУ №3', 0);

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (2883399, 1846440, 1002, 2024, 386, 'A', 2051, null, 2134, null, '2016-08-29 14:27:13');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3310301, 1846440, 1002, 2024, 386, 'A', 2091, null, 2134, null, '2016-10-25 10:38:09');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (2431005, 1846440, 1002, 2024, 385.4, 'A', 2032, null, 2134, null, '2016-06-30 09:14:23');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (1965547, 1846440, 1002, 2024, 386.13, 'A', 2030, null, 2134, null, '2016-04-27 15:18:59');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (873192, 1846440, 1002, 2021, 1550, 'A', 2026, null, 2134, null, '2015-12-14 13:46:21');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (1770978, 1846440, 1002, 2024, 386, 'A', 2029, null, 2134, null, '2016-04-05 11:43:18');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (2651206, 1846440, 1002, 2024, 386.1, 'A', 2050, null, 2134, null, '2016-07-27 14:17:37');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (1728792, 1846440, 1002, 2024, 386, 'D', 2029, 2029, 2134, 2134, '2016-03-30 14:48:03');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (2206538, 1846440, 1002, 2024, 387, 'A', 2031, null, 2134, null, '2016-05-30 15:36:33');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3095554, 1846440, 1002, 2024, 346, 'A', 2071, null, 2134, null, '2016-09-27 10:39:28');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5417776, 1846440, 1002, 2024, 386, 'A', 2146, null, 2134, null, '2017-08-28 10:34:33');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (252136, 1846440, 1002, 2021, 772.26, 'A', 2022, null, 2004, null, '2015-08-12 17:17:11');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (417695, 1846440, 1002, 2021, 386.13, 'A', 2023, null, 2004, null, '2015-09-22 15:37:00');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (560431, 1846440, 1002, 2021, 400, 'A', 2024, null, 2134, null, '2015-10-21 14:26:51');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (1492682, 1846440, 1002, 2024, 340.94, 'A', 2028, null, 2134, null, '2016-03-01 16:49:30');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3966060, 1846440, 1002, 2024, 423, 'A', 2132, null, 2134, null, '2017-01-25 13:20:33');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3528017, 1846440, 1002, 2024, 356, 'A', 2111, null, 2134, null, '2016-11-23 15:56:28');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5818017, 1846440, 1028, 1028, 784.31, 'A', 2150, null, 213, null, '2017-10-26 11:13:20');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5237657, 1846440, 1002, 2024, 558, 'A', 2144, null, 2134, null, '2017-07-31 12:26:15');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (6243386, 1846440, 1002, 2024, 386.09, 'A', 2154, null, 2253, null, '2017-12-29 13:44:09');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4428415, 1846440, 1002, 2024, 386.14, 'A', 2136, null, 2134, null, '2017-03-31 14:50:49');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3766080, 1846440, 1002, 2024, 429, 'A', 2131, null, 2134, null, '2016-12-26 17:20:27');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5641798, 1846440, 1002, 2024, 355.33, 'A', 2148, null, 2253, null, '2017-10-02 09:17:37');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4275967, 1846440, 1002, 2024, 386, 'A', 2136, null, 2134, null, '2017-03-09 15:55:34');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4652124, 1846440, 1002, 2024, 386.14, 'A', 2140, null, 2134, null, '2017-05-03 14:47:49');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4796745, 1846440, 1002, 2024, 701, 'A', 2140, null, 2134, null, '2017-05-23 12:57:07');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (6620131, 1846440, 1002, 2024, 386.14, 'A', 2160, null, 3999, null, '2018-03-02 13:54:24');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5027133, 1846440, 1002, 2024, 385, 'A', 2142, null, 2134, null, '2017-06-28 10:28:48');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (6015396, 1846440, 1002, 2024, 374, 'A', 2152, null, 2253, null, '2017-11-24 15:38:33');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (6397542, 1846440, 1002, 2024, 386.14, 'A', 2156, null, 3999, null, '2018-01-26 15:39:18');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4127387, 2325376, 1002, 2001, 150, 'A', 2134, null, 3660, null, '2017-02-15 15:17:00');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3273618, 2325376, 1002, 2001, 150, 'A', 2091, null, 2253, null, '2016-10-19 10:16:34');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (2224391, 2325376, 1002, 2001, 650, 'A', 2031, null, 2222, null, '2016-06-01 14:57:51');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3031259, 2325376, 1002, 2001, 150, 'A', 2071, null, 2253, null, '2016-09-16 15:40:12');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4554430, 2325376, 1002, 2080, 150, 'A', 2138, null, 2253, null, '2017-04-18 14:37:25');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5346191, 2325376, 1002, 2080, 150, 'A', 2146, null, 2222, null, '2017-08-15 13:49:30');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3485647, 2325376, 1002, 2001, 150, 'A', 2111, null, 2222, null, '2016-11-17 11:31:09');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (6688234, 2325376, 1002, 2080, 150, 'A', 2160, null, 2222, null, '2018-03-14 13:15:05');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3715943, 2325376, 1002, 2001, 150, 'A', 2131, null, 2222, null, '2016-12-19 13:57:11');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3930169, 2325376, 1002, 2001, 150, 'A', 2132, null, 2222, null, '2017-01-20 14:06:39');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (6186605, 2325376, 1002, 2080, 150, 'A', 2154, null, 2222, null, '2017-12-20 13:57:25');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3801612, 2325376, 1002, 2001, 150, 'A', 2131, null, 2222, null, '2016-12-31 12:19:05');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5163006, 2325376, 1002, 2080, 150, 'A', 2144, null, 2222, null, '2017-07-18 14:03:21');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5732119, 2325376, 1002, 2080, 150, 'A', 2150, null, 2222, null, '2017-10-12 12:34:47');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4322902, 2325376, 1002, 2001, 150, 'A', 2136, null, 2222, null, '2017-03-15 13:05:49');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4747905, 2325376, 1002, 2080, 150, 'A', 2140, null, 2222, null, '2017-05-16 15:17:53');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (6545643, 2325376, 1002, 2080, 150, 'A', 2158, null, 2222, null, '2018-02-16 13:15:15');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4954984, 2325376, 1002, 2080, 150, 'A', 2142, null, 2222, null, '2017-06-16 11:55:20');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5541526, 2325376, 1002, 2080, 150, 'A', 2148, null, 2222, null, '2017-09-14 14:02:28');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5984635, 2325376, 1002, 2080, 150, 'A', 2152, null, 2222, null, '2017-11-20 12:57:48');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (6365520, 2325376, 1002, 2080, 150, 'A', 2156, null, 2222, null, '2018-01-22 12:43:01');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (2905993, 2340751, 1002, 1000, 300, 'A', 2071, null, 2177, null, '2016-09-01 10:45:18');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3350401, 2340751, 1002, 1000, 300, 'A', 2111, null, 2177, null, '2016-11-01 09:44:00');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4207426, 2340751, 1002, 1000, 900, 'A', 2136, null, 2177, null, '2017-03-01 08:28:53');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (2694930, 2340751, 1002, 1000, 300, 'A', 2051, null, 2177, null, '2016-08-02 16:23:17');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3115223, 2340751, 1002, 1000, 300, 'A', 2071, null, 2177, null, '2016-09-29 14:29:13');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3523202, 2340751, 1002, 1000, 300, 'A', 2111, null, 2177, null, '2016-11-23 10:31:38');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (6251901, 2340751, 1027, 1027, 336, 'A', 2156, null, 212, null, '2018-01-08 09:27:33');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (3819180, 2340751, 1002, 1000, 600, 'A', 2132, null, 2177, null, '2017-01-09 13:11:12');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5643530, 2340751, 1002, 1000, 900, 'A', 2150, null, 2177, null, '2017-10-02 10:21:29');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4837835, 2340751, 1002, 1000, 300, 'A', 2140, null, 2177, null, '2017-05-31 08:52:38');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5057827, 2340751, 1002, 2001, 900, 'A', 2144, null, 2222, null, '2017-07-05 11:52:22');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (6390333, 2340751, 1002, 1000, 900, 'A', 2156, null, 2177, null, '2018-01-25 15:47:34');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5372163, 2369061, 1002, 2080, 45.43, 'A', 2146, null, 2222, null, '2017-08-18 13:27:38');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4358816, 2369061, 1002, 2001, 151.93, 'A', 2136, null, 2222, null, '2017-03-21 13:56:15');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5190533, 2369061, 1002, 2080, 27.26, 'A', 2144, null, 2222, null, '2017-07-21 13:29:18');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4593660, 2369061, 1002, 2080, 166.68, 'A', 2138, null, 2222, null, '2017-04-24 14:33:33');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4787912, 2369061, 1002, 2080, 138.59, 'A', 2140, null, 2222, null, '2017-05-22 12:22:03');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (6179121, 2369061, 1002, 2080, 29.5, 'A', 2154, null, 2222, null, '2017-12-19 14:59:03');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5573438, 2369061, 1002, 2080, 53.81, 'A', 2148, null, 2222, null, '2017-09-19 14:23:14');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4984242, 2369061, 1002, 2080, 49.97, 'A', 2142, null, 2222, null, '2017-06-20 14:29:13');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5999107, 2369061, 1002, 2080, 72.78, 'A', 2152, null, 2222, null, '2017-11-22 13:04:18');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (6365317, 2369061, 1002, 2080, 100.69, 'A', 2156, null, 2222, null, '2018-01-22 12:43:01');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (5372669, 2374554, 1002, 2080, 750, 'A', 2146, null, 2222, null, '2017-08-18 13:27:38');

insert into trans_external (ID_TRANS, ID_CONTRACT, ID_TRANS_TYPE, ID_SOURCE, F_SUM, V_STATUS, ID_REPPERIOD_CREATION, ID_REPPERIOD_DELETION, ID_MANAGER, ID_MANAGER_DELETE, DT_EVENT)
values (4960804, 2374554, 1002, 2080, 150, 'A', 2142, null, 2222, null, '2017-06-16 15:44:27');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (19170606, 4699829, 4, '2015-05-01 00:00:00', '2015-06-13 00:13:18', '2500-01-01 00:00:00', null, 0, 2, 2977749, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (19243087, 4714140, 4, '2015-05-01 00:00:00', '2015-06-13 00:15:26', '2500-01-01 00:00:00', null, 0, 2, 2992060, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (25502598, 6049273, 4, '2015-05-01 00:00:00', '2015-06-23 11:04:16', '2016-06-02 00:00:00', 3536727, 0, 2, 2992160, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (25502526, 6049201, 4, '2015-05-01 00:00:00', '2015-06-23 11:04:16', '2500-01-01 00:00:00', null, 0, 2, 2969551, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (19243470, 4714240, 4, '2015-05-01 00:00:00', '2015-06-13 00:15:26', '2016-02-12 00:00:00', 3539955, 0, 2, 2992160, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (19347328, 4743642, 4, '2015-05-01 00:00:00', '2015-06-13 00:17:44', '2016-04-28 00:00:00', 3541863, 0, 2, 3021562, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (19488660, 4843010, 4, '2015-05-01 00:00:00', '2015-06-13 00:23:24', '2500-01-01 00:00:00', null, 0, 2, 3120930, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (19412670, 4800830, 4, '2015-05-01 00:00:00', '2015-06-13 00:20:28', '2015-07-15 00:00:00', 3548337, 0, 2, 3078750, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (19519896, 4860026, 4, '2015-05-01 00:00:00', '2015-06-13 00:24:58', '2016-08-21 00:00:00', 3550139, 0, 2, 3137946, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (22081356, 5581081, 2004, '2015-05-01 00:00:00', '2015-06-13 08:40:36', '2500-01-01 00:00:00', null, 0, 2, 3562825, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (22085348, 5583592, 2004, '2015-05-01 00:00:00', '2015-06-13 08:40:41', '2500-01-01 00:00:00', null, 0, 2, 3563856, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (22178339, 5641482, 2004, '2015-05-01 00:00:00', '2015-06-13 08:42:01', '2500-01-01 00:00:00', null, 0, 2, 3586654, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (62352829, 7227799, 2025, '2017-09-29 00:00:00', '2017-09-29 11:29:24', '2500-01-01 00:00:00', null, 0, 2062, 4048356, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63085995, 7240563, 4, '2018-03-01 00:00:00', '2017-12-07 11:57:12', '2500-01-01 00:00:00', null, 0, 50467, 3323509, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63723082, 7277371, 4, '2018-03-01 00:00:00', '2018-01-26 11:46:59', '2500-01-01 00:00:00', null, 0, 47907, 3271115, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785564, 7282178, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042840, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785565, 7282179, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042841, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785566, 7282180, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042842, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785567, 7282181, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042843, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785568, 7282182, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042844, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785569, 7282183, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042845, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785570, 7282184, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042846, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785571, 7282185, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042847, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785572, 7282186, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042848, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785573, 7282187, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042850, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785574, 7282188, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042851, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785575, 7282189, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042852, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785576, 7282190, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042853, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785577, 7282191, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042854, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785578, 7282192, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042855, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785579, 7282193, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042856, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63785580, 7282194, 2061, '2018-01-01 00:00:00', '2018-01-29 16:00:02', '2018-03-01 00:00:00', 6514031, 0, 2112, 3042839, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046255, 7282194, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', null, 0, 2112, 3042839, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046256, 7282178, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', null, 0, 2112, 3042840, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046257, 7282179, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', 6514031, 0, 2112, 3042841, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046258, 7282180, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', null, 0, 2112, 3042842, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046259, 7282181, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', null, 0, 2112, 3042843, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046260, 7282182, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', null, 0, 2112, 3042844, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046261, 7282183, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', null, 0, 2112, 3042845, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046262, 7282184, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', null, 0, 2112, 3042846, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046263, 7282185, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', 6514031, 0, 2112, 3042847, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046264, 7282186, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', null, 0, 2112, 3042848, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046265, 7282187, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', null, 0, 2112, 3042850, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046266, 7282188, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', null, 0, 2112, 3042851, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046267, 7282189, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', null, 0, 2112, 3042852, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046268, 7282190, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', null, 0, 2112, 3042853, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046269, 7282191, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', null, 0, 2112, 3042854, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046270, 7282192, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', 6514031, 0, 2112, 3042855, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64046271, 7282193, 2061, '2018-03-01 00:00:00', '2018-02-15 17:04:56', '2500-01-01 00:00:00', 6514031, 0, 2112, 3042856, 'U');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63922179, 7288822, 4, '2018-02-28 00:00:00', '2018-02-05 11:30:41', '2500-01-01 00:00:00', null, 0, 52582, 3344667, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63940139, 7289327, 4, '2018-03-01 00:00:00', '2018-02-06 11:51:24', '2500-01-01 00:00:00', null, 0, 50467, 3277001, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63960810, 7290156, 4, '2018-03-01 00:00:00', '2018-02-07 17:05:44', '2500-01-01 00:00:00', null, 0, 50467, 3271312, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63967375, 7290298, 4, '2018-03-01 00:00:00', '2018-02-08 11:00:04', '2500-01-01 00:00:00', null, 0, 50467, 3323376, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63971667, 7290481, 4, '2018-03-29 00:00:00', '2018-02-08 15:21:59', '2500-01-01 00:00:00', null, 0, 52582, 3408029, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63985775, 7291094, 4, '2018-03-01 00:00:00', '2018-02-09 16:46:44', '2500-01-01 00:00:00', null, 0, 50467, 3266475, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63985782, 7291095, 2004, '2018-03-01 00:00:00', '2018-02-09 16:46:45', '2500-01-01 00:00:00', null, 0, 50467, 3566921, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (63989315, 7291096, 4, '2018-03-01 00:00:00', '2018-02-10 15:04:29', '2500-01-01 00:00:00', null, 0, 50467, 3293392, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64056345, 7294155, 4, '2018-03-01 00:00:00', '2018-02-16 11:01:53', '2500-01-01 00:00:00', null, 0, 47907, 3312807, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64095406, 7295554, 4, '2018-03-01 00:00:00', '2018-02-20 09:48:51', '2500-01-01 00:00:00', null, 0, 50467, 3337948, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64096948, 7295632, 4, '2018-03-01 00:00:00', '2018-02-20 10:33:06', '2500-01-01 00:00:00', null, 0, 50467, 3267053, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64283116, 7127238, 4, '2018-04-01 00:00:00', '2018-03-02 17:34:14', '2500-01-01 00:00:00', null, 0, 2, 4041338, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64292089, 7138737, 4, '2018-04-01 00:00:00', '2018-03-05 17:57:46', '2500-01-01 00:00:00', null, 0, 2, 4043476, 'W');

insert into fw_service_identifiers (ID_REC, ID_SERVICE_IDENTIFIER_INST, ID_SERVICE_IDENTIFIER, DT_START, DT_UPDATED, DT_STOP, ID_SERVICE_INST, B_DELETED, ID_MANAGER, ID_IDENTIFIER, V_STATUS)
values (64345673, 7190088, 4, '2018-03-23 00:00:00', '2018-03-23 09:32:34', '2500-01-01 00:00:00', null, 0, 51137, 3250108, 'W');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (2969551, 4, '73652254422', 'U', null, 0, '2969551');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (2977749, 4, '73652256289', 'U', null, 0, '2977749');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (2992060, 4, '73652275790', 'U', null, 0, '2992060');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (2992160, 4, '73652275890', 'U', null, 0, '2992160');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3021562, 4, '73652263510', 'U', null, 0, '3021562');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042839, 2061, '73652604930', 'U', null, 0, '3042839');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042840, 2061, '73652604931', 'U', null, 0, '3042840');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042841, 2061, '73652604932', 'U', null, 0, '3042841');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042842, 2061, '73652604933', 'U', null, 0, '3042842');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042843, 2061, '73652604934', 'U', null, 0, '3042843');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042844, 2061, '73652604935', 'U', null, 0, '3042844');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042845, 2061, '73652604936', 'U', null, 0, '3042845');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042846, 2061, '73652604937', 'U', null, 0, '3042846');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042847, 2061, '73652604938', 'U', null, 0, '3042847');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042848, 2061, '73652604939', 'U', null, 0, '3042848');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042850, 2061, '73652604941', 'U', null, 0, '3042850');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042851, 2061, '73652604942', 'U', null, 0, '3042851');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042852, 2061, '73652604943', 'U', null, 0, '3042852');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042853, 2061, '73652604944', 'U', null, 0, '3042853');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042854, 2061, '73652604945', 'U', null, 0, '3042854');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042855, 2061, '73652604946', 'U', null, 0, '3042855');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3042856, 2061, '73652604947', 'U', null, 0, '3042856');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3078750, 4, '73654233741', 'U', null, 0, '3078750');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3120930, 4, '73654260854', 'U', null, 0, '3120930');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3137946, 4, '73654245596', 'U', null, 0, '3137946');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3250108, 4, '73655740054', 'U', null, 0, '3250108');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3266475, 4, '73656166198', 'U', null, 0, '3266475');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3267053, 4, '73656120942', 'U', null, 0, '3267053');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3271115, 4, '73656128142', 'U', null, 0, '3271115');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3271312, 4, '73656172667', 'U', null, 0, '3271312');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3277001, 4, '73656127720', 'U', null, 0, '3277001');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3293392, 4, '73656124773', 'U', null, 0, '3293392');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3312807, 4, '73656168436', 'U', null, 0, '3312807');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3323376, 4, '73656171238', 'U', null, 0, '3323376');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3323509, 4, '73656171371', 'U', null, 0, '3323509');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3337948, 4, '73656161696', 'U', null, 0, '3337948');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3344667, 4, '73656441005', 'U', null, 0, '3344667');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3408029, 4, '73656438142', 'U', null, 0, '3408029');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3562825, 2004, 'rdvon_4431.56@dsl.ukrtel.net', 'U', 'internet', 0, '3562825');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3563856, 2004, 'ajgecr.61@dsl.ukrtel.net', 'U', 'internet', 0, '3563856');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3566921, 2004, 'qlmsf.61@dsl.ukrtel.net', 'U', 'internet', 0, '3566921');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3586654, 2004, 'riap.61@dsl.ukrtel.net', 'U', 'internet', 0, '3586654');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (4041338, 4, '1-14', 'U', null, 0, '4041338');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (4043476, 4, '1-28', 'U', null, 0, '4043476');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (4048356, 2025, '4.137101@fttb.ktkru.ru', 'U', '71017101', 0, '4048356');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3572574, 2004, 'eugkb_8332@dsl.ukrtel.net', 'U', 'internet', 0, '3572574');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3572575, 2004, '312477.01@dsl.ukrtel.net', 'U', 'internet', 0, '3572575');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3572576, 2004, 'olga27174@dsl.ukrtel.net', 'U', null, 0, '3572576');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3572577, 2004, '573151.01@dsl.ukrtel.net', 'U', 'internet', 0, '3572577');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3572578, 2004, '6933961.01@dsl.ukrtel.net', 'U', 'internet', 0, '3572578');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3572579, 2004, '631356.01@dsl.ukrtel.net', 'U', null, 0, '3572579');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3572580, 2004, '570304.01@dsl.ukrtel.net', 'U', 'internet', 0, '3572580');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3572581, 2004, '312083.01@dsl.ukrtel.net', 'U', '12345678', 0, '3572581');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3572582, 2004, '514571@dsl.ukrtel.net', 'U', null, 0, '3572582');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3572583, 2004, '521870.01@dsl.ukrtel.net', 'U', null, 0, '3572583');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3572584, 2004, '220751.02@dsl.ukrtel.net', 'U', '12345678', 0, '3572584');

insert into fw_identifiers (ID_IDENTIFIER, ID_SERVICE_IDENTIFIER, V_VALUE, V_STATUS, V_PASS, B_DELETED, V_EXT_IDENT)
values (3572585, 2004, '600346.01@dsl.ukrtel.net', 'U', null, 0, '3572585');
