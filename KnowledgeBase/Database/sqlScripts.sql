
-- TOPIC SCRIPTS

-- GET TOPICS
SET @ID = NULL;
SELECT 
    ID,
    TOPIC
FROM TOPICS
WHERE
    ID = IFNULL(@ID, ID);


-- USER SCRIPTS

-- GET USER MATCHING USERNAME + PASSWORD
SET @USERNAME = 'BEN';
SET @PASSWORD = 'pass';
SELECT
    ID,
    USERNAME,
    FIRST_NAME,
    LAST_NAME,
    PROFILE_IMAGE_URL,
    DATE_OF_BIRTH,
    EMAIL,
    COUNTRY,
    LIKES,
    ABOUT,
    (SELECT COUNT(ID) FROM DISCUSSIONS WHERE USER_ID = u.ID) AS DISCUSSION_COUNT,
    (SELECT COUNT(ID) FROM MESSAGES WHERE USER_ID = u.ID) AS MESSAGE_COUNT
FROM USERS u
WHERE 
	USERNAME = @USERNAME AND PASSWORD = @PASSWORD;
    
-- GET PRIVATE USER INFO
SET @ID = 3;
SELECT
	ID,
    USERNAME,
    FIRST_NAME,
    LAST_NAME,
    PROFILE_IMAGE_URL,
    DATE_OF_BIRTH,
    EMAIL,
    COUNTRY,
    LIKES,
    ABOUT,
    (SELECT COUNT(ID) FROM DISCUSSIONS WHERE u.ID = USER_ID) AS DISCUSSION_COUNT,
    (SELECT COUNT(ID) FROM MESSAGES WHERE USER_ID = u.ID) AS MESSAGE_COUNT
FROM USERS u
WHERE 
	ID = @ID;
    
-- GET PUBLIC USER INFO
SET @ID = 3;
SELECT 
	ID,
    FIRST_NAME,
    LAST_NAME,
    PROFILE_IMAGE_URL,
    COUNTRY,
    LIKES,
    ABOUT,
    (SELECT COUNT(ID) FROM DISCUSSIONS WHERE u.ID = USER_ID) AS DISCUSSION_COUNT
FROM USERS u
WHERE 
	ID = @ID;

-- MODIFY USER
SET @ID = 1;
SET @USERNAME = IFNULL(@USERNAME, (SELECT USERNAME FROM USERS WHERE ID = @ID));
SET @FIRST_NAME = IFNULL(@FIRST_NAME, (SELECT USERNAME FROM USERS WHERE ID = @ID));
SET @LAST_NAME = IFNULL(@LAST_NAME, (SELECT LAST_NAME FROM USERS WHERE ID = @ID));
SET @PROFILE_IMAGE_URL = IFNULL(@PROFILE_IMAGE_URL, (SELECT PROFILE_IMAGE_URL FROM USERS WHERE ID = @ID));
SET @COUNTRY = IFNULL(@COUNTRY, (SELECT COUNTRY FROM USERS WHERE ID = @ID));
SET @ABOUT = IFNULL(@ABOUT, (SELECT ABOUT FROM USERS WHERE ID = @ID));
UPDATE USERS
SET
    USERNAME = @USERNAME,
    FIRST_NAME = @FIRST_NAME,
    LAST_NAME = @LAST_NAME,
    PROFILE_IMAGE_URL = @PROFILE_IMAGE_URL,
    COUNTRY = @COUNTRY,
    ABOUT = @ABOUT
WHERE
    ID = @ID;
    
-- CREATE USER
SET @USERNAME = 'JJ';
SET @PASSWORD = 'littlej';
SET @FIRST_NAME = 'John';
SET @LAST_NAME = ' Hoang';
SET @EMAIL = 'johnquochoang@gmail.com';
SET @PROFILE_IMAGE_URL = 'https://randomuser.me/api/portraits/med/men/2.jpg';
SET @COUNTRY = 'Canada';
SET @DATE_OF_BIRTH = '1920-04-06';
SET @ABOUT = 'I am just a rag tag bunch of mistakes and regrets balled together into a sexy asian form, #fuckyoujeff';
SET @ID = (SELECT IF(EXISTS(SELECT 1 FROM USERS), (SELECT MAX(ID) + 1 FROM USERS), 1));
INSERT INTO USERS
VALUES (@ID, @USERNAME, @PASSWORD, @FIRST_NAME, @LAST_NAME, @EMAIL, @PROFILE_IMAGE_URL, @COUNTRY, @DATE_OF_BIRTH, 0, @ABOUT);

-- DISCUSSION SCRIPTS

-- GET USER'S DISCUSSIONS
SET @USER_ID = 1;
SELECT 
    ID,
    (SELECT TOPIC FROM TOPICS WHERE ID = d.TOPIC_ID) AS TOPIC,
    (SELECT PROFILE_IMAGE_URL FROM USERS WHERE ID = d.USER_ID) AS PROFILE_IMG_URL,
    TITLE,
    BODY,
    DATE,
    (SELECT COUNT(ID) FROM POSTS WHERE DISCUSSION_ID = d.ID) AS REPLY_COUNT
