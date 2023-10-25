-- CREATE DATABASE mars;
-- /connect web_mars;
-- DROP DATABASE mars;

DROP TABLE geographical_object, transport, location, mars_station, employee, users CASCADE;

-- Географические объекты
CREATE TABLE geographical_object
(
    id         SERIAL PRIMARY KEY,
    feature    VARCHAR NOT NULL,
    type       VARCHAR NOT NULL,
    size       INT     NULL,
    describe   VARCHAR NULL,
    url_photo  VARCHAR NULL,
    photo_byte BYTEA   NULL,
    -- Доступен / недоступен
    status     BOOLEAN NOT NULL
);

-- Транспортом могжет быть: посадочные, марсоходы, марсолеты и т.д.
CREATE TABLE transport
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR NOT NULL,
    type       VARCHAR NOT NULL,
    describe   VARCHAR NULL,
    url_photo  VARCHAR NULL,
    photo_byte BYTEA   NULL
);

-- Местоположение
CREATE TABLE location
(
    -- Порядковый номер
    id                     SERIAL PRIMARY KEY,
    id_geographical_object INT NOT NULL,
    id_mars_station        INT NOT NULL
);

-- Марсианская станция
CREATE TABLE mars_station
(
    id             SERIAL PRIMARY KEY,
    type_status    VARCHAR NOT NULL,
    date_create    DATE    NOT NULL,
    date_form      DATE    NULL,
    date_close     DATE    NULL,
    id_employee    INT     NOT NULL,
    id_moderator   INT     NULL,
    id_transport   INT     NULL,
    -- СТАТУС (ДЛЯ ЗАЯВКИ)
    -- status_task
    -- 1: Введен: Заявка только что создана и ожидает обработки.
    -- 2: В работе: Заявка была принята и находится в процессе выполнения.
    -- 3: Завершена: Заявка успешно выполнена.
    -- 4: Отменена: Заявка была отменена по каким-либо причинам.
    -- 5: Удалена: Заявка была удалена из системы.
    -- status_mission
    -- 1: Успех
    -- 2: Потеря
    -- 3: Работает
    status_task    INT     NOT NULL,
    status_mission INT     NOT NULL
);

CREATE TABLE employee
(
    id                SERIAL PRIMARY KEY,
    full_name         VARCHAR NOT NULL,
    post              VARCHAR NOT NULL,
    name_organization VARCHAR NOT NULL,
    address           VARCHAR NULL,
    id_user           INT     NOT NULL
);

CREATE TABLE users
(
    id       SERIAL PRIMARY KEY,
    login    VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    admin    BOOLEAN NOT NULL
);

-- СВЯЗЫВАНИЕ БД ВНЕШНИМИ КЛЮЧАМИ --
ALTER TABLE location
    ADD CONSTRAINT FR_location_of_geographical_object
        FOREIGN KEY (id_geographical_object) REFERENCES geographical_object (id);

ALTER TABLE location
    ADD CONSTRAINT FR_location_of_mars_station
        FOREIGN KEY (id_mars_station) REFERENCES mars_station (id);

ALTER TABLE mars_station
    ADD CONSTRAINT FR_mars_station_of_transport
        FOREIGN KEY (id_transport) REFERENCES transport (id);

ALTER TABLE mars_station
    ADD CONSTRAINT FR_mars_station_of_employee
        FOREIGN KEY (id_employee) REFERENCES employee (id);

ALTER TABLE mars_station
    ADD CONSTRAINT FR_mars_station_of_moderator
        FOREIGN KEY (id_moderator) REFERENCES employee (id)
;
ALTER TABLE employee
    ADD CONSTRAINT FR_employee_organization_of_users
        FOREIGN KEY (id_user) REFERENCES users (id);


-- ПОЛЬЗОВАТЕЛЬ (АУТЕНФИКАЦИЯ)
INSERT INTO users (login, password, admin)
VALUES ('user001', '123456', false),
       ('user002', '123456', false),
       ('user003', '123456', true),
       ('user004', '123456', true);

SELECT *
FROM users;

