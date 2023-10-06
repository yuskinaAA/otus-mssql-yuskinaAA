/*��������� ������, ��������� ��������������� �� �������*/

--1. ��������� � ������

DECLARE @nameO NVARCHAR(100),
		@nameD NVARCHAR(100),
        @num INT = 0,
		@is_deleted BIT = 0,
		@seq_numO INT,
		@seq_numD INT

/*���������*/
/*************************************************************************************************************/
WHILE(@num < 11)
BEGIN
   SET @seq_numO = NEXT VALUE FOR [dbo].[owners_sequence]
   SET @nameO = N'�� �������� ' + CAST(@seq_numO AS NVARCHAR)
   
   IF ((@num % 3) = 0)
      SET @is_deleted = 1
   ELSE
	  SET @is_deleted = 0

   /*������� ����������*/ 
   INSERT INTO [Directory].[Owners]
   ([name], [is_deleted], [seq_number])
   VALUES
   (@nameO, @is_deleted, @seq_numO)

   SET @num = @num + 1
END
/*������*/
/*************************************************************************************************************/
SET @num = 0
WHILE(@num < 31)
BEGIN
   SET @seq_numD = NEXT VALUE FOR [dbo].[dealers_sequence]
   SET @nameD = N'�� ����� ' + CAST(@seq_numD AS NVARCHAR)

   IF ((@num % 3) = 0)
      SET @is_deleted = 1
   ELSE
	  SET @is_deleted = 0
   /*������� �������*/
   INSERT INTO [Directory].[Dealers]
   ([name], [seq_number], [is_deleted])
   VALUES
   (@nameD, @seq_numD, @is_deleted)
	
   SET @num = @num + 1	
END
/*************************************************************************************************************/

--2. ������� �������� ����� �������� � �����������
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

   WHILE(@i < 3) --�� 3 ������ �� ���������
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


--3. ����� ������

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

	SET @cnt_points = FLOOR(RAND()*(5))+1; --��������� ����� ����� ������
	WHILE(@cnt_points > 0)
	BEGIN
		SET @point_n = N'����� ������_' + CAST(@d_id AS NVARCHAR) + '_' + CAST(@cnt_points AS NVARCHAR)

		INSERT INTO [Directory].[Points]
		([name], [dealer_id])
		VALUES
		(@point_n, @d_id)

	    SET @cnt_points = @cnt_points - 1
	END

	DELETE FROM @d_T WHERE id_dealer = @d_id
	
END
/*************************************************************************************************************/

