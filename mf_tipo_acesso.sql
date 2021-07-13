#==============================================================
#Tabela que contém o nível de acessos dos usuários do sistema =
#==============================================================
CREATE TABLE MF_TIPO_ACESSO(
	COD_ACESSO  BIGINT        PRIMARY KEY AUTO_INCREMENT,
    DESC_ACESSO VARCHAR(200)  NOT NULL,
    NIVEL		ENUM('1','2')
    COMMENT '1-ADMINISTRADOR / 2-USUÁRIOS'
);

#=============================================================
#Tabela de auditoria =========================================
#=============================================================

CREATE TABLE MF_TIPO_ACESSO_AUDITORIA(
	COD_AUDITORIA BIGINT            PRIMARY KEY AUTO_INCREMENT,
	COD_ACESSO    BIGINT       		,
    DESC_ACESSO   VARCHAR(200) 		,
    NIVEL		  ENUM('1','2')     ,
    FLG_ACAO	  ENUM('I','U','D') NOT NULL
    COMMENT 'I-INSERT / U-UPDATE / D-DELETE',
    LOGIN		  VARCHAR(30) 		NOT NULL,
    DAT_AUDITORIA TIMESTAMP   		NOT NULL
);

#=============================================================
#triggers =====================================================
#=============================================================
DELIMITER !!
CREATE TRIGGER TG_MF_TIPO_ACESSO_I
AFTER INSERT ON MF_TIPO_ACESSO FOR EACH ROW
BEGIN
	INSERT INTO MF_TIPO_ACESSO_AUDITORIA
    (COD_ACESSO,DESC_ACESSO,NIVEL,FLG_ACAO,LOGIN,DAT_AUDITORIA)
    VALUES
    (NEW.COD_ACESSO,NEW.DESC_ACESSO,NEW.NIVEL,'I',USER,NOW());
END!!

CREATE TRIGGER TG_MF_TIPO_ACESSO_U
AFTER UPDATE ON MF_TIPO_ACESSO FOR EACH ROW
BEGIN
	DECLARE V_DESC_ACESSO VARCHAR(200) DEFAULT NULL;
	DECLARE V_NIVEL 	  INT          DEFAULT NULL;
    
    IF NEW.DESC_ACESSO != OLD.DESC_ACESSO THEN SET V_DESC_ACESSO := OLD.DESC_ACESSO; END IF;
    IF NEW.NIVEL 	   != OLD.NIVEL       THEN SET V_NIVEL       := OLD.NIVEL;       END IF;
    
	INSERT INTO MF_TIPO_ACESSO_AUDITORIA
    (COD_ACESSO,DESC_ACESSO,NIVEL,FLG_ACAO,LOGIN,DAT_AUDITORIA)
    VALUES
    (OLD.COD_ACESSO,V_DESC_ACESSO,V_NIVEL,'U',USER,NOW());
END!!

CREATE TRIGGER TG_MF_TIPO_ACESSO_D
AFTER DELETE ON MF_TIPO_ACESSO FOR EACH ROW
BEGIN
	INSERT INTO MF_TIPO_ACESSO_AUDITORIA
    (COD_ACESSO,DESC_ACESSO,NIVEL,FLG_ACAO,LOGIN,DAT_AUDITORIA)
    VALUES
    (OLD.COD_ACESSO,OLD.DESC_ACESSO,OLD.NIVEL,'D',USER,NOW());
END!!

DELIMITER ;