-- Начальник (ПРИНМАЮЩИЙ ЗАКАЗЧИКА) и Ученые (ЗАКАЗЧИК)
INSERT INTO employee (full_name, post, name_organization, address, id_user)
VALUES ('Джон Гротцингер', 'Профессор геологии, главный ученый миссии марсохода Curiosity',
        'Калифорнийский технологический институт (Caltech)', '', 1),
       ('Сергей Павлович Королев', 'Руководитель', 'Главное управление по ракетостроению и ракетным двигателям (ГУРРД)',
        '', 2),
       ('Джеймс М. Бегс', 'Руководитель NASA', 'NASA', '', 3),
       ('Георгий Тимофеевич Береговой', 'Начальник',
        'Межпланетный отдел Центрального научно-исследовательского института машиностроения (ЦНИИмаш) имени академика М. В. Хруничева',
        '', 4);

SELECT *
FROM employee;

-- ГЕОГРАФИЧЕСКИЙ ОБЪЕКТ (УСЛУГА)
INSERT INTO geographical_object (feature, type, size, describe, status)
VALUES ('Acidalia Planitia', 'Planitia, planitiae', 2300,
        'обширная тёмная равнина на Марсе. Размер — около 3 тысяч км, координаты центра — 50° с. ш. 339°. Расположена между вулканическим регионом Тарсис и Землёй Аравия, к северо-востоку от долин Маринера. На севере переходит в Великую Северную равнину, на юге — в равнину Хриса; на восточном краю равнины находится регион Кидония. Диаметр около 3000 км.',
        true),
       ('Alba Patera', 'Patera, paterae', 530,
        'Огромный низкий вулкан, расположенный в северной части региона Фарсида на планете Марс. Это самый большой по площади вулкан на Марсе: потоки извергнутой из него породы прослеживаются на расстоянии как минимум 1350 км от его пика.',
        true),
       ('Albor Tholus', 'Tholus, tholi', 170,
        'Потухший вулкан нагорья Элизий, расположенный на Марсе. Находится к югу от соседних горы Элизий и купола Гекаты. Вулкан достигает 4,5 километров в высоту и 160 километров в диаметре основания.',
        true),
       ('Amazonis Planitia', 'Planitia, planitiae', 2800,
        'Слабоокрашенная равнина в северной экваториальной области Марса. Довольно молода, породы имеют возраст 10-100 млн. лет. Часть этих пород представляют собой застывшую вулканическую лаву.',
        true),
       ('Arabia Terra', 'Terra, terrae', 5100,
        'Большая возвышенная область на севере Марса, которая лежит в основном в четырехугольнике Аравия, но небольшая часть находится в четырехугольнике Маре Ацидалиум. Она густо изрыта кратерами и сильно разрушена.',
        true);

SELECT *
FROM geographical_object;

-- ТРАНСПОРТ (ДОП. ИНФА К УСЛУГЕ)
INSERT INTO transport (name, type)
VALUES ('Mars Pathfinder Rover (USA)', 'Rover'),
       ('Viking 1 Lander (USA)', 'Spacecraft'),
       ('Ingenuity', 'Aircraft'),
       ('Mars 6 Lander (USSR)', 'Spacecraft'),
       ('Mars 2 Lander (USSR)', 'Spacecraft');

SELECT *
FROM transport;

-- МАРСИАНСКАЯ СТАНЦИЯ (ЗАЯВКА)
-- Примечание:
-- Тип заявки (например, исследовательская, коммерческая и т. д.)
-- status_task
-- 1: Введен: Заявка только что создана и ожидает обработки.
-- 2: В работе: Заявка была принята и находится в процессе выполнения.
-- 3: Завершена: Заявка успешно выполнена.
-- 4: Отменена: Заявка была отменена по каким-либо причинам.
-- 5: Удалена: Заявка была удалена из системы.
-- status_mission
-- 1: Успех
-- 2: Потеря
-- 3: Работает
INSERT INTO mars_station (type_status, date_create, date_form, date_close, id_employee, id_moderator, id_transport,
                          status_task, status_mission)
