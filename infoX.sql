/**
	Sistema para gestão de OS de uma assistência técnica de computadores e periféricos
    @author Ismael de Sousa
*/

create database dbinfox;
use dbinfox;

create table usuarios(
	id int primary key auto_increment,
    usuario varchar (50) not null,
    login varchar(50) not null unique,
    senha varchar(250) not null,
    perfil varchar(50) not null
);

describe usuarios;

-- a linha abaixo insere uma senha com criptografia
-- md5() criptografia de senha
insert into usuarios(usuario,login,senha,perfil) values ('Ismael','admin',md5('123456'),'administrador');
insert into usuarios(usuario,login,senha,perfil) values ('Ramiro Xavier','ramiro',md5('123'),'operador');
insert into usuarios(usuario,login,senha,perfil) values ('Randerson Santos','randerson',md5(123),'operador');
insert into usuarios(usuario,login,senha,perfil) values ('Isabela Soares','isabela',md5(1234),'operador');
insert into usuarios(usuario,login,senha,perfil) values ('Larissa Saraiva','larissa',md5(12345),'administrador');

select * from usuarios;
select * from usuarios where id = 2;

select id as ID,usuario as Usuário,login as Login,perfil as Perfil from usuarios where usuario like 'i%';

-- selecionando usuario e sua respectiva senha (tela de login)
select * from usuarios where login ='admin' and senha=md5('123456');

update usuarios set usuario='Ramiro Santos Xavier',login='ramirosantos',senha=md5('1234'),perfil='operador' where id = 2;
delete from usuarios where id = 3;

-- char (tipo de dados que aceita uma String de caracteres não variáveis) -> gasta menos memória
create table clientes(
	idcli int primary key auto_increment,
    nome varchar(50) not null,
    cep char(8),
    endereco varchar(50) not null,
    numero varchar(12) not null,
    complemento varchar(30),
    bairro varchar(50) not null,
    cidade varchar(50) not null,
    uf char(2) not null,
    fone varchar(15) not null
);

describe clientes;

insert into clientes(nome,cep,endereco,numero,complemento,bairro,cidade,uf,fone)
values ('Gabriel','14350970','Rua Coronel Honório Palma','135','','Centro','Altinópolis','SP','1198702-6271');
insert into clientes(nome,cep,endereco,numero,complemento,bairro,cidade,uf,fone)
values ('Roberto','12938172','AV. Carlos Andrade Xavier','1123','','Bairro Leste','São Paulo','SP','1192312-6121');
insert into clientes(nome,cep,endereco,numero,complemento,bairro,cidade,uf,fone)
values ('Rafael','92384723','Rua Da Marcelina','12','Apartamento','Bairro Norte','Brasilia','DF','1191238-6389');
insert into clientes(nome,cep,endereco,numero,complemento,bairro,cidade,uf,fone)
values ('Ramiro Silva','29384723','Rua Candelabrio','1123','Apartamento','Itaquera','São Paulo','SP','1191238-12983');
insert into clientes(nome,cep,endereco,numero,complemento,bairro,cidade,uf,fone)
values ('Matheus','12983719','Rua dos Andes Alados','9999','','Tatuapé','São Paulo','SP','1192312-6121');


select * from clientes;
select idcli as ID, nome as Cliente, fone as Fone, cep as CEP, endereco as Endereço, numero as Número, complemento as Complemento, bairro as Bairro, cidade as Cidade, uf as UF from clientes where nome like "r%";

-- foreign key (FK) cria um relacionamento de 1 para muitos (cliente - tbos)
create table tbos (
	os int primary key auto_increment,
    dataos timestamp default current_timestamp,
    tipo varchar(20) not null,
	statusos varchar(30) not null,
    equipamento varchar(200) not null,
    defeito varchar(200) not null,
    tecnico varchar(50),
    valor decimal(10,2),
    idcli int not null,
    foreign key(idcli) references clientes(idcli)
);
describe tbos;

insert into tbos (tipo,statusos,equipamento,defeito,idcli) 
values ('orçamento','bancada','Notebook Lenovo G90','Não liga',1);
insert into tbos (tipo,statusos,equipamento,defeito,tecnico,valor,idcli)
values ('orçamento','aguardando aprovação','Impressora HP2020','papel enroscando','Ramiro',150.00,1);
insert into tbos (tipo,statusos,equipamento,defeito,tecnico,valor,idcli)
values ('serviço','retirado','Notebook Positivo','tela trincada','Ramiro',250.00,3);
insert into tbos (tipo,statusos,equipamento,defeito,tecnico,valor,idcli)
values ('serviço','retirado','Notebook Acer','Vírus','Ramiro',350.00,4);
insert into tbos (tipo,statusos,equipamento,defeito,tecnico,valor,idcli)
values ('orçamento','aguardando aprovação','Notebook Razer 17 Polegadas','Superaquecimento','Ramiro',750.00,5);

select * from tbos;

-- (inner join) união de tabelas relacionadas para consultas e updates
-- relatório 1
select * from tbos inner join clientes on tbos.idcli = clientes.idcli;

-- relatório 2
select tbos.equipamento,tbos.defeito,tbos.statusos as status_os,tbos.valor,clientes.nome,clientes.fone
from tbos inner join clientes on tbos.idcli = clientes.idcli where statusos='aguardando aprovação';

-- relatório 3
-- (os,data formatada(dia,mês e ano) equipamento, defeito, valor, nome do cliente) filtrando por retirado
select tbos.os,date_format(tbos.dataos,'%d/%m/%Y - %H:%i') as data_os,tbos.statusos as status_os,tbos.equipamento,tbos.defeito,tbos.valor,clientes.nome,clientes.fone
from tbos inner join clientes on tbos.idcli = clientes.idcli where statusos='retirado';

-- relatório 4 (faturamento)
select sum(valor) as faturamento from tbos where statusos='retirado';
