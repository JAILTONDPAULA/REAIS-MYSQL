#///////////////////#
# CLASSES DE ACESSO #
#///////////////////#

CREATE TABLE CLASSE_ACESSO(
	COD_ACESSO  BIGINT 		 PRIMARY KEY AUTO_INCREMENT,
    DESC_ACESSO VARCHAR(100) NOT NULL,
    NIVEL		ENUM('A','O')
);

#///////////////////////////////#
# CLASSES DE ACESSO - AUDITORIA #
#///////////////////////////////#

CREATE TABLE CLASSE_ACESSO_AUD(
	COD_AUDITORIA BIGINT            PRIMARY KEY AUTO_INCREMENT,
	COD_ACESSO    BIGINT			,
    DESC_ACESSO   VARCHAR(100)  	,
    NIVEL		  ENUM('A','O') 	,
    FLG_STATUS	  ENUM('I','U','D') ,
    DAT_AUDITORIA TIMESTAMP         NOT NULL,
    OPERADOR	  VARCHAR(100)	    NOT NULL
);

#/////////////////////////////#
# CLASSES DE ACESSO - TRIGGER #
#/////////////////////////////#   
DELIMITER !!

CREATE TRIGGER TG_CLASSE_ACESSO_INSERT
AFTER INSERT ON CLASSE_ACESSO FOR EACH ROW
BEGIN
	INSERT INTO CLASSE_ACESSO_AUD
        (COD_ACESSO	  ,
         DESC_ACESSO  ,
         NIVEL		  ,
         FLG_STATUS	  ,
         DAT_AUDITORIA,
         OPERADOR)
	VALUES
        (NEW.COD_ACESSO	 ,
         NEW.DESC_ACESSO ,
         NEW.NIVEL		 ,
         'I'	         ,
         NOW()	         ,
         USER());
END!!

CREATE TRIGGER TG_CLASSE_ACESSO_UPDATE
AFTER UPDATE ON CLASSE_ACESSO FOR EACH ROW
BEGIN
    DECLARE V_DESCRICAO VARCHAR(300);
    DECLARE V_NIVEL	    CHAR(1);
    
    IF NEW.DESC_ACESSO != OLD.DESC_ACESSO THEN SET V_DESCRICAO = OLD.DESC_ACESSO; END IF;
    IF NEW.NIVEL       != OLD.NIVEL       THEN SET V_NIVEL     = OLD.NIVEL;       END IF;

    
	INSERT INTO CLASSE_ACESSO_AUD
        (COD_ACESSO	  ,
         DESC_ACESSO  ,
         NIVEL		  ,
         FLG_STATUS	  ,
         DAT_AUDITORIA,
         OPERADOR)
	VALUES
        (OLD.COD_ACESSO ,
         V_DESCRICAO    ,
         V_NIVEL		,
         'U'	        ,
         NOW()	        ,
         USER());
END!!

CREATE TRIGGER TG_CLASSE_ACESSO_DELETE
AFTER DELETE ON CLASSE_ACESSO FOR EACH ROW
BEGIN
	INSERT INTO CLASSE_ACESSO_AUD
        (COD_ACESSO	  ,
         DESC_ACESSO  ,
         NIVEL		  ,
         FLG_STATUS	  ,
         DAT_AUDITORIA,
         OPERADOR)
	VALUES
        (OLD.COD_ACESSO	 ,
         OLD.DESC_ACESSO ,
         OLD.NIVEL		 ,
         'D'	         ,
         NOW()	         ,
         USER());
END!!

DELIMITER ;