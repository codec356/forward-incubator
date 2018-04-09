CREATE OR REPLACE PACKAGE commutator IS
    procedure SAVECOMMUTATOR(
                        PID_COMMUTATOR IN INCB_COMMUTATOR.ID_COMMUTATOR%TYPE,
                        PIP_ADDRESS in INCB_COMMUTATOR.IP_ADDRESS%type,
                        PID_COMMUTATOR_TYPE in INCB_COMMUTATOR.ID_COMMUTATOR_TYPE%type,
                        PV_DESCRTIPTION in INCB_COMMUTATOR.V_DESCRIPTION%type,
                        PB_DELETED in INCB_COMMUTATOR.B_DELETED%type,
                        PV_MAC_ADDRESS in INCB_COMMUTATOR.V_MAC_ADDRESS%type,
                        PV_COMMUNITY_READ in INCB_COMMUTATOR.V_COMMUNITY_READ%type,
                        PV_COMMUNITY_WRITE in INCB_COMMUTATOR.V_COMMUNITY_WRITE%type,
                        PREMOTE_ID in INCB_COMMUTATOR.REMOTE_ID%type,
                        PB_NEED_CONVERT_HEX in INCB_COMMUTATOR.B_NEED_CONVERT_HEX%type,
                        premote_id_hex in INCB_COMMUTATOR.REMOTE_ID_HEX%type,
                        PACTION in char);
    PROCEDURE getcommutator (
    pip_address           IN incb_commutator.ip_address%TYPE,
    pid_commutator_type   IN incb_commutator.id_commutator_type%TYPE,
    pv_mac_address        IN incb_commutator.v_mac_address%TYPE,
    dwr                   OUT SYS_REFCURSOR);
    function CHECKIP (ip_address in varchar2) return number;
    procedure check_and_del_data (b_force_delete in number, cnt out number);
END commutator;
/


CREATE OR REPLACE package body commutator is 
procedure SAVECOMMUTATOR(
                        PID_COMMUTATOR IN INCB_COMMUTATOR.ID_COMMUTATOR%TYPE,
                        PIP_ADDRESS in INCB_COMMUTATOR.IP_ADDRESS%type,
                        PID_COMMUTATOR_TYPE in INCB_COMMUTATOR.ID_COMMUTATOR_TYPE%type,
                        PV_DESCRTIPTION in INCB_COMMUTATOR.V_DESCRIPTION%type,
                        PB_DELETED in INCB_COMMUTATOR.B_DELETED%type,
                        PV_MAC_ADDRESS in INCB_COMMUTATOR.V_MAC_ADDRESS%type,
                        PV_COMMUNITY_READ in INCB_COMMUTATOR.V_COMMUNITY_READ%type,
                        PV_COMMUNITY_WRITE in INCB_COMMUTATOR.V_COMMUNITY_WRITE%type,
                        PREMOTE_ID in INCB_COMMUTATOR.REMOTE_ID%type,
                        PB_NEED_CONVERT_HEX in INCB_COMMUTATOR.B_NEED_CONVERT_HEX%type,
                        premote_id_hex in INCB_COMMUTATOR.REMOTE_ID_HEX%type,
                        PACTION in char) is
                        L_CNT integer;

begin
case PACTION 
    when 'c' then
    if checkip(pip_address)=0 
    then raise_application_error('-20002', 'IP адрес введен неверно');
    end if;
        if PID_COMMUTATOR_TYPE is null
        or PV_COMMUNITY_READ is null
        or PV_COMMUNITY_WRITE is null
        or PIP_ADDRESS is null
        or PV_MAC_ADDRESS is null
        then 
            RAISE_APPLICATION_ERROR(-20098, 'V_COMMUNITY_READ or V_COMMUNITY_WRITE or IP_ADDRESS or V_MAC_ADDRESS is null');
        end if;

        select count(1)
        into L_CNT
        from INCB_COMMUTATOR
            where B_DELETED = 0 
            and PIP_ADDRESS=IP_ADDRESS;
        if L_CNT!=0 then 
            RAISE_APPLICATION_ERROR(-20100, 'IP isnt unique');
        end if;

        select count(1)
        into L_CNT
        from INCB_COMMUTATOR
            where B_DELETED = 0 
            and PV_MAC_ADDRESS=V_MAC_ADDRESS;
        if L_CNT!=0 then 
            RAISE_APPLICATION_ERROR(-20099, 'MAC isnt unique');
        end if;



        if PB_NEED_CONVERT_HEX=1 and PREMOTE_ID_HEX is null 
        then
        RAISE_APPLICATION_ERROR(-20096, 'Remote id is null');
        else
            if PB_NEED_CONVERT_HEX=0 and PREMOTE_ID is null
            then 
            RAISE_APPLICATION_ERROR(-20096, 'Remote id is null');
            else
                insert into INCB_COMMUTATOR (
                        ID_COMMUTATOR,
                        IP_ADDRESS,
                        ID_COMMUTATOR_TYPE,
                        V_DESCRIPTION,
                        B_DELETED,
                        V_MAC_ADDRESS,
                        V_COMMUNITY_READ,
                        V_COMMUNITY_WRITE,
                        REMOTE_ID,
                        B_NEED_CONVERT_HEX,
                        REMOTE_ID_HEX)

                values (    nvl(S_INCB_COMMUTATOR.nextval,0),
                        PIP_ADDRESS,
                        PID_COMMUTATOR_TYPE,
                        PV_DESCRTIPTION,
                        PB_DELETED,
                        PV_MAC_ADDRESS,
                        PV_COMMUNITY_READ,
                        PV_COMMUNITY_WRITE,
                        PREMOTE_ID,
                        PB_NEED_CONVERT_HEX,
                        PREMOTE_ID_HEX);
        end if;
        end if;
    when 'u' then
        if PIP_ADDRESS is null or PV_MAC_ADDRESS is null
        then RAISE_APPLICATION_ERROR(-20095, 'ip or mac is null');
        end if;
        if PB_NEED_CONVERT_HEX=1 and PREMOTE_ID_HEX is null then
        RAISE_APPLICATION_ERROR(-20096, 'Remote id is null');
        else
            if PB_NEED_CONVERT_HEX=0 and PREMOTE_ID is null then
            RAISE_APPLICATION_ERROR(-20096, 'Remote id is null');

            else
                update INCB_COMMUTATOR 

                set     ID_COMMUTATOR_TYPE=PID_COMMUTATOR_TYPE,
                        V_DESCRIPTION=PV_DESCRTIPTION,
                        B_DELETED=PB_DELETED,
                        V_COMMUNITY_READ=PV_COMMUNITY_READ,
                        V_COMMUNITY_WRITE=PV_COMMUNITY_WRITE,
                        REMOTE_ID=PREMOTE_ID,
                        B_NEED_CONVERT_HEX=PB_NEED_CONVERT_HEX,
                        REMOTE_ID_HEX=PREMOTE_ID_HEX

                where   PIP_ADDRESS=IP_ADDRESS                     
                or      PV_MAC_ADDRESS=V_MAC_ADDRESS;   

            end if;
        end if;
    when 'd' then 
        delete from INCB_COMMUTATOR 
        where           IP_ADDRESS=PIP_ADDRESS
        or              ID_COMMUTATOR=PID_COMMUTATOR
        or              B_DELETED=PB_DELETED
        or              V_MAC_ADDRESS=PV_MAC_ADDRESS;
end case;
end savecommutator;


PROCEDURE getcommutator (
    pip_address           IN incb_commutator.ip_address%TYPE,
    pid_commutator_type   IN incb_commutator.id_commutator_type%TYPE,
    pv_mac_address        IN incb_commutator.v_mac_address%TYPE,
    dwr                   OUT SYS_REFCURSOR
)
    IS
BEGIN
    OPEN dwr FOR SELECT *
        FROM  incb_commutator
        WHERE ip_address = pip_address
        or    v_mac_address = pv_mac_address;

END getcommutator;


PROCEDURE check_and_del_data (b_force_delete in number,
                                                cnt out number) is

type idtab is table of INCB_COMMUTATOR.ID_COMMUTATOR%type;
id_com idtab;
begin 
select id_commutator
bulk COLLECT into id_com
from
(
select ID_COMMUTATOR, 
    ip_address, DENSE_RANK() over (partition by ip_address order by id_commutator) as dip, 
    V_MAC_ADDRESS, dense_rank() over (partition by v_mac_address order by id_commutator) as dmc 
from INCB_COMMUTATOR
where b_deleted=0
order by id_commutator)
where dip>=2
or dmc >=2
or checkip(ip_address)!=1;
case b_force_delete
    when 0 then 
    cnt:=id_com.count;

    when 1 then 
    for i in 1..id_com.count loop
    --if id_com.exists(i) then 
        savecommutator(id_com(i),null,null,null,null,null,null,null,null,null,null,'d');
   -- end if;
    end loop;
        cnt:=id_com.count;
    end case;

end check_and_del_data;


function CHECKIP (ip_address in varchar2)
return number is
cnt number:=0;
i number:=1;
begin
    while (i<=length(ip_address)) loop
        if instr('0123456789.',substr(ip_address,i,1))>0
        then i:=i+1;
        else return 0;
        end if;
        if substr(ip_address,i,1)='.' then cnt:=cnt+1;
        end if;
    end loop;
if cnt=3 then return 1;
else return 0;
end if;
end checkip;

end commutator;
/
