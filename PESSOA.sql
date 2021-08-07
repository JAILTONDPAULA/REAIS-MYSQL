#/////////#
# PESSOAS #
#/////////#

CREATE TABLE PESSOA(
	COD_PESSOA  BIGINT 		  PRIMARY KEY AUTO_INCREMENT,
    NOME        VARCHAR(100)  NOT NULL,
    EMAIL	    VARCHAR(100)  NOT NULL,
    CPF		    INT(11)	      NOT NULL,
    LOGIN	    VARCHAR(35)   NOT NULL,
    DAT_NASCIDO DATE		  NOT NULL,
    SEXO		ENUM('M','F') ,
    SENHA		VARCHAR(200)  ,
    COD_ACESSO  BIGINT
);

#///////////////////////////////#
# CLASSES DE ACESSO - AUDITORIA #
#///////////////////////////////#

CREATE TABLE PESSOA_AUD(
	COD_AUDITORIA  BIGINT            PRIMARY KEY AUTO_INCREMENT,
	COD_PESSOA     BIGINT 		  	 ,
    NOME           VARCHAR(100)      ,
    EMAIL	       VARCHAR(100)  	 ,
    CPF		       INT(11)	      	 ,
    LOGIN	       VARCHAR(35)       ,
    DAT_NASCIDO    DATE		  		 ,
    SEXO		   ENUM('M','F') 	 ,
    SENHA		   VARCHAR(200)  	 ,
    COD_ACESSO     BIGINT			 ,
    FLG_STATUS	   ENUM('I','U','D') ,
    DAT_AUDITORIA  TIMESTAMP         NOT NULL,
    OPERADOR	   VARCHAR(100)	     NOT NULL
);

#/////////////////////////////#
# CLASSES DE ACESSO - TRIGGER #
#/////////////////////////////#   
DELIMITER !!

CREATE TRIGGER TG_PESSOA_INSERT
AFTER INSERT ON PESSOA FOR EACH ROW
BEGIN
	INSERT INTO PESSOA_AUD
        (COD_PESSOA   ,
		NOME          ,
		EMAIL         ,
        CPF		      ,
        LOGIN	      ,
        DAT_NASCIDO   ,
        SEXO	      ,
        SENHA	      ,
        COD_ACESSO    ,
		FLG_STATUS	  ,
        DAT_AUDITORIA,
        OPERADOR)
	VALUES
        (NEW.COD_PESSOA   ,
		NEW.NOME          ,
		NEW.EMAIL         ,
        NEW.CPF		      ,
        NEW.LOGIN	      ,
        NEW.DAT_NASCIDO   ,
        NEW.SEXO	      ,
        NEW.SENHA	      ,
        NEW.COD_ACESSO    ,
        'I'	  			  ,
        NOW()		      ,
        USER());
END!!

CREATE TRIGGER TG_CLASSE_ACESSO_UPDATE
AFTER UPDATE ON CLASSE_ACESSO FOR EACH ROW
BEGIN
    DECLARE V_NOME        VARCHAR(100);
    DECLARE V_EMAIL	      VARCHAR(100);
    DECLARE V_CPF		  INT(11);
    DECLARE V_LOGIN	      VARCHAR(35);
    DECLARE V_DAT_NASCIDO DATE;
    DECLARE V_SEXO		  CHAR(1);
    DECLARE V_SENHA		  VARCHAR(200);
    DECLARE V_COD_ACESSO  BIGINT;
    
    IF NEW.NOME        != OLD.NOME        THEN SET V_NOME        = OLD.NOME;        END IF;
    IF NEW.EMAIL       != OLD.EMAIL       THEN SET V_EMAIL       = OLD.EMAIL;       END IF;
    IF NEW.CPF         != OLD.CPF         THEN SET V_CPF         = OLD.CPF;         END IF;
    IF NEW.LOGIN       != OLD.LOGIN       THEN SET V_LOGIN       = OLD.LOGIN;       END IF;
    IF NEW.DAT_NASCIDO != OLD.DAT_NASCIDO THEN SET V_DAT_NASCIDO = OLD.DAT_NASCIDO; END IF;
    IF NEW.SEXO        != OLD.SEXO        THEN SET V_SEXO        = OLD.SEXO;        END IF;
    IF NEW.SENHA       != OLD.SENHA       THEN SET V_SENHA       = OLD.SENHA;       END IF;
    IF NEW.COD_ACESSO  != OLD.COD_ACESSO  THEN SET V_COD_ACESSO  = OLD.COD_ACESSO;  END IF;

    
	INSERT INTO PESSOA_AUD
        (COD_PESSOA   ,
		NOME          ,
		EMAIL         ,
        CPF		      ,
        LOGIN	      ,
        DAT_NASCIDO   ,
        SEXO	      ,
        SENHA	      ,
        COD_ACESSO    ,
		FLG_STATUS	  ,
        DAT_AUDITORIA,
        OPERADOR)
	VALUES
        (OLD.COD_PESSOA   ,
		NEW.NOME          ,
		NEW.EMAIL         ,
        NEW.CPF		      ,
        NEW.LOGIN	      ,
        NEW.DAT_NASCIDO   ,
        NEW.SEXO	      ,
        NEW.SENHA	      ,
        NEW.COD_ACESSO    ,
        'U'	  			  ,
        NOW()		      ,
        USER());
END!!

CREATE TRIGGER TG_CLASSE_ACESSO_DELETE
AFTER DELETE ON CLASSE_ACESSO FOR EACH ROW
BEGIN
	INSERT INTO PESSOA_AUD
        (COD_PESSOA   ,
		NOME          ,
		EMAIL         ,
        CPF		      ,
        LOGIN	      ,
        DAT_NASCIDO   ,
        SEXO	      ,
        SENHA	      ,
        COD_ACESSO    ,
		FLG_STATUS	  ,
        DAT_AUDITORIA,
        OPERADOR)
	VALUES
        (OLD.COD_PESSOA   ,
		OLD.NOME          ,
		OLD.EMAIL         ,
        OLD.CPF		      ,
        OLD.LOGIN	      ,
        OLD.DAT_NASCIDO   ,
        OLD.SEXO	      ,
        OLD.SENHA	      ,
        OLD.COD_ACESSO    ,
        'D'	  			  ,
        NOW()		      ,
        USER());
END!!

DELIMITER ;