--4. �������� + ����
DECLARE @venues table (id INT, name NVARCHAR(100))
INSERT INTO @venues
(id, name)
VALUES
(50000,N' �������� ����� ��������. ���������. �������'),
(50001,N' ����������� �������� ����������-������ � 26'),
(50002,N' ������������ ��������� ���������� - ������ �16'),
(50003,N' ������������ �������� ����������- ������ � 6'),
(50004,N' ���� ����� ������� ������ ��������'),
(50005,N' �� �.�. �������'),
(50006,N' ��������� ����������-������ � 2'),
(50007,N' ��� ������ ������ �.� �����������'),
(50008,N' ���� ������'),
(50009,N' ����������� ������� ����������'),
(50010,N' ������� ���'),
(50011,N' ���� "���� ����" (���)'),
(50012,N' ��������� ������ �������� �. ������'),
(50013,N' ���� ��� ������'),
(50014,N' ���� ������'),
(50015,N' ��� �������� �. ������'),
(50016,N' ����������� �������� ����������'),
(50017,N' ����-���������� �������� ����������'),
(50018,N' ���������� ������� ����������'),
(50019,N' ����������� ���'),
(50020,N' ����������� �������� ����������'),
(50021,N' ����������� ����������'),
(50022,N' ����������� �������� ����������-������ �7'),
(50023,N' ��������� ��� �������� �. �������'),
(50024,N' �����������-������������ ����� �.�. �����������'),
(50025,N' �� ����������'),
(50026,N' ����������� ������������ �������'),
(50027,N' ����������������������� ��� ��������'),
(50028,N' ��� �������� ���������� ������ ���� �������'),
(50029,N' ����-��������� ����������'),
(50030,N' ����������� �������� ����������-����'),
(50031,N' ��� �� ������������ ����� ��������1� �. ��������'),
(50032,N' ����������� ���������� ���'),
(50033,N' ������ �������� �. �������'),
(50034,N' ��������� ������ ��������'),
(50035,N' ���� ���� ����������� �������������� ������'),
(50036,N' ��� �������� �.�. ��������'),
(50037,N' ���� ������������� ���'),
(50038,N' ������� ������� ������ � ����� ����������'),
(50039,N' ������� �������������� ����� �1 �. ��������'),
(50040,N' ���������� ��� ����������� ��������� ���� ��������'),
(50041,N' ��� �������� ��������� ��������� ������'),
(50042,N' ���������� ����� ��������'),
(50043,N' ������ ���� ��������� ��� ��������� �. �����������'),
(50044,N' ���� "���������� �������� ��� ��������'),
(50045,N' ���� "�������� ��� ��������" �. �. ���� ���'),
(50046,N' ���� ������ ���������� � ������ �. ���������'),
(50047,N' ����� ����������� �������� �. ��������'),
(50048,N' ������� "���������"'),
(50049,N' ���� "��� �������� �. �. �����"'),
(50050,N' ���� ��������-��������������� ��λ'),
(50051,N' ��� "�������� ��� ��������" ���������� ������'),
(50052,N' ���� "���������� �����. �������� ����������"'),
(50053,N' ��� "���" �������'),
(50054,N' ����� �� ��� ��.�.�.����������'),
(50055,N' ��� ���� �������� ��������� ��������� ��������'),
(50056,N' ����������-������ � 3 �. ��������'),
(50057,N' ��� �� ���ֻ �������������� ���.'),
(50058,N' ������� ������'),
(50059,N' ������ ��� ���� "��� �������� �.�������������"'),
(50060,N' ������������ �����-�������� �. �. �������'),
(50061,N' ���� ��� �. ����'),
(50062,N' �� ���� ���������'),
(50063,N' ��� "�� �. �����"'),
(50064,N' ������������� ������'),
(50065,N' ��� �������� ���� ������'),
(50066,N' ������������ ������, �. �����-���������'),
(50067,N' ��� ������������� �������� ����� ��.�.�. ��������'),
(50068,N' �� ��. ���������'),
(50069,N' ������ "�������"'),
(50070,N' ���� ��������'),
(50071,N' �������������� ��� ������������ ������'),
(50072,N' ��� ������ - ���������� �����'),
(50073,N' ��������������� �������� ����'),
(50074,N' ����-������ "��������"  �� "������ �����"'),
(50075,N' ������� �.�.��������'),
(50076,N' ���� ��������� �. ������'),
(50077,N' ����-������ "��������" �. ������'),
(50078,N' ���� "RED"'),
(50079,N' ���������� ������ ������� (���)'),
(50080,N' ����� ��������'),
(50081,N' ��������������  �������� "��������"'),
(50082,N' ���������-�������� ��������� "���������"'),
(50083,N' ���������-��������������� �������� "������"'),
(50084,N' ���� � �5�--- �����-���������'),
(50085,N' ��������--- �����-���������'),
(50086,N' ��������������� ���� ��. �. ��������'),
(50087,N' ������������� �������'),
(50088,N' ���������� ��������������� ����������'),
(50089,N' ����������� ������'),
(50090,N' ������� �������� "� ������ � ������"'),
(50091,N' �� ����� ����������'),
(50092,N' ����������� ����� ����� ���'),
(50093,N' �����������'),
(50094,N' ����� �� ������������ (��) ���.�����'),
(50095,N' ����� ����(����.���.���)'),
(50096,N' ������ - ����/�����'),
(50097,N' ������ ���� ����� 44'),
(50098,N' ���������� �����'),
(50099,N' ���� ����������')

