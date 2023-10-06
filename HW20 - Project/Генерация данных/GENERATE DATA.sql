/*Генерация данных, запускать последовательно по пунктам*/

--1. Владельцы и дилеры

DECLARE @nameO NVARCHAR(100),
		@nameD NVARCHAR(100),
        @num INT = 0,
		@is_deleted BIT = 0,
		@seq_numO INT,
		@seq_numD INT

/*Владельцы*/
/*************************************************************************************************************/
WHILE(@num < 11)
BEGIN
   SET @seq_numO = NEXT VALUE FOR [dbo].[owners_sequence]
   SET @nameO = N'ИП Владелец ' + CAST(@seq_numO AS NVARCHAR)
   
   IF ((@num % 3) = 0)
      SET @is_deleted = 1
   ELSE
	  SET @is_deleted = 0

   /*создаем владельцев*/ 
   INSERT INTO [Directory].[Owners]
   ([name], [is_deleted], [seq_number])
   VALUES
   (@nameO, @is_deleted, @seq_numO)

   SET @num = @num + 1
END
/*Дилеры*/
/*************************************************************************************************************/
SET @num = 0
WHILE(@num < 31)
BEGIN
   SET @seq_numD = NEXT VALUE FOR [dbo].[dealers_sequence]
   SET @nameD = N'ИП Дилер ' + CAST(@seq_numD AS NVARCHAR)

   IF ((@num % 3) = 0)
      SET @is_deleted = 1
   ELSE
	  SET @is_deleted = 0
   /*создаем дилеров*/
   INSERT INTO [Directory].[Dealers]
   ([name], [seq_number], [is_deleted])
   VALUES
   (@nameD, @seq_numD, @is_deleted)
	
   SET @num = @num + 1	
END
/*************************************************************************************************************/

--2. создать договора между дилерами и владельцами
DECLARE @owners_T TABLE(id_owner INT)
DECLARE @dealers_T TABLE(id_dealer INT, seq_n INT)
DECLARE @id_d INT,
        @id_o INT,
		@i INT = 0  

INSERT INTO @owners_T 
SELECT id FROM Directory.Owners WHERE is_deleted = 0

INSERT INTO @dealers_T 
(id_dealer, seq_n)
SELECT id, seq_number FROM Directory.Dealers WHERE is_deleted = 0

WHILE((SELECT COUNT(*) FROM @owners_T) > 0)
BEGIN
   SELECT @id_o = id_owner FROM @owners_T
   SET @i = 0

   WHILE(@i < 3) --по 3 дилера на владельца
   BEGIN
       SET @id_d = 0
       SELECT @id_d = id_dealer FROM @dealers_T

	   IF @id_d IS NOT NULL AND @id_d <> 0
	   BEGIN
		   INSERT INTO [Directory].[Contracts]
		   ([owner_id], [dealer_id], [is_closed])
		   VALUES
		   (@id_o, @id_d, 0)

		   DELETE FROM @dealers_T WHERE id_dealer = @id_d
	   END
       SET @i = @i + 1		   
   END
   
   DELETE FROM @owners_T WHERE id_owner = @id_o
END

/*************************************************************************************************************/


--3. Точки продаж

DECLARE @cnt_points INT,
        @point_n NVARCHAR(100),
		@d_id INT
		
DECLARE @d_T TABLE(id_dealer INT)

INSERT INTO @d_T 
(id_dealer)
SELECT id FROM Directory.Dealers WHERE is_deleted = 0

WHILE(SELECT COUNT(*) FROM @d_T) > 0
BEGIN
    
	SELECT @d_id = id_dealer FROM @d_T

	SET @cnt_points = FLOOR(RAND()*(5))+1; --случайное число точек продаж
	WHILE(@cnt_points > 0)
	BEGIN
		SET @point_n = N'Точка продаж_' + CAST(@d_id AS NVARCHAR) + '_' + CAST(@cnt_points AS NVARCHAR)

		INSERT INTO [Directory].[Points]
		([name], [dealer_id])
		VALUES
		(@point_n, @d_id)

	    SET @cnt_points = @cnt_points - 1
	END

	DELETE FROM @d_T WHERE id_dealer = @d_id
	
END
/*************************************************************************************************************/

--4. Площадки + залы
DECLARE @venues table (id INT, name NVARCHAR(100))
INSERT INTO @venues
(id, name)
VALUES
(50000,N' Музейный центр «Прошлое. Настоящее. Будущее»'),
(50001,N' Тихоновская сельская библиотека-филиал № 26'),
(50002,N' Михайловская модельная библиотека - филиал №16'),
(50003,N' Инченковская сельская библиотека- филиал № 6'),
(50004,N' МБУК Музей истории города Бородино'),
(50005,N' ДК с.п. Шалушка'),
(50006,N' Модельная библиотека-филиал № 2'),
(50007,N' МУК «Центр Досуга» г.п «Могзонское»'),
(50008,N' «ГДК Мелеуз»'),
(50009,N' Центральная детская библиотека'),
(50010,N' Манский РДК'),
(50011,N' Клуб "Душа поет" (Уфа)'),
(50012,N' Городской Дворец Культуры г. Мелеуз'),
(50013,N' МАУК ЦНТ Баймак'),
(50014,N' ЦКиД Зилаир'),
(50015,N' Дом культуры п. Кузино'),
(50016,N' Червленская сельская библиотека'),
(50017,N' Ново-Щедринская сельская библиотека'),
(50018,N' Шелковская детская библиотека'),
(50019,N' Ушкалойский зал'),
(50020,N' Билитуйская районная библиотека'),
(50021,N' Белогорская библиотека'),
(50022,N' Бугаройская сельская библиотека-филиал №7'),
(50023,N' Городской дом культуры г. Бердска'),
(50024,N' Литературно-мемориальный музей А.С. Сулейманова'),
(50025,N' ДК «Юбилейный»'),
(50026,N' Эльбрусский региональный колледж'),
(50027,N' Старогладовский сельский дом культуры'),
(50028,N' Дом культуры городского округа ЗАТО Светлый'),
(50029,N' Кень-Юртовская библиотека'),
(50030,N' Красненская сельская библиотека-клуб'),
(50031,N' ГБУ ДО «Центральная школа искусств№1» г. Грозного'),
(50032,N' Воронежский концертный зал'),
(50033,N' Дворец культуры г. Воркута'),
(50034,N' Городской Дворец культуры'),
(50035,N' МБУК «ЦКС Шелковского муниципального района»'),
(50036,N' Дом культуры с.п. Кичмалка'),
(50037,N' МБУК Североморская ЦБС'),
(50038,N' Галерея «Виктор Иванов и земля рязанская»'),
(50039,N' Детская художественная школа №1 г. Грозного'),
(50040,N' Концертный зал Лаишевского районного дома культуры'),
(50041,N' Дом культуры сельского поселения Яникой'),
(50042,N' Азановский центр культуры'),
(50043,N' Филиал МБУК «Районный дом культуры» с. Беклемишево'),
(50044,N' МБУК "Киреевский районный Дом Культуры'),
(50045,N' МКУК "Сельский Дом Культуры" с. п. Куба КБР'),
(50046,N' МБУК «Центр творчества и досуга» г. Калининск'),
(50047,N' Центр Культурного развития г. Гудермес'),
(50048,N' Колледж "Строитель"'),
(50049,N' МКУК "Дом культуры с. п. Былым"'),
(50050,N' МКУК «Солдато-Александровское СКО»'),
(50051,N' МБУ "Районный Дом культуры" Ванинского района'),
(50052,N' МБУК "Няндомская центр. районная библиотека"'),
(50053,N' МКУ "ТЮЗ" Нальчик'),
(50054,N' ГБПОУ РД «ТК им.Р.Н.Ашуралиева»'),
(50055,N' МКУ «Дом культуры сельского поселения Троицкое»'),
(50056,N' Библиотека-филиал № 3 г. Грозного'),
(50057,N' ГБУ ДО «ЭБЦ» Минпросвещения КБР.'),
(50058,N' Особняк Кельха'),
(50059,N' Филиал МБУ РЦКС "Дом культуры с.Правобережное"'),
(50060,N' Мемориальный музей-квартира А. С. Пушкина'),
(50061,N' МБУК КДЦ с. Коса'),
(50062,N' ДК село Герменчик'),
(50063,N' МКУ "ДК г. Аргун"'),
(50064,N' Строгановский дворец'),
(50065,N' Дом культуры села Яндаре'),
(50066,N' Николаевский дворец, г. Санкт-Петербург'),
(50067,N' ГБУ «Мемориальный комплекс Славы им.А.А. Кадырова»'),
(50068,N' ДК им. Горбунова'),
(50069,N' Дворец "Олимпия"'),
(50070,N' Демо площадка'),
(50071,N' Екатерининский зал Таврического дворца'),
(50072,N' Дом Шрёдера - Культурный центр'),
(50073,N' Государственный Якутский Цирк'),
(50074,N' ЦИРК-ШАПИТО "КУДЗИНОВ"  ТК "Просто рынок"'),
(50075,N' Особняк А.П.Брюллова'),
(50076,N' Цирк Анастасия г. Ачинск'),
(50077,N' Цирк-шапито "Кудзинов" г. Реутов'),
(50078,N' Клуб "RED"'),
(50079,N' Московский Дворец Молодёжи (МДМ)'),
(50080,N' Театр Аквариум'),
(50081,N' Киноконцертный  комплекс "Звездный"'),
(50082,N' Концертно-билетное агентство "КрымБилет"'),
(50083,N' Спортивно-развлекательный комплекс "Муссон"'),
(50084,N' Клуб « М5»--- Санкт-Петербург'),
(50085,N' площадка--- Санкт-Петербург'),
(50086,N' Симферопольский цирк им. Б. Тезикова'),
(50087,N' Третьяковская галерея'),
(50088,N' Карельская государственная филармония'),
(50089,N' Таврический дворец'),
(50090,N' Детский теплоход "В гостях у сказки"'),
(50091,N' КЦ Елены Образцовой'),
(50092,N' Интерьерный театр новый зал'),
(50093,N' Дельфинарий'),
(50094,N' Театр на Васильевском (сц) Рус.варен'),
(50095,N' Театр Буфф(ЗЕРК.Гос.нов)'),
(50096,N' Родина - кино/центр'),
(50097,N' Причал реки Мойки 44'),
(50098,N' Эрмитажный театр'),
(50099,N' Клуб «Космонавт»')

UPDATE @venues SET name = LTRIM(RTRIM(name))

DECLARE @halls table (venue_id INT, name NVARCHAR(100))
INSERT INTO @halls
(venue_id, name)
VALUES
(50000,N'Основной зал'),
(50001,N'Основной зал'),
(50002,N'Основной зал'),
(50003,N'Основной зал'),
(50004,N'Зал 1'),
(50004,N'Зал 2'),
(50004,N'Зал 3'),
(50004,N'Зал 4'),
(50004,N'Зал 5'),
(50004,N'Зал 6'),
(50004,N'Зал 7'),
(50004,N'Зал 8'),
(50004,N'Зал 9'),
(50004,N'Зал 10'),
(50005,N'Основной зал'),
(50006,N'Основной зал'),
(50007,N'Основной зал'),
(50008,N'Основной зал'),
(50009,N'Основной'),
(50010,N'Основной зал'),
(50010,N'Основной зал с местами'),
(50011,N'Зрительный зал'),
(50012,N'Зрительный зал'),
(50013,N'Зрительный зал'),
(50014,N'Основной зал'),
(50015,N'Основной'),
(50016,N'Основной'),
(50017,N'Основной'),
(50018,N'Основной'),
(50019,N'Основной'),
(50020,N'Основной зал'),
(50021,N'Основной'),
(50022,N'Основной зал'),
(50023,N'Основной зал со схемой'),
(50023,N'Основной зал входные'),
(50024,N'Основной'),
(50025,N'Основной'),
(50026,N'Основной'),
(50027,N'Основной зал'),
(50028,N'Основной'),
(50029,N'Основной'),
(50030,N'Основной'),
(50031,N'Основной зал'),
(50032,N'Малый зал'),
(50033,N'Основной зал'),
(50034,N'Основной зал'),
(50035,N'Основной зал'),
(50036,N'Основной'),
(50037,N'ЦДБ имени С.Михалкова'),
(50037,N'ЦГБ имени Л.Крейна'),
(50038,N'Основной'),
(50039,N'Основной'),
(50040,N'Основной'),
(50041,N'Основной'),
(50042,N'Основной'),
(50043,N'Основной'),
(50044,N'Основной зал'),
(50045,N'Основной'),
(50046,N'Основной зал'),
(50047,N'Основной'),
(50048,N'Основной'),
(50049,N'Основной'),
(50050,N'Основной'),
(50051,N'Основной'),
(50051,N'Киноконцертный зал'),
(50051,N'Концертно-выставочный зал'),
(50051,N'Фойе'),
(50051,N'Кабинет 13'),
(50052,N'Основной зал'),
(50052,N'Основной зал (запасной)'),
(50052,N'Экскурсия'),
(50052,N'Основной зал  Квест-игра'),
(50052,N'Читальный зал'),
(50052,N'Зал "Библиотека Каргополь - 2" старый формат рассадки'),
(50052,N'Зал "Библиотека Каргополь - 2" новый'),
(50052,N'Зал «Центральной районной библиотеки»'),
(50052,N'Зал молодежного центра «Старт UP»'),
(50052,N'Зал «Мошинской библиотеки»'),
(50053,N'Основной'),
(50054,N'Основной зал'),
(50055,N'Основной'),
(50056,N'Читальный зал'),
(50057,N'Основной'),
(50058,N'Готическая столовая'),
(50058,N'Белый (танцевальный) зал парадной анфилады'),
(50058,N'Белый (танцевальный) зал парадной анфилады (7 рядов)'),
(50058,N'Белый (танцевальный) зал парадной анфилады'),
(50059,N'Основной'),
(50060,N'Свободная рассадка'),
(50062,N'Основной'),
(50063,N'Основной зал'),
(50064,N'Большой зал'),
(50065,N'Свободная рассадка'),
(50066,N'Основной зал'),
(50067,N'Основной зал'),
(50067,N'Зал ВОВ'),
(50067,N'Актовый Зал'),
(50067,N'Выставочный Зал'),
(50067,N'Зал Победы'),
(50067,N'Зал картинной галереи'),
(50067,N'Центральный зал'),
(50068,N'Основной зал (Партер)'),
(50069,N'Основной зал'),
(50070,N'Зал с местами'),
(50070,N'Зал с входными билетами'),
(50071,N'Основной зал'),
(50072,N'Кафе-шантан'),
(50072,N'Зал кукол. Пространство семейного творчества.'),
(50072,N'Театральная сцена'),
(50072,N'Концертная сцена'),
(50072,N'Праздничная рассадка'),
(50072,N'Зал кукол. Пространство семейного творчества 1.'),
(50072,N'Рассадка на две сцены'),
(50072,N'Экскурсионный'),
(50072,N'Бал. Шоу. Праздничный вечер.'),
(50072,N'Зал кукол. Творческое пространство.'),
(50073,N'Основной зал'),
(50074,N'Малый зал'),
(50075,N'Особняк А.П.Брюллова'),
(50075,N'Парадный зал'),
(50076,N'Основной'),
(50077,N'Основной зал'),
(50078,N'Основной зал'),
(50079,N'Большой зал'),
(50079,N'Фойе МДМ новый'),
(50079,N'Большой зал МДМ'),
(50080,N'Основной зал'),
(50080,N'Основной зал'),
(50080,N'Основной зал'),
(50080,N'Входные билеты'),
(50080,N'Основной зал 2'),
(50081,N'Основной'),
(50081,N'Основной зал - новый'),
(50082,N'Основной1'),
(50083,N'Основной'),
(50083,N'Основной 1'),
(50083,N'Муссон'),
(50086,N'Основной зал'),
(50087,N'Конференц-зал'),
(50088,N'Основной зал'),
(50089,N'Основной зал'),
(50089,N'Органный зал'),
(50089,N'Новый зал'),
(50090,N'Основной зал'),
(50091,N'Основной'),
(50091,N'взрослый'),
(50091,N'детский'),
(50091,N'Основной зал'),
(50092,N'Основной зал'),
(50093,N'Основной зал'),
(50094,N'Основной зал'),
(50095,N'Основной зал'),
(50096,N'Основной зал'),
(50097,N'Основной зал'),
(50098,N'Основной зал 2'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Основной зал'),
(50098,N'Санкт-Петербург, Эрмитажный театр'),
(50098,N'Основной зал'),
(50098,N'Основной зал (с местами)'),
(50099,N'Основной зал'),
(50099,N'Основной зал'),
(50099,N'Основной зал'),
(50099,N'Основной зал'),
(50099,N'Входные места')

DECLARE @id_venues INT
DECLARE @insert_id INT

/*привязываем залы к площадкам*/
WHILE(SELECT COUNT(*) FROM @venues) > 0
BEGIN
   SELECT @id_venues = id FROM @venues

   INSERT INTO Directory.Venues
   (name, description, is_deleted)
   SELECT
   TRIM(name), TRIM(name), 0
   FROM @venues 
   WHERE id = @id_venues

   SET @insert_id = SCOPE_IDENTITY()
   
   INSERT INTO Directory.Halls
   (name, venue_id, is_deleted)
   SELECT
    TRIM(name), @insert_id, 0
   FROM @halls
   WHERE venue_id = @id_venues

   DELETE FROM @venues where id = @id_venues
END
/*************************************************************************************************************/

--5. Места (посадка)
DECLARE @sector_max INT = 3, /*максимальное возможное значение количество секторов*/
        @sectors INT, @s INT 
DECLARE @row_number_max INT = 10, /*максимальное возможное значение рядов*/
		@row_numbers INT, @rn INT
DECLARE @place_number_max INT = 5, /*максимальное возможное значение количества стульев/кресел/т.п. в ряду*/
        @place_numbers INT, @pn INT
DECLARE @id_h INT

DECLARE @halls_for_places TABLE (id INT)

INSERT INTO @halls_for_places
SELECT id FROM Directory.Halls

WHILE(SELECT COUNT(*) FROM @halls_for_places) > 0
BEGIN
	SELECT @id_h = id FROM @halls_for_places

	/*установим случайные значения*/
	SET @sectors = FLOOR(RAND()*(@sector_max-1)+1);
	SET @row_numbers = FLOOR(RAND()*(@row_number_max-1)+1);
	SET @place_numbers = FLOOR(RAND()*(@place_number_max-1)+1);
	SET @s = 1
	/*переходим к заполнению*/
	WHILE(@s < @sectors)
	BEGIN
	    SET @rn = 1
		WHILE(@rn < @row_numbers)
		BEGIN
		    SET @pn = 1
		    WHILE(@pn < @place_numbers)
			BEGIN
			    INSERT INTO Directory.Places
				(sector, [row_number], place_number, hall_id)
				VALUES
				(@s, @rn, @pn, @id_h)
				SET @pn = @pn + 1
			END
			SET @rn = @rn + 1
		END
	   SET @s = @s + 1
	END
	
	DELETE FROM @halls_for_places WHERE id = @id_h
END
/*************************************************************************************************************/

--6. Мероприятия
DECLARE @test_events  TABLE (name_event NVARCHAR(100))
INSERT INTO @test_events
VALUES
(N'Ансамбль Д.Голощекина'),
(N'Джон Скотт Уайтли'),
(N'Носитель: избранное. Pop-up театр.'),
(N'Александр Ф. Скляр. Хиты группы "Ва- банкъ".'),
(N'Анекдот, рассказанный помещиком Лидиным'),
(N'Спектакль "Слишком женатый таксист"'),
(N'Спектакль "Брак по-итальянски"'),
(N'Вика Цыганова'),
(N'Мероприятие для поставщика Test'),
(N'Концерт-Фильм ROGER WATERS - THE WALL'),
(N'Sun Say'),
(N'Винни-Пух и все-все-все'),
(N'Август: графство Осейдж'),
(N'Спасти рядового Гамлета 16+'),
(N'Голодранцы и аристократы'),
(N'Любовь и голуби'),
(N'Снежная королева'),
(N'Пенелопа'),
(N'Сказка о рыбаке, его жене и рыбке'),
(N'Город.Женитьба.Гоголь.'),
(N'С Новым годом, Лунтик! 0+'),
(N'Воспитание Риты'),
(N'Выставка «Чеченская Республика: летопись столетия»'),
(N'Концерт «В объятиях любви: Бах, Шопен, Лист, Чайковский»'),
(N'Выставка народного художника Кабардино-Балкарской Республики Алима Пашт-Хана'),
(N'«Сбирались птицы»'),
(N'Автобусная прогулка'),
(N'Концерт «День Конституции России»'),
(N'«Все начинается с матери!»'),
(N'Поэтический час «О женщине, чье имя – Мать!»'),
(N'«Зимняя мелодия»'),
(N'Русская народная музыка и танцы'),
(N'Мастер-класс "Память бабушки"'),
(N'Квест-игра "Поиски пиратского клада"'),
(N'«Осенний калейдоскоп»'),
(N'Фильм «Свидетель»'),
(N'Поделки из одноразовой посуды'),
(N'Выставка "Моя Якутия. Полеты."'),
(N'Интеллектуариум «Игротека в библиотеке»'),
(N'Игра-квиз «Школьная»'),
(N'Мастер-класс «Искусство хореографии»'),
(N'Трио А.Марчелли и А.Чижик'),
(N'Игорь Саруханов'),
(N'Путешествие в Индию для детей'),
(N'Фрекен Жюли'),
(N'Вокальный цикл  Юные годы'),
(N'Арии и романсы Мусоргского'),
(N'Саламбо'),
(N'И лишь надеждой жизнь согрета...'),
(N'Тина Кузнецова'),
(N'Концерт Стэнли Джордан'),
(N'Джазовый вечер с Давидом Голощекиным'),
(N'Жизель'),
(N'Кино на крыше «Розовая пантера»'),
(N'Спектакль на крыше / Компромиссы'),
(N'Лекция Михаила Пиотровского'),
(N'Органный концерт «Планета Барокко» – из цикла концертов «Вечера с Томасом Хьюзом»'),
(N'Гала-концерт "Viva Musica!"'),
(N'«Вижу тебя, знаю тебя»/«Ich sehe Dich, ich kenne Dich»'),
(N'Органный концерт «Магия времен. Германия и Россия»'),
(N'"Октябрь ..17"'),
(N'Концерт “Музыка сфер и музыка гор. Орган и дудук”'),
(N'Приключения Буратино'),
(N'Расценка № 555 / 0421 ТКК  2021г.'),
(N'Органные шедевры и оперные хиты. Бах, Лист, Верди, Беллини'),
(N'Концерт «Из сокровищницы классики: Бах, Вивальди, Шопен, Верди, Чайковский»'),
(N'Вечер камерной музыки "ГРАНИ РОМАНТИЗМА" (Р. Шуман, Р. Штраус, С.Рахманинов)'),
(N'А РЫБЫ СПЯТ?'),
(N'Жаль, что тебя здесь нет'),
(N'Концерт органной музыки  «ОРГАН НА ДВОИХ»'),
(N'Солнце и жизнь Земли'),
(N'Расценка № 314 Балет 2021г.'),
(N'Средь шумного бала. Концерт с экскурсией во дворце Фестиваль.»'),
(N'Сделаем правильный выбор'),
(N'8 марта. Программа для детей и родителей'),
(N'САНКТ-ПЕТЕРБУРГСКИЙ ОРКЕСТР САКСОФОНОВ'),
(N'Литературно-музыкальная программа «Весна Победы»'),
(N'"Памяти П.И. Чайковского посвящается..."'),
(N'Творческая встреча «Рождественские чтения»'),
(N'Поэтический час на тему «Поэзия, как музыка души»'),
(N'Литературно-музыкальная гостиная «Весны чарующая сила»'),
(N'Выставка «Осторожно, постмодерн!»'),
(N'Хореографический спектакль "Кармен"'),
(N'Ансамбль казаков "БАГАТИЦА"'),
(N'Синие розы'),
(N'LONE.Презентация второго альбома+все хиты'),
(N'Вечер премьер'),
(N'Кира Дымов "Любовь нас не отпустила"'),
(N'ЗОКИ и БАДА'),
(N'Zorge'),
(N'ЦЫГАНСКИЕ ТРЕЛИ'),
(N'"ПУШКИН,РОМАН С МУЗОЙ"'),
(N'Сирена и Виктория'),
(N'Ночь Первокурсника'),
(N'С тобой и без тебя'),
(N'Мария, Целуй меня крепче'),
(N'Ave Maria и другие шедевры. Голос и орган. Шуберт, Пуччини, Чайковский, Лист'),
(N'Концерт «Вселенная Рахманинова» в Таврическом дворце.'),
(N'Жизнеописание трубадуров'),
(N'"Опера. Любовные истории"')

DECLARE @id_owner INT
DECLARE @owners_tb TABLE (id INT)
INSERT INTO @owners_tb (id) SELECT id FROM Directory.Owners
DECLARE @how_many_events_for_each_owner INT
DECLARE @cnt_events INT = 1
DECLARE @cnt_owners INT
DECLARE @dyn_sql NVARCHAR(2000)

SELECT @cnt_events = COUNT(*) FROM @test_events
SELECT @cnt_owners = COUNT(*) FROM @owners_tb
--вычисляем сколько каждому владельцу мероприятий
SET @how_many_events_for_each_owner = ROUND(@cnt_events/(@cnt_owners),0,1)

WHILE(SELECT COUNT(*) FROM @owners_tb) > 0
BEGIN
	SELECT @id_owner = id FROM @owners_tb

	INSERT INTO Directory.[Events]
	(seq_number, name, owner_id, is_deleted)
	SELECT 
		NEXT VALUE FOR [dbo].[events_sequence], name_event, @id_owner, 0
	FROM (
		SELECT TOP (@how_many_events_for_each_owner) name_event
		FROM @test_events
		WHERE NOT EXISTS (SELECT 1 FROM Directory.[Events] de WHERE de.name = name_event)
         ) e
	DELETE FROM @owners_tb where id = @id_owner
END
/*************************************************************************************************************/

--7. События
DECLARE @event_t TABLE (id INT)
INSERT INTO @event_t
SELECT id FROM Directory.Events

DECLARE @id_event INT,
        @long_event INT,
		@event_time DATETIME = '20230908 00:00:00',
		@event_time_change DATETIME,
		@cntTimes INT, 
		@rand_hour INT,
        @y INT = 1
DECLARE @temp_halls TABLE (id INT)
DECLARE @id_hall INT

WHILE(SELECT COUNT(*) FROM @event_t) > 0
BEGIN
	SELECT @id_event = id FROM @event_t
	SET @long_event = FLOOR(RAND()*(4))+1; --длительность события
	SET @cntTimes = FLOOR(RAND()*(10))+1; --сколько раз будет проходить
	SET @rand_hour = FLOOR(RAND()*(18-9)+9); --время начала
	/*выбрали залы*/
	DELETE FROM @temp_halls
	INSERT INTO @temp_halls 
	SELECT TOP 2 id FROM Directory.Halls h
	WHERE NOT EXISTS(SELECT 1 FROM Directory.Events_time et WHERE et.hall_id =  h.id)

	SET @event_time_change = DATEADD(HOUR, @rand_hour, @event_time) --дата начала	
	WHILE(SELECT COUNT(*) FROM @temp_halls) > 0
	BEGIN

		SELECT @id_hall = id FROM @temp_halls
		SET @y = 1
		WHILE(@y < @cntTimes)
		BEGIN
		    SET @event_time_change = DATEADD(DAY, @y, @event_time_change) --дата начала
			INSERT INTO Directory.Events_time
			(event_id, hall_id, start_date, end_date, is_closed, is_deleted)
			VALUES
			(@id_event, @id_hall, @event_time_change, DATEADD(HOUR, @long_event, @event_time_change), 0, 0)
 
			SET @y = @y + 1
		END

		DELETE FROM @temp_halls WHERE id = @id_hall
	END

	DELETE FROM @event_t WHERE id = @id_event
END
/*************************************************************************************************************/

--7. Сервисный сбор
INSERT INTO Directory.Service_fee
(name, per_cent, [round])
VALUES
(N'0% без СС', 0, 0),
(N'2% CC, округление до целого', 2, 0),
(N'2% CC, округление до 1 знака', 2, 1),
(N'3% CC, округление до целого', 3, 0),
(N'3% CC, округление до 1 знака', 3, 1),
(N'5% CC, округление до целого', 5, 0),
(N'5% CC, округление до 1 знака', 5, 1),
(N'10% CC, округление до целого', 10, 0),
(N'10% CC, округление до 1 знака', 10, 1)

/*************************************************************************************************************/

--8. Сервисный сбор для события и точки
DECLARE @service_4_et_t TABLE (id INT IDENTITY(1,1), event_id INT, point_id INT)
DECLARE @id_set INT, @maxid INT, @minid INT

SELECT @maxid = MAX(id), @minid = MIN(id) FROM Directory.Service_fee

INSERT INTO @service_4_et_t
(event_id, point_id)
SELECT 
	DISTINCT et.id event_id, p.id 
FROM Directory.Events_time et
INNER JOIN Directory.Events e ON e.id = et.event_id
INNER JOIN Directory.Contracts c ON c.owner_id = e.owner_id
INNER JOIN Directory.Points p ON p.dealer_id = c.dealer_id
ORDER BY event_id

--select * from @service_4_et_t

WHILE((SELECT COUNT(*) FROM @service_4_et_t) > 0)
BEGIN
	SELECT @id_set = id FROM @service_4_et_t

	INSERT INTO Directory.Service_4_events_time
	(event_time_id, point_id, service_fee_id)
	SELECT
	event_id, point_id, FLOOR(RAND()*(@maxId-@minId)+@minId)
	FROM @service_4_et_t
	WHERE id = @id_set

	DELETE FROM @service_4_et_t WHERE id = @id_set
END
/*************************************************************************************************************/

--9. Статусы
INSERT INTO Dictionary.Statuses
(name, description, table_id)
VALUES
('10', N'Активный', Object_ID('Directory.Tickets')),
('20', N'Бронируется', Object_ID('Directory.Tickets')),
('30', N'Забронирован', Object_ID('Directory.Tickets')),
('40', N'Оплачен', Object_ID('Directory.Tickets')),
('50', N'Возвращен владельцу (не реализованы)', Object_ID('Directory.Tickets')),
('51', N'Возвращен клиентом (после оплаты)', Object_ID('Directory.Tickets')),
('60', N'Удален', Object_ID('Directory.Tickets')),
('10', N'Забронирован', Object_ID('Purchasing.Orders')),
('20', N'Подтвержден', Object_ID('Purchasing.Orders')),
('30', N'Оплачен', Object_ID('Purchasing.Orders')),
('40', N'Отменен подтвержденный заказ', Object_ID('Purchasing.Orders')),
('41', N'Отменен оплаченный заказ', Object_ID('Purchasing.Orders'))
/*************************************************************************************************************/

--10. Билеты
DECLARE @price DECIMAL(18,3), @evt_id INT
DECLARE @events_time_t TABLE(event_time_id INT, [start_date] datetime, hall_id INT)
INSERT INTO @events_time_t
(event_time_id, [start_date], hall_id)
SELECT 
id, [start_date], hall_id
FROM Directory.Events_time

WHILE(SELECT COUNT(*) FROM @events_time_t) > 0
BEGIN
	SELECT @evt_id = event_time_id FROM @events_time_t
	SET @price = FLOOR(RAND()*(4000-200)+200)

	INSERT INTO Directory.Tickets
	(event_time_id, place_id, price, input_date, status_id)
	SELECT
	event_time_id, p.id, @price, DATEADD(DAY, -30, et.start_date), 36
	FROM @events_time_t et
	INNER JOIN Directory.Places p ON p.hall_id = et.hall_id
	WHERE event_time_id =  @evt_id
	
	DELETE FROM @events_time_t WHERE event_time_id = @evt_id
END
/*************************************************************************************************************/

--11. Клиенты
DECLARE @id INT = 1
DECLARE @info NVARCHAR(100)
WHILE(@id <= 100)
BEGIN
   SET @info = '{ "Name": "Name' + CAST(@id AS NVARCHAR) + '", "Email": "email' + CAST(@id AS NVARCHAR) + '@mail.ru" }'
   INSERT INTO People.Clients
   (info)
   VALUES(@info)
   SET @id = @id + 1
END
/*************************************************************************************************************/

--12. Заказы. Этот кусок кода запускала несколько раз, так как мне было необходимо сначала создать заказы с 1 билетом, потом с 2-мя и т.д.
DECLARE @eventTimes TABLE(id INT IDENTITY(1,1), eventTimeId INT, pointId INT, cntTick INT)
--выбрать события и точки продаж
INSERT INTO @eventTimes
(eventTimeId, pointId, cntTick)
SELECT et.id, s4et.point_id, COUNT(t.id)
FROM Directory.Tickets t
INNER JOIN Directory.Events_time et ON et.id = t.event_time_id
INNER JOIN [Directory].[Service_4_events_time] s4et ON s4et.event_time_id = et.id
WHERE et.start_date < '20230923' and t.status_id = 36
GROUP BY et.id, s4et.point_id
ORDER BY et.id
--
DECLARE @idRec INT, @eventTime INT, @point INT, @cntTick INT
DECLARE @ticketInOrder INT = 5
DECLARE @int INT = 0
DECLARE @tickId INT
DECLARE @guid UNIQUEIDENTIFIER
DECLARE @id INT,
        @transactionAm DECIMAL(18, 2),
		@transactionDate DATETIME,
		@has_tick INT
BEGIN TRAN
WHILE (SELECT COUNT(*) FROM @eventTimes) >0
BEGIN
    SELECT TOP 1 @idRec = id, @eventTime = eventTimeId, @point = pointId FROM @eventTimes

	SET @guid = NewId()
	SET @int = 1
	SET @has_tick = 0
	WHILE (@int <= @ticketInOrder)
	BEGIN
		SET @tickId = (SELECT TOP 1 id FROM Directory.Tickets WHERE event_time_id = @eventTime AND status_id = 36)

		IF(@tickId IS NOT NULL)
		BEGIN
			EXEC [dbo].[PutTicketToCart] @guid, @tickId, @point
			SET @has_tick = 1
		END

		SET @int = @int + 1
	END
	IF(@has_tick = 1)
	BEGIN
		EXEC [dbo].[CreateOrder] @guid, @id = @id OUTPUT
		EXEC [dbo].[ConfirmOrder] @id
		SELECT @transactionAm = amount + ISNULL(service_fee_price, 0) FROM Purchasing.Orders WHERE id = @id
		SET @transactionDate = GetDate()
		EXEC [dbo].[PaymentOrder] @id, @transactionAm, @transactionDate, '123456789521', '666666666666'
	END
	DELETE FROM @eventTimes WHERE id = @idRec
END
COMMIT TRAN
--ROLLBACK TRAN
/*************************************************************************************************************/

