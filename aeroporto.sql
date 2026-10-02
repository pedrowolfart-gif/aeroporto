create table aeronaves (
id serial primary key,
modelo varchar (150) not null,
codigo_cauda varchar (10) unique not null,
capacidade int not null check (capacidade > 0)
);

insert into aeronaves (modelo, codigo_cauda, capacidade) values 
('azul', '123456', '150'),
('gol', '987456', '200'),
('pink', '147852', '80'),
('latan', '963258', '20'),
('amarelo', '159753', '300');

create table pilotos (
id serial primary key,
nome varchar(150) not null,
codigo_anac varchar (6) unique not null,
horas_voo numeric (10, 2) not null check (horas_voo > 0)
);

insert into pilotos (nome, codigo_anac, horas_voo) values 
('pedro', '147852', 13.00),
('marcos', '357456', 14.00),
('gaia', '465879', 08.30),
('nicolas', '145632', 23.45),
('lorenzo', '958475', 01.25);

create table voos (
id serial primary key,
aeronave_id int not null,
piloto_id int not null,
numero_voo varchar(15) not null,
origem varchar (100) not null,
destino varchar(100) not null,
data_hora timestamp default current_timestamp,
status varchar (20) default 'agendado' check (status in ('agendado', 'cancelado', 'concluido')),

foreign key (aeronave_id) references aeronaves(id),
foreign key (piloto_id) references pilotos(id)
);

insert into voos (aeronave_id, piloto_id, numero_voo, origem , destino, status ) values 
(1, 1, '123', 'brasilia', 'floripa', 'agendado'),
(2, 2, '358', 'são paulo', 'rio de janeiro', 'concluido'),
(3, 3, '654', 'são josé', 'pará', 'agendado'),
(4, 4, '159', 'floripa', 'miame', 'cancelado'),
(5, 5, '147', 'grecia', 'brasilia', 'agendado');

create table passageiros (
id serial primary key,
nome varchar(100) not null,
cpf varchar(11) unique not null,
email varchar(100) unique not null
);

insert into passageiros (nome, cpf, email) values 
('arthur', '12345678912', 'arthur@gmail.com'),
('marcelo', '15996385245', 'marcelo@gmail.com'),
('anderson', '79945566665', 'anderson@gmail.com'),
('cleci', '14785414556', 'cleci@gmail.com'),
('ana', '98563247852', 'ana@gmail.com');

create table passagens (
id serial primary key,
voo_id int not null,
passageiro_id int not null,
assento varchar (4) not null,
classe varchar (50) not null,
valor decimal (10, 2) not null check (valor > 0),

foreign key (voo_id) references voos(id),
foreign key (passageiro_id) references passageiros(id)
);


insert into passagens (voo_id, passageiro_id, assento, classe, valor ) values 
(1, 1, '12A', 'executiva', 1500.00),
(2, 2, '15A', 'executiva', 1500.00),
(3, 3, '41B','economica', 500.00),
(4, 4, '25A', 'executiva', 1500.00),
(5, 5, '20B', 'economica', 550.00)

select
v.numero_voo,
v.origem,
v.destino,
a.modelo as modelo_aeronave,
p.nome as nome_piloto
from voos v
join aeronaves a on v.aeronave_id = a.id
join pilotos p on v.piloto_id = p.id
where v.status in ('agendado', 'em voo');

select
classe,
sum(valor) as total_arrecadado
from passagens
group by classe;

select
pas.nome as nome_passagens,
v.numero_voo,
p.assento,
p.valor
from passagens p
join passageiros pas on p. passageiro_id = pas.id
join voos v on p.voo_id = v.id
where p.classe = 'executiva' and p.valor > 800.00
order by p.valor desc;

create view vw_painel_aeroporto as
select 
v.numero_voo,
v.data_hora,
v.origem,
v.destino,
a.modelo as modelo_aeroporto,
a.codigo_cauda,
v.status
from voos v
join aeronaves a on v.aeronave_id = a.id