VALUES ('Исследовательская', '1972-09-01', '1973-11-04', '1975-05-08', 1, 3, 1, 1, 3),
       ('Коммерческая', '1975-05-08', '1976-11-07', '1977-11-01', 2, 3, 2, 2, 3),
       ('Коммерческая', '1982-07-15', '1983-07-11', '1984-01-06', 3, 4, 3, 3, 2),
       ('Исследовательская', '1968-06-17', '1969-04-09', '1970-03-03', 1, 4, 4, 4, 3),
       ('Исследовательская', '1988-03-18', '1989-05-05', '1990-05-07', 4, 4, 5, 5, 1);

SELECT *
FROM mars_station;

-- МЕСТОПОЛОЖЕНИЕ (ВСПОМОГАТЕЛЬНАЯ ТАБЛИЦА ДЛЯ М-М УСЛУГА-ЗАЯВКА)
INSERT INTO location (id_geographical_object, id_mars_station)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5);

SELECT *
FROM location;

-- Отображают данные только те транспорты, у которого совпадает с ID географический объект
-- То есть, какие транспорты побывали на географическом объекте, то и будут отображаться
SELECT MS.id,
       GO.id,
       GO.feature,
       GO.type,
       GO.size,
       GO.describe,
       GO.status,
       T.id,
       T.name,
       T.type,
       T.describe
FROM location as L
         INNER JOIN geographical_object as GO ON L.id_geographical_object = GO.id
         INNER JOIN mars_station as MS ON L.id_mars_station = MS.id
         INNER JOIN transport as T ON MS.id_transport = T.id
WHERE T.id = 1;

-- Отображают географические объекты кроме с статусом "Удален"
SELECT GO.id,
       GO.feature,
       GO.type,
       GO.describe
FROM location as L
         INNER JOIN geographical_object as GO ON L.id_geographical_object = GO.id
         INNER JOIN mars_station as MS ON L.id_mars_station = MS.id
WHERE MS.status_task = 1;

-- Отображают географические объекты со статусом ИСТИНА
SELECT *
FROM geographical_object as GO
WHERE GO.status = true;

-- UPDATE geographical_object as GO SET status = False WHERE id = 3;


-- SELECT MS.id, L.id from mars_station as MS
-- INNER JOIN location as L ON L.id_mars_station = MS.id;

SELECT id, photo_byte
FROM geographical_object;
-- CREATE DATABASE mars;
-- /connect web_mars;
-- DROP DATABASE mars;

DROP TABLE geographical_object, transport, location, mars_station, employee, users CASCADE;

-- Географические объекты
CREATE TABLE geographical_object
(
    id         SERIAL PRIMARY KEY,
    feature    VARCHAR NOT NULL,
    type       VARCHAR NOT NULL,
    size       INT     NULL,
    describe   VARCHAR NULL,
    url_photo  VARCHAR NULL,
    photo_byte BYTEA   NULL,
    -- Доступен / недоступен
    status     BOOLEAN NOT NULL
);

-- Транспортом могжет быть: посадочные, марсоходы, марсолеты и т.д.
CREATE TABLE transport
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR NOT NULL,
    type       VARCHAR NOT NULL,
    describe   VARCHAR NULL,
    url_photo  VARCHAR NULL,
    photo_byte BYTEA   NULL
);

-- Местоположение
CREATE TABLE location
(
    -- Порядковый номер
    id                     SERIAL PRIMARY KEY,
    id_geographical_object INT NOT NULL,
    id_mars_station        INT NOT NULL
);

-- Марсианская станция
CREATE TABLE mars_station
(
    id             SERIAL PRIMARY KEY,
    type_status    VARCHAR NOT NULL,
    date_create    DATE    NOT NULL,
    date_form      DATE    NULL,
    date_close     DATE    NULL,
    id_employee    INT     NOT NULL,
    id_moderator   INT     NULL,
    id_transport   INT     NULL,
    -- СТАТУС (ДЛЯ ЗАЯВКИ)
    -- status_task
    -- 1: Введен: Заявка только что создана и ожидает обработки.
    -- 2: В работе: Заявка была принята и находится в процессе выполнения.
    -- 3: Завершена: Заявка успешно выполнена.
    -- 4: Отменена: Заявка была отменена по каким-либо причинам.
    -- 5: Удалена: Заявка была удалена из системы.
    -- status_mission
    -- 1: Успех
    -- 2: Потеря
    -- 3: Работает
    status_task    INT     NOT NULL,
    status_mission INT     NOT NULL
);