FROM DISCUSSIONS d
WHERE
    USER_ID = @USER_ID;
    
-- GET ALL DISCUSSIONS IN ORDER OF MOST RECENT
SELECT 
    ID,
    (SELECT TOPIC FROM TOPICS WHERE ID = d.TOPIC_ID) AS TOPIC,
    (SELECT PROFILE_IMAGE_URL FROM USERS WHERE ID = d.USER_ID) AS PROFILE_IMG_URL,
    TITLE,
    BODY,
    DATE,
    (SELECT COUNT(ID) FROM POSTS WHERE DISCUSSION_ID = d.ID) AS REPLY_COUNT
FROM DISCUSSIONS d
ORDER BY DATE DESC;

-- GET DISCUSSIONS BASED ON SEARCH
SET @TOPIC = NULL;
SET @SEARCH_PHRASE = 'hello';
SELECT 
    ID,
    (SELECT TOPIC FROM TOPICS WHERE ID = d.TOPIC_ID) AS TOPIC,
    (SELECT PROFILE_IMAGE_URL FROM USERS WHERE ID = d.USER_ID) AS PROFILE_IMG_URL,
    TITLE,
    BODY,
    DATE,
    (SELECT COUNT(ID) FROM POSTS WHERE DISCUSSION_ID = d.ID) AS REPLY_COUNT
FROM DISCUSSIONS d
WHERE
    TOPIC_ID = IFNULL(@TOPIC, TOPIC_ID) AND TITLE LIKE CONCAT('%', @SEARCH_PHRASE, '%');
    
-- GET POSTS FOR DISCUSSION
SET @DISCUSSION_ID = 1;
SELECT 
    ID,
    (SELECT PROFILE_IMAGE_URL FROM USERS WHERE ID = p.USER_ID) AS PROFILE_IMG_URL,
    POST_BODY
FROM POSTS p
    WHERE DISCUSSION_ID = @DISCUSSION_ID;

    
-- CREATE DISCUSSION
SET @USER_ID = 1;
SET @TOPIC_ID = 0;
SET @TITLE = 'A ridiculously awesome title';
SET @BODY = 'A very short body';
SET @ID = (SELECT IF(EXISTS(SELECT 1 FROM DISCUSSIONS), (SELECT MAX(ID) + 1 FROM DISCUSSIONS), 0));
INSERT INTO DISCUSSIONS
VALUES (@ID, @TOPIC_ID, @USER_ID, @TITLE, CURRENT_DATE(), @BODY);

-- CREATE POST
SET @USER_ID = 1;
SET @DISCUSSION_ID = 1;
SET @POST_BODY = 'A random sadhlgashdglasdjg post body';
SET @ID = (SELECT IF(EXISTS(SELECT 1 FROM POSTS), (SELECT MAX(ID) + 1 FROM POSTS), 0));
INSERT INTO POSTS
VALUES (@ID, @DISCUSSION_ID, @USER_ID, @POST_BODY);


-- CONVERSATION SCRIPTS

-- GET USER'S CONVERSATIONS
SET @USER_ID = 1;
SELECT 
    ID,
    (SELECT PROFILE_IMAGE_URL FROM USERS WHERE (ID = c.USER_ID_1 OR ID = c.USER_ID_2) AND ID != @USER_ID) AS PROFILE_IMG_URL,
    SUBJECT,
    DATE
FROM CONVERSATIONS c
WHERE
    USER_ID_1 = @USER_ID OR USER_ID_2 = @USER_ID;
        
-- GET MESSAGES FOR CONVERSATION
SET @USER_ID = 1;
SET @CONVERSATION_ID = 0;
SELECT
    ID,
    (SELECT PROFILE_IMAGE_URL FROM USERS WHERE ID = USER_ID) AS PROFILE_IMG_URL,
    MESSAGE_BODY,
    DATE_TIME
FROM MESSAGES m
WHERE
    CONVERSATION_ID = @CONVERSATION_ID;

-- CREATE CONVERSATION
SET @USER_ID = 1;
SET @DESTINATION_USER_ID = 2;
SET @SUBJECT = 'This is my really awesome subject';
SET @MESSAGE_BODY = 'And here is my less awesome message';
SET @CONVERSATION_ID = (SELECT IF(EXISTS(SELECT 1 FROM CONVERSATIONS), (SELECT MAX(ID) + 1 FROM CONVERSATIONS), 0));
INSERT INTO CONVERSATIONS
VALUES (@CONVERSATION_ID, @USER_ID, @DESTINATION_USER_ID, CURRENT_DATE(), @SUBJECT);
SET @MESSAGE_ID = (SELECT IF(EXISTS(SELECT 1 FROM MESSAGES), (SELECT MAX(ID) + 1 FROM MESSAGES), 0));
INSERT INTO MESSAGES
VALUES (@MESSAGE_ID, @CONVERSATION_ID, @USER_ID, NOW(), @MESSAGE_BODY);


