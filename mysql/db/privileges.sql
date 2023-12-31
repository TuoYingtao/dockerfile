USE sys;
DELIMITER //
CREATE PROCEDURE InitDatabaseAndUser(OUT SUCCESS BOOLEAN, OUT ERROR_MESSAGE TEXT)
BEGIN
    DECLARE SQL_CODE CHAR(5) DEFAULT '00000';
    DECLARE SQL_TEXT TEXT DEFAULT 'Transaction failed';
    DECLARE SQL_ERROR TEXT DEFAULT '';
    -- 声明变量来捕获异常信息
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- 处理异常的代码块
        SET SUCCESS = FALSE;
        GET DIAGNOSTICS CONDITION 1
            SQL_CODE = RETURNED_SQLSTATE,
            SQL_ERROR = MYSQL_ERRNO,
            SQL_TEXT = MESSAGE_TEXT;
        SET ERROR_MESSAGE = CONCAT('Error: ', SQL_ERROR, ', SQL State: ', SQL_CODE, ', Message: ', SQL_TEXT);
        ROLLBACK;
    END;

    -- 开始事务
    START TRANSACTION;

    -- 数据库名称
    SET @DATABASE_NAME = '${MYSQL_DATABASE}';
    -- 数据库角色
    SET @DATABASE_USER_NAME = '${MYSQL_USER}';
    SET @DATABASE_USER_PASS = '${MYSQL_PASSWORD}';

    -- 修改root角色在非本机可访问
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
    -- 刷新MySQL的系统权限相关表
    FLUSH PRIVILEGES;

    -- 如果指定的仓库存在，则删除
    SET @DROP_DATABASE = CONCAT('DROP DATABASE IF EXISTS ', @DATABASE_NAME);
    PREPARE stmt FROM @DROP_DATABASE;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    SET @DROP_DATABASE = null;

    -- 如果指定的用户存在，则删除
    SET @DROP_USER = CONCAT('DROP USER IF EXISTS ', @DATABASE_USER_NAME, '@\'%\'');
    PREPARE stmt FROM @DROP_USER;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    SET @DROP_USER = null;

    -- 创建数据库
    SET @CREATE_DATABASE = CONCAT('CREATE DATABASE IF NOT EXISTS ', @DATABASE_NAME, ' DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci');
    PREPARE stmt FROM @CREATE_DATABASE;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    SET @CREATE_DATABASE = null;

    -- 创建访问用户
    SET @CREATE_USER = CONCAT('CREATE USER ', @DATABASE_USER_NAME, '@\'%\' IDENTIFIED BY \'', @DATABASE_USER_PASS, '\'');
    PREPARE stmt FROM @CREATE_USER;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    SET @CREATE_USER = null;

    -- 设置访问权限给指定用户
    SET @GRANT_USER = CONCAT('GRANT ALL PRIVILEGES ON ', @DATABASE_NAME, '.* TO ', @DATABASE_USER_NAME, '@\'%\'');
    PREPARE stmt FROM @GRANT_USER;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    SET @GRANT_USER = null;

    -- 刷新MySQL的系统权限相关表
    FLUSH PRIVILEGES;

    -- 查看用户授权信息
    SET @SHOW_GRANTS = CONCAT('SHOW GRANTS FOR ', @DATABASE_USER_NAME, '@\'%\'');
    PREPARE stmt FROM @SHOW_GRANTS;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    SET @SHOW_GRANTS = null;

    SET SUCCESS = TRUE;
    COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE RunInitAndCleanup()
BEGIN
    DECLARE USER_COUNT INT DEFAULT 0;
    DECLARE DB_COUNT INT;
    DECLARE TRANSACTION_SUCCESS BOOLEAN DEFAULT FALSE;
    DECLARE ERROR_MESSAGE TEXT;

    CALL InitDatabaseAndUser(TRANSACTION_SUCCESS, ERROR_MESSAGE);

    IF TRANSACTION_SUCCESS IS NOT NULL AND TRANSACTION_SUCCESS THEN
        -- 检查数据库是否存在
        SELECT COUNT(*) INTO DB_COUNT FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = @DATABASE_NAME;
        -- 检查用户是否存在
        SELECT COUNT(*) INTO USER_COUNT FROM mysql.user WHERE User = @DATABASE_USER_NAME AND Host = '%';

        -- 如果数据库存在，则删除存储过程
        IF DB_COUNT > 0 AND USER_COUNT > 0 THEN
            SET @DATABASE_NAME = NULL;
            SET @DATABASE_USER_NAME = NULL;
        END IF;
        -- 检查存储过程是否存在
        SELECT * FROM information_schema.ROUTINES WHERE ROUTINE_NAME = 'InitDatabaseAndUser' AND ROUTINE_TYPE = 'PROCEDURE';
        -- 事务成功
        SELECT 'Transaction successful' AS Result;
    ELSE
        -- 事务失败
        SELECT ERROR_MESSAGE AS ErrResult;
    END IF;
END //
DELIMITER ;

-- 调用 RunInitAndCleanup 存储过程
CALL RunInitAndCleanup();

-- 如果存在删除指定的存储过程
DROP PROCEDURE IF EXISTS RunInitAndCleanup;
DROP PROCEDURE IF EXISTS InitDatabaseAndUser;
SHOW PROCEDURE STATUS LIKE 'InitDatabaseAndUser';