CREATE TABLE employee
(
    id                SERIAL PRIMARY KEY,
    full_name         VARCHAR NOT NULL,
    post              VARCHAR NOT NULL,
    name_organization VARCHAR NOT NULL,
    address           VARCHAR NULL,
    id_user           INT     NOT NULL
);

CREATE TABLE users
(
    id       SERIAL PRIMARY KEY,
    login    VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    admin    BOOLEAN NOT NULL
);

-- СВЯЗЫВАНИЕ БД ВНЕШНИМИ КЛЮЧАМИ --
ALTER TABLE location
    ADD CONSTRAINT FR_location_of_geographical_object
        FOREIGN KEY (id_geographical_object) REFERENCES geographical_object (id);

ALTER TABLE location
    ADD CONSTRAINT FR_location_of_mars_station
        FOREIGN KEY (id_mars_station) REFERENCES mars_station (id);

ALTER TABLE mars_station
    ADD CONSTRAINT FR_mars_station_of_transport
        FOREIGN KEY (id_transport) REFERENCES transport (id);

ALTER TABLE mars_station
    ADD CONSTRAINT FR_mars_station_of_employee
        FOREIGN KEY (id_employee) REFERENCES employee (id);

ALTER TABLE mars_station
    ADD CONSTRAINT FR_mars_station_of_moderator
        FOREIGN KEY (id_moderator) REFERENCES employee (id)
;
ALTER TABLE employee
    ADD CONSTRAINT FR_employee_organization_of_users
        FOREIGN KEY (id_user) REFERENCES users (id);


-- ПОЛЬЗОВАТЕЛЬ (АУТЕНФИКАЦИЯ)
INSERT INTO users (login, password, admin)
VALUES ('user001', '123456', false),
       ('user002', '123456', false),
       ('user003', '123456', true),
       ('user004', '123456', true);

SELECT *
FROM users;

-- Начальник (ПРИНМАЮЩИЙ ЗАКАЗЧИКА) и Ученые (ЗАКАЗЧИК)
INSERT INTO employee (full_name, post, name_organization, address, id_user)
VALUES ('Джон Гротцингер', 'Профессор геологии, главный ученый миссии марсохода Curiosity',
        'Калифорнийский технологический институт (Caltech)', '', 1),
       ('Сергей Павлович Королев', 'Руководитель', 'Главное управление по ракетостроению и ракетным двигателям (ГУРРД)',
        '', 2),
       ('Джеймс М. Бегс', 'Руководитель NASA', 'NASA', '', 3),
       ('Георгий Тимофеевич Береговой', 'Начальник',
        'Межпланетный отдел Центрального научно-исследовательского института машиностроения (ЦНИИмаш) имени академика М. В. Хруничева',
        '', 4);

SELECT *
FROM employee;

-- ГЕОГРАФИЧЕСКИЙ ОБЪЕКТ (УСЛУГА)
INSERT INTO geographical_object (feature, type, size, describe, status)
VALUES ('Acidalia Planitia', 'Planitia, planitiae', 2300,
        'обширная тёмная равнина на Марсе. Размер — около 3 тысяч км, координаты центра — 50° с. ш. 339°. Расположена между вулканическим регионом Тарсис и Землёй Аравия, к северо-востоку от долин Маринера. На севере переходит в Великую Северную равнину, на юге — в равнину Хриса; на восточном краю равнины находится регион Кидония. Диаметр около 3000 км.',
        true),
       ('Alba Patera', 'Patera, paterae', 530,
        'Огромный низкий вулкан, расположенный в северной части региона Фарсида на планете Марс. Это самый большой по площади вулкан на Марсе: потоки извергнутой из него породы прослеживаются на расстоянии как минимум 1350 км от его пика.',
        true),
       ('Albor Tholus', 'Tholus, tholi', 170,
        'Потухший вулкан нагорья Элизий, расположенный на Марсе. Находится к югу от соседних горы Элизий и купола Гекаты. Вулкан достигает 4,5 километров в высоту и 160 километров в диаметре основания.',
        true),
       ('Amazonis Planitia', 'Planitia, planitiae', 2800,
        'Слабоокрашенная равнина в северной экваториальной области Марса. Довольно молода, породы имеют возраст 10-100 млн. лет. Часть этих пород представляют собой застывшую вулканическую лаву.',
        true),
       ('Arabia Terra', 'Terra, terrae', 5100,
        'Большая возвышенная область на севере Марса, которая лежит в основном в четырехугольнике Аравия, но небольшая часть находится в четырехугольнике Маре Ацидалиум. Она густо изрыта кратерами и сильно разрушена.',
        true);

