CREATE DATABASE ProjetoFaculdade
GO
USE ProjetoFaculdade;

CREATE TABLE departamentos (
    id_departamento INT PRIMARY KEY IDENTITY(1,1),
    nome_departamento VARCHAR(50) NOT NULL
);

CREATE TABLE pessoas (
    id_pessoa INT PRIMARY KEY IDENTITY(1,1),
    nome_pessoa VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    endereco VARCHAR(120) NOT NULL,
    contato VARCHAR(15) NOT NULL,
    perfil VARCHAR(20) NOT NULL CHECK (perfil IN ('Professor', 'Aluno', 'Funcionario')),
    situacao VARCHAR(40) NOT NULL CHECK (situacao IN ('Ativo', 'Inativo', 'Demitido'))
);

CREATE TABLE cargos (
    id_cargo INT PRIMARY KEY IDENTITY(1,1),
    nome_cargo VARCHAR(70) NOT NULL,
    descricao_cargo TEXT NOT NULL,
    carga_horaria_cargo INT NOT NULL,
    salario_base DECIMAL(10, 2) NOT NULL
);

CREATE TABLE funcionarios (
    id_funcionario INT PRIMARY KEY IDENTITY(1,1),
    data_admissao DATETIME NOT NULL,
    data_desligamento DATETIME NULL,
    id_pessoa INT NOT NULL,
    id_cargo INT NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa),  
    FOREIGN KEY (id_cargo) REFERENCES cargo(id_cargo) 
);

CREATE TABLE professores (
    id_professor INT PRIMARY KEY IDENTITY(1,1),
    id_pessoa INT NOT NULL,    
    id_departamento INT NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa),
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);

CREATE TABLE cursos (
    id_curso INT PRIMARY KEY IDENTITY(1,1),
    nome_curso VARCHAR(60) NOT NULL,
    data_inicio_curso DATETIME,
    data_termino_curso DATETIME,
    carga_horaria_curso INT NOT NULL,
    id_departamento INT NOT NULL,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento) 
);

CREATE TABLE disciplinas (
    id_disciplina INT IDENTITY(1,1) PRIMARY KEY,
    nome_disciplina VARCHAR(60) NOT NULL,
    carga_horaria_disciplina INT NOT NULL,
    id_curso INT NOT NULL,
    FOREIGN KEY (id_curso) REFERENCES curso(id_curso) 
);

CREATE TABLE disciplina_professores (
    id_disciplina_professor INT IDENTITY(1,1) PRIMARY KEY,
    id_professor INT NOT NULL,
    id_disciplina INT NOT NULL,
    FOREIGN KEY (id_disciplina) REFERENCES disciplina(id_disciplina), 
    FOREIGN KEY (id_professor) REFERENCES professor(id_professor) 
);

CREATE TABLE alunos (
    id_aluno INT PRIMARY KEY IDENTITY(1,1),
    id_pessoa INT NOT NULL,
    matricula VARCHAR(25) NOT NULL UNIQUE,
    id_curso INT NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa),
    FOREIGN KEY (id_curso) REFERENCES curso(id_curso) 
);

CREATE TABLE turmas (
    id_turma INT PRIMARY KEY IDENTITY(1,1),
    data_inicio_turma DATETIME,
    data_termino_turma DATETIME,
    horario TIME NOT NULL,
    local_turma VARCHAR(10) NOT NULL,
    id_professor INT NOT NULL,
    FOREIGN KEY (id_professor) REFERENCES professor(id_professor)
);

CREATE TABLE matriculas (
    id_matricula INT PRIMARY KEY IDENTITY(1,1),
    id_aluno INT NOT NULL,
    id_turma INT NOT NULL,
    data_matricula DATETIME NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    FOREIGN KEY (id_turma) REFERENCES turma(id_turma) 
);

CREATE TABLE frequencias (
    id_frequencia INT IDENTITY(1,1) PRIMARY KEY,
    id_matricula INT NOT NULL,
    data_frequencia DATE NOT NULL,
    presenca BIT NOT NULL,
    FOREIGN KEY (id_matricula) REFERENCES matricula(id_matricula)
);

CREATE TABLE pagamentos (
    id_pagamento INT PRIMARY KEY IDENTITY(1,1),
    formas_pagamento VARCHAR(35) NOT NULL CHECK (formas_pagamento IN ('Cartão de Crédito', 'Débito', 'Boleto', 'Dinheiro')),
    valor DECIMAL(10, 2) NOT NULL,
    data_pagamento DATETIME NOT NULL
);

CREATE TABLE pagamento_alunos (
    id_pagamento_aluno INT IDENTITY(1,1) PRIMARY KEY,
    id_pagamento INT NOT NULL,
    id_aluno INT NOT NULL,
    FOREIGN KEY (id_pagamento) REFERENCES pagamento(id_pagamento),
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno)
);

CREATE TABLE folhas_pagamento (
    id_folha_pagamento INT PRIMARY KEY IDENTITY(1,1),
    id_pagamento INT NOT NULL,
    data_pagamento DATETIME NOT NULL,
    mes_referencia TINYINT NOT NULL CHECK (mes_referencia BETWEEN 1 AND 12),
    ano_referencia SMALLINT NOT NULL CHECK (ano_referencia >= 2000),
    salario_bruto DECIMAL(10,2) NOT NULL,
    descontos DECIMAL(10,2) NOT NULL,
    Bonus DECIMAL(10,2) NOT NULL,
    salario_liquido DECIMAL (10,2) AS (salario_bruto + bonus - desconto),
    id_pessoa INT NOT NULL,
    id_cargo INT NOT NULL,
    FOREIGN KEY (id_pagamento) REFERENCES pagamento(id_pagamento),
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa),
    FOREIGN KEY (id_cargo) REFERENCES cargo(id_cargo)
);

