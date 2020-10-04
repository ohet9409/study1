select mem.userid, userpw, username, enabled, regdate, updatedate, auth 
		from tbl_member mem LEFT OUTER JOIN tbl_member_auth auth on mem.userid = auth.userid
		where mem.userid = 'admin90';

create table tbl_member(
    userid  varchar2(50) not null primary key,
    userpw  varchar2(100) not null,
    username varchar2(100) not null,
    regdate date default sysdate,
    updatedate date default sysdate,
    enabled char(1) default '1'
);

//admin90 / pw90
select * from tbl_member;
select * from tbl_member_auth;

create table tbl_member_auth(
    userid varchar2(50) not null,
    auth varchar2(50) not null,
    CONSTRAINT fk_member_auth FOREIGN key (userid) REFERENCES tbl_member(userid)
);

create table users(
    username varchar2(50) not null primary key,
    password varchar2(50) not null,
    enabled char(1) default '1'
);

drop table users;
drop table authorities;

create table authorities(
    username varchar2(50) not null,
    authority varchar2(50) not null,
    CONSTRAINT fk_authorities_users foreign key(username) REFERENCES users(username)
);

create unique index ix_auth_username on authorities (username, authority);

insert into users (username, password) values ('user00', 'pw00');
insert into users (username, password) values ('member00', 'pw00');
insert into users (username, password) values ('admin00', 'pw00');

insert into authorities (username, authority) values ('user00', 'ROLE_USER');
insert into authorities (username, authority) values ('member00', 'ROLE_MANAGER');
insert into authorities (username, authority) values ('admin00', 'ROLE_MANAGER');
insert into authorities (username, authority) values ('admin00', 'ROLE_ADMIN');

commit;

select * from users;
select * from AUTHORITIES;

alter table tbl_board add (replycnt number default 0);
update tbl_board set replycnt = (select count(rno) from tbl_reply where tbl_reply.bno = tbl_board.bno);

select * from TBL_ATTACH;

create index idx_reply on tbl_reply (bno desc, rno asc);
select rno, bno, reply, replyer, replydate, updatedate from(
select /*+index(tbl_reply idx_reply)*/
rownum rn, bno, rno, reply, replyer, replyDate, updatedate
from tbl_reply where bno = 18 and rno >0 and rownum <=20)
where rn >10;
select rno, bno, reply, replyer, replyDate, updatedate from tbl_reply where bno = 18 order by rno asc;
select * from tbl_reply order by rno desc;
commit;
select * from tbl_board where rownum < 10 order by bno desc;
create SEQUENCE seq_reply;
create table tbl_reply(
    rno NUMBER(10,0),
    bno number(10,0) not null,
    reply varchar2(1000)not null,
    replyer varchar2(50) not null,
    replyDate date default sysdate,
    updateDate date DEFAULT sysdate
);
alter table tbl_reply add constraint pk_reply primary key (rno);
alter table tbl_reply add constraint fk_reply_board foreign key (bno) references tbl_board(bno);
-------------------------------------------
SELECT DBMS_XDB.GETHTTPPORT() from dual;
create SEQUENCE seq_board;
create table tbl_board(
    bno number(10,0),
    title varchar2(200)not null,
    content varchar2(2000) not null,
    writer varchar2(50) not null,
    regdate date default sysdate,
    updatedate date DEFAULT sysdate
);
alter TABLE tbl_board add constraint pk_board
primary key (bno);

insert into tbl_board (bno, title, content, writer)
values (seq_board.nextval, '테스트 제목', '테스트 내용', 'user00');

insert into tbl_board (bno, title, content, writer)
values (1, '스프링 테스트', '시작', 'oh e t');

select * from TBL_BOARD;
select bno, title, content, writer, regdate, updatedate from (select /*+index_desc(tbl_board pk_board) */
  		rownum rn, bno, title, content, writer, regdate, updatedate from tbl_board where rownum <= 20)
  		where rn > 10;
        
commit;