SELECT *
FROM geographical_object;

-- ТРАНСПОРТ (ДОП. ИНФА К УСЛУГЕ)
INSERT INTO transport (name, type)
VALUES ('Mars Pathfinder Rover (USA)', 'Rover'),
       ('Viking 1 Lander (USA)', 'Spacecraft'),
       ('Ingenuity', 'Aircraft'),
       ('Mars 6 Lander (USSR)', 'Spacecraft'),
       ('Mars 2 Lander (USSR)', 'Spacecraft');

SELECT *
FROM transport;

-- МАРСИАНСКАЯ СТАНЦИЯ (ЗАЯВКА)
-- Примечание:
-- Тип заявки (например, исследовательская, коммерческая и т. д.)
-- status_task
-- 1: Введен: Заявка только что создана и ожидает обработки.
-- 2: В работе: Заявка была принята и находится в процессе выполнения.
-- 3: Завершена: Заявка успешно выполнена.
-- 4: Отменена: Заявка была отменена по каким-либо причинам.
-- 5: Удалена: Заявка была удалена из системы.
-- status_mission
-- 1: Успех
-- 2: Потеря
-- 3: Работает
INSERT INTO mars_station (type_status, date_create, date_form, date_close, id_employee, id_moderator, id_transport,
                          status_task, status_mission)
VALUES ('Исследовательская', '1972-09-01', '1973-11-04', '1975-05-08', 1, 3, 1, 1, 3),
       ('Коммерческая', '1975-05-08', '1976-11-07', '1977-11-01', 2, 3, 2, 2, 3),
       ('Коммерческая', '1982-07-15', '1983-07-11', '1984-01-06', 3, 4, 3, 3, 2),
       ('Исследовательская', '1968-06-17', '1969-04-09', '1970-03-03', 1, 4, 4, 4, 3),
       ('Исследовательская', '1988-03-18', '1989-05-05', '1990-05-07', 4, 4, 5, 5, 1);

SELECT *
FROM mars_station;

-- МЕСТОПОЛОЖЕНИЕ (ВСПОМОГАТЕЛЬНАЯ ТАБЛИЦА ДЛЯ М-М УСЛУГА-ЗАЯВКА)
INSERT INTO location (id_geographical_object, id_mars_station)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5);

SELECT *
FROM location;

-- Отображают данные только те транспорты, у которого совпадает с ID географический объект
-- То есть, какие транспорты побывали на географическом объекте, то и будут отображаться
SELECT MS.id,
       GO.id,
       GO.feature,
       GO.type,
       GO.size,
       GO.describe,
       GO.status,
       T.id,
       T.name,
       T.type,
       T.describe
FROM location as L
         INNER JOIN geographical_object as GO ON L.id_geographical_object = GO.id
         INNER JOIN mars_station as MS ON L.id_mars_station = MS.id
         INNER JOIN transport as T ON MS.id_transport = T.id
WHERE T.id = 1;

-- Отображают географические объекты кроме с статусом "Удален"
SELECT GO.id,
       GO.feature,
       GO.type,
       GO.describe
FROM location as L
         INNER JOIN geographical_object as GO ON L.id_geographical_object = GO.id
         INNER JOIN mars_station as MS ON L.id_mars_station = MS.id
WHERE MS.status_task = 1;

-- Отображают географические объекты со статусом ИСТИНА
SELECT *
FROM geographical_object as GO
WHERE GO.status = true;

-- UPDATE geographical_object as GO SET status = False WHERE id = 3;


-- SELECT MS.id, L.id from mars_station as MS
-- INNER JOIN location as L ON L.id_mars_station = MS.id;

SELECT id, photo_byte
FROM geographical_object;