UPDATE @venues SET name = LTRIM(RTRIM(name))

DECLARE @halls table (venue_id INT, name NVARCHAR(100))
INSERT INTO @halls
(venue_id, name)
VALUES
(50000,N'�������� ���'),
(50001,N'�������� ���'),
(50002,N'�������� ���'),
(50003,N'�������� ���'),
(50004,N'��� 1'),
(50004,N'��� 2'),
(50004,N'��� 3'),
(50004,N'��� 4'),
(50004,N'��� 5'),
(50004,N'��� 6'),
(50004,N'��� 7'),
(50004,N'��� 8'),
(50004,N'��� 9'),
(50004,N'��� 10'),
(50005,N'�������� ���'),
(50006,N'�������� ���'),
(50007,N'�������� ���'),
(50008,N'�������� ���'),
(50009,N'��������'),
(50010,N'�������� ���'),
(50010,N'�������� ��� � �������'),
(50011,N'���������� ���'),
(50012,N'���������� ���'),
(50013,N'���������� ���'),
(50014,N'�������� ���'),
(50015,N'��������'),
(50016,N'��������'),
(50017,N'��������'),
(50018,N'��������'),
(50019,N'��������'),
(50020,N'�������� ���'),
(50021,N'��������'),
(50022,N'�������� ���'),
(50023,N'�������� ��� �� ������'),
(50023,N'�������� ��� �������'),
(50024,N'��������'),
(50025,N'��������'),
(50026,N'��������'),
(50027,N'�������� ���'),
(50028,N'��������'),
(50029,N'��������'),
(50030,N'��������'),
(50031,N'�������� ���'),
(50032,N'����� ���'),
(50033,N'�������� ���'),
(50034,N'�������� ���'),
(50035,N'�������� ���'),
(50036,N'��������'),
(50037,N'��� ����� �.���������'),
(50037,N'��� ����� �.������'),
(50038,N'��������'),
(50039,N'��������'),
(50040,N'��������'),
(50041,N'��������'),
(50042,N'��������'),
(50043,N'��������'),
(50044,N'�������� ���'),
(50045,N'��������'),
(50046,N'�������� ���'),
(50047,N'��������'),
(50048,N'��������'),
(50049,N'��������'),
(50050,N'��������'),
(50051,N'��������'),
(50051,N'�������������� ���'),
(50051,N'���������-����������� ���'),
(50051,N'����'),
(50051,N'������� 13'),
(50052,N'�������� ���'),
(50052,N'�������� ��� (��������)'),
(50052,N'���������'),
(50052,N'�������� ���  �����-����'),
(50052,N'��������� ���'),
(50052,N'��� "���������� ��������� - 2" ������ ������ ��������'),
(50052,N'��� "���������� ��������� - 2" �����'),
(50052,N'��� ������������ �������� ����������'),
(50052,N'��� ����������� ������ ������ UP�'),
(50052,N'��� ���������� ����������'),
(50053,N'��������'),
(50054,N'�������� ���'),
(50055,N'��������'),
(50056,N'��������� ���'),
(50057,N'��������'),
(50058,N'���������� ��������'),
(50058,N'����� (������������) ��� �������� ��������'),
(50058,N'����� (������������) ��� �������� �������� (7 �����)'),
(50058,N'����� (������������) ��� �������� ��������'),
(50059,N'��������'),
(50060,N'��������� ��������'),
(50062,N'��������'),
(50063,N'�������� ���'),
(50064,N'������� ���'),
(50065,N'��������� ��������'),
(50066,N'�������� ���'),
(50067,N'�������� ���'),
(50067,N'��� ���'),
(50067,N'������� ���'),
(50067,N'����������� ���'),
(50067,N'��� ������'),
(50067,N'��� ��������� �������'),
(50067,N'����������� ���'),
(50068,N'�������� ��� (������)'),
(50069,N'�������� ���'),
(50070,N'��� � �������'),
(50070,N'��� � �������� ��������'),
(50071,N'�������� ���'),
(50072,N'����-������'),
(50072,N'��� �����. ������������ ��������� ����������.'),
(50072,N'����������� �����'),
(50072,N'���������� �����'),
(50072,N'����������� ��������'),
(50072,N'��� �����. ������������ ��������� ���������� 1.'),
(50072,N'�������� �� ��� �����'),
(50072,N'�������������'),
(50072,N'���. ���. ����������� �����.'),
(50072,N'��� �����. ���������� ������������.'),
(50073,N'�������� ���'),
(50074,N'����� ���'),
(50075,N'������� �.�.��������'),
(50075,N'�������� ���'),
(50076,N'��������'),
(50077,N'�������� ���'),
(50078,N'�������� ���'),
(50079,N'������� ���'),
(50079,N'���� ��� �����'),
(50079,N'������� ��� ���'),
(50080,N'�������� ���'),
(50080,N'�������� ���'),
(50080,N'�������� ���'),
(50080,N'������� ������'),
(50080,N'�������� ��� 2'),
(50081,N'��������'),
(50081,N'�������� ��� - �����'),
(50082,N'��������1'),
(50083,N'��������'),
(50083,N'�������� 1'),
(50083,N'������'),
(50086,N'�������� ���'),
(50087,N'���������-���'),
(50088,N'�������� ���'),
(50089,N'�������� ���'),
(50089,N'�������� ���'),
(50089,N'����� ���'),
(50090,N'�������� ���'),
(50091,N'��������'),
(50091,N'��������'),
(50091,N'�������'),
(50091,N'�������� ���'),
(50092,N'�������� ���'),
(50093,N'�������� ���'),
(50094,N'�������� ���'),
(50095,N'�������� ���'),
(50096,N'�������� ���'),
(50097,N'�������� ���'),
(50098,N'�������� ��� 2'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�������� ���'),
(50098,N'�����-���������, ���������� �����'),
(50098,N'�������� ���'),
(50098,N'�������� ��� (� �������)'),
(50099,N'�������� ���'),
(50099,N'�������� ���'),
(50099,N'�������� ���'),
(50099,N'�������� ���'),
(50099,N'������� �����')

DECLARE @id_venues INT
DECLARE @insert_id INT

/*����������� ���� � ���������*/
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

--5. ����� (�������)
DECLARE @sector_max INT = 3, /*������������ ��������� �������� ���������� ��������*/
        @sectors INT, @s INT 
DECLARE @row_number_max INT = 10, /*������������ ��������� �������� �����*/
		@row_numbers INT, @rn INT
DECLARE @place_number_max INT = 5, /*������������ ��������� �������� ���������� �������/������/�.�. � ����*/
        @place_numbers INT, @pn INT
DECLARE @id_h INT

DECLARE @halls_for_places TABLE (id INT)

INSERT INTO @halls_for_places
SELECT id FROM Directory.Halls

WHILE(SELECT COUNT(*) FROM @halls_for_places) > 0
BEGIN
	SELECT @id_h = id FROM @halls_for_places

	/*��������� ��������� ��������*/
	SET @sectors = FLOOR(RAND()*(@sector_max-1)+1);
	SET @row_numbers = FLOOR(RAND()*(@row_number_max-1)+1);
	SET @place_numbers = FLOOR(RAND()*(@place_number_max-1)+1);
	SET @s = 1
	/*��������� � ����������*/
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

--6. �����������
DECLARE @test_events  TABLE (name_event NVARCHAR(100))
INSERT INTO @test_events
VALUES
(N'�������� �.����������'),
(N'���� ����� ������'),
(N'��������: ���������. Pop-up �����.'),
(N'��������� �. �����. ���� ������ "��- �����".'),
(N'�������, ������������ ��������� �������'),
(N'��������� "������� ������� �������"'),
(N'��������� "���� ��-����������"'),
(N'���� ��������'),
(N'����������� ��� ���������� Test'),
(N'�������-����� ROGER WATERS - THE WALL'),
(N'Sun Say'),
(N'�����-��� � ���-���-���'),
(N'������: �������� ������'),
(N'������ �������� ������� 16+'),
(N'���������� � �����������'),
(N'������ � ������'),
(N'������� ��������'),
(N'��������'),
(N'������ � ������, ��� ���� � �����'),
(N'�����.��������.������.'),
(N'� ����� �����, ������! 0+'),
(N'���������� ����'),
(N'�������� ���������� ����������: �������� ���������'),
(N'������� �� �������� �����: ���, �����, ����, ����������'),
(N'�������� ��������� ��������� ���������-���������� ���������� ����� ����-����'),
(N'���������� ������'),
(N'���������� ��������'),
(N'������� ����� ����������� ������'),
(N'���� ���������� � ������!�'),
(N'����������� ��� �� �������, ��� ��� � ����!�'),
(N'������� ��������'),
(N'������� �������� ������ � �����'),
(N'������-����� "������ �������"'),
(N'�����-���� "������ ���������� �����"'),
(N'�������� �����������'),
(N'����� �����������'),
(N'������� �� ����������� ������'),
(N'�������� "��� ������. ������."'),
(N'��������������� ��������� � ����������'),
(N'����-���� ����������'),
(N'������-����� ���������� �����������'),
(N'���� �.�������� � �.�����'),
(N'����� ���������'),
(N'����������� � ����� ��� �����'),
(N'������ ����'),
(N'��������� ����  ���� ����'),
(N'���� � ������� �����������'),
(N'�������'),
(N'� ���� �������� ����� �������...'),
(N'���� ���������'),
(N'������� ������ �������'),
(N'�������� ����� � ������� �����������'),
(N'������'),
(N'���� �� ����� �������� �������'),
(N'��������� �� ����� / �����������'),
(N'������ ������� ������������'),
(N'�������� ������� �������� ������� � �� ����� ��������� ������� � ������� ������'),
(N'����-������� "Viva Musica!"'),
(N'����� ����, ���� �����/�Ich sehe Dich, ich kenne Dich�'),
(N'�������� ������� ������ ������. �������� � �������'),
(N'"������� ..17"'),
(N'������� ������� ���� � ������ ���. ����� � �����'),
(N'����������� ��������'),
(N'�������� � 555 / 0421 ���  2021�.'),
(N'�������� ������� � ������� ����. ���, ����, �����, �������'),
(N'������� ��� ������������ ��������: ���, ��������, �����, �����, ����������'),
(N'����� �������� ������ "����� ����������" (�. �����, �. ������, �.����������)'),
(N'� ���� ����?'),
(N'����, ��� ���� ����� ���'),
(N'������� �������� ������  ������ �� ����ջ'),
(N'������ � ����� �����'),
(N'�������� � 314 ����� 2021�.'),
(N'����� ������� ����. ������� � ���������� �� ������ ���������.�'),
(N'������� ���������� �����'),
(N'8 �����. ��������� ��� ����� � ���������'),
(N'�����-������������� ������� ����������'),
(N'�����������-����������� ��������� ������ �������'),
(N'"������ �.�. ����������� �����������..."'),
(N'���������� ������� ��������������� �������'),
(N'����������� ��� �� ���� �������, ��� ������ ����'),
(N'�����������-����������� �������� ������ �������� ����'),
(N'�������� ����������, ����������!�'),
(N'���������������� ��������� "������"'),
(N'�������� ������� "��������"'),
(N'����� ����'),
(N'LONE.����������� ������� �������+��� ����'),
(N'����� �������'),
(N'���� ����� "������ ��� �� ���������"'),
(N'���� � ����'),
(N'Zorge'),
(N'��������� �����'),
(N'"������,����� � �����"'),
(N'������ � ��������'),
(N'���� �������������'),
(N'� ����� � ��� ����'),
(N'�����, ����� ���� ������'),
(N'Ave Maria � ������ �������. ����� � �����. ������, �������, ����������, ����'),
(N'������� ���������� ����������� � ����������� ������.'),
(N'������������� ����������'),
(N'"�����. �������� �������"')

DECLARE @id_owner INT
DECLARE @owners_tb TABLE (id INT)
INSERT INTO @owners_tb (id) SELECT id FROM Directory.Owners
DECLARE @how_many_events_for_each_owner INT
DECLARE @cnt_events INT = 1
DECLARE @cnt_owners INT
DECLARE @dyn_sql NVARCHAR(2000)

SELECT @cnt_events = COUNT(*) FROM @test_events
SELECT @cnt_owners = COUNT(*) FROM @owners_tb
--��������� ������� ������� ��������� �����������
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

--7. �������
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
	SET @long_event = FLOOR(RAND()*(4))+1; --������������ �������
	SET @cntTimes = FLOOR(RAND()*(10))+1; --������� ��� ����� ���������
	SET @rand_hour = FLOOR(RAND()*(18-9)+9); --����� ������
	/*������� ����*/
	DELETE FROM @temp_halls
	INSERT INTO @temp_halls 
	SELECT TOP 2 id FROM Directory.Halls h
	WHERE NOT EXISTS(SELECT 1 FROM Directory.Events_time et WHERE et.hall_id =  h.id)

	SET @event_time_change = DATEADD(HOUR, @rand_hour, @event_time) --���� ������	
	WHILE(SELECT COUNT(*) FROM @temp_halls) > 0
	BEGIN

		SELECT @id_hall = id FROM @temp_halls
		SET @y = 1
		WHILE(@y < @cntTimes)
		BEGIN
		    SET @event_time_change = DATEADD(DAY, @y, @event_time_change) --���� ������
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

--7. ��������� ����
INSERT INTO Directory.Service_fee
(name, per_cent, [round])
VALUES
(N'0% ��� ��', 0, 0),
(N'2% CC, ���������� �� ������', 2, 0),
(N'2% CC, ���������� �� 1 �����', 2, 1),
(N'3% CC, ���������� �� ������', 3, 0),
(N'3% CC, ���������� �� 1 �����', 3, 1),
(N'5% CC, ���������� �� ������', 5, 0),
(N'5% CC, ���������� �� 1 �����', 5, 1),
(N'10% CC, ���������� �� ������', 10, 0),
(N'10% CC, ���������� �� 1 �����', 10, 1)

/*************************************************************************************************************/

--8. ��������� ���� ��� ������� � �����
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

--9. �������
INSERT INTO Dictionary.Statuses
(name, description, table_id)
VALUES
('10', N'��������', Object_ID('Directory.Tickets')),
('20', N'�����������', Object_ID('Directory.Tickets')),
('30', N'������������', Object_ID('Directory.Tickets')),
('40', N'�������', Object_ID('Directory.Tickets')),
('50', N'��������� ��������� (�� �����������)', Object_ID('Directory.Tickets')),
('51', N'��������� �������� (����� ������)', Object_ID('Directory.Tickets')),
('60', N'������', Object_ID('Directory.Tickets')),
('10', N'������������', Object_ID('Purchasing.Orders')),
('20', N'�����������', Object_ID('Purchasing.Orders')),
('30', N'�������', Object_ID('Purchasing.Orders')),
('40', N'������� �������������� �����', Object_ID('Purchasing.Orders')),
('41', N'������� ���������� �����', Object_ID('Purchasing.Orders'))
/*************************************************************************************************************/

--10. ������
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

--11. �������
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

--12. ������. ���� ����� ���� ��������� ��������� ���, ��� ��� ��� ���� ���������� ������� ������� ������ � 1 �������, ����� � 2-�� � �.�.
DECLARE @eventTimes TABLE(id INT IDENTITY(1,1), eventTimeId INT, pointId INT, cntTick INT)
--������� ������� � ����� ������
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

