-- إنشاء قاعدة البيانات
CREATE DATABASE PlayWatch;

USE PlayWatch;

-- الجدول 1: المستخدمين (Users)
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name_ar NVARCHAR(100),
    full_name_en VARCHAR(100),
    phone VARCHAR(20),
    country VARCHAR(50) DEFAULT 'Egypt',
    city VARCHAR(50),
    birth_date DATE,
    registration_date DATETIME DEFAULT GETDATE(),
    subscription_type VARCHAR(20) DEFAULT 'Free',
    is_active BIT DEFAULT 1,
    total_watch_time INT DEFAULT 0
);

-- الجدول 2: الملفات الشخصية (Profiles)
CREATE TABLE Profiles (
    profile_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    profile_name VARCHAR(50) NOT NULL,
    avatar_url VARCHAR(255),
    language VARCHAR(20) DEFAULT 'Arabic',
    maturity_level VARCHAR(10) DEFAULT 'PG',
    is_kids_profile BIT DEFAULT 0,
    theme_color VARCHAR(20) DEFAULT 'Dark',
    created_date DATETIME DEFAULT GETDATE()
);

-- الجدول 3: المحتوى (Content)
CREATE TABLE Content (
    content_id INT PRIMARY KEY IDENTITY(1,1),
    title_ar NVARCHAR(200),
    title_en VARCHAR(200),
    description_ar NVARCHAR(MAX),
    description_en VARCHAR(MAX),
    release_year INT,
    duration_minutes INT,
    content_type VARCHAR(20), -- 'Movie', 'Series', 'Documentary', 'Show'
    genre VARCHAR(50),
    language VARCHAR(50),
    director_ar NVARCHAR(100),
    director_en VARCHAR(100),
    country VARCHAR(50),
    rating DECIMAL(3,1),
    imdb_id VARCHAR(20),
    added_date DATETIME DEFAULT GETDATE(),
    is_available BIT DEFAULT 1,
    views_count INT DEFAULT 0
);

-- الجدول 4: الحلقات (Episodes)
CREATE TABLE Episodes (
    episode_id INT PRIMARY KEY IDENTITY(1,1),
    series_id INT FOREIGN KEY REFERENCES Content(content_id),
    season_number INT,
    episode_number INT,
    title_ar NVARCHAR(200),
    title_en VARCHAR(200),
    duration_minutes INT,
    air_date DATE,
    views_count INT DEFAULT 0
);

-- الجدول 5: المشاهدة (WatchHistory)
CREATE TABLE WatchHistory (
    watch_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    content_id INT FOREIGN KEY REFERENCES Content(content_id),
    episode_id INT FOREIGN KEY REFERENCES Episodes(episode_id),
    profile_id INT FOREIGN KEY REFERENCES Profiles(profile_id),
    start_time DATETIME DEFAULT GETDATE(),
    end_time DATETIME,
    watched_minutes INT,
    completion_percentage DECIMAL(5,2),
    device_type VARCHAR(30),
    quality VARCHAR(10)
);

-- الجدول 6: التقييمات (Ratings)
CREATE TABLE Ratings (
    rating_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    content_id INT FOREIGN KEY REFERENCES Content(content_id),
    rating_value INT CHECK (rating_value BETWEEN 1 AND 10),
    review_text NVARCHAR(MAX),
    review_date DATETIME DEFAULT GETDATE(),
    is_helpful INT DEFAULT 0
);

-- الجدول 7: القوائم (Playlists)
CREATE TABLE Playlists (
    playlist_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    playlist_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    is_public BIT DEFAULT 0,
    created_date DATETIME DEFAULT GETDATE(),
    item_count INT DEFAULT 0
);

-- الجدول 8: عناصر القوائم (PlaylistItems)
CREATE TABLE PlaylistItems (
    item_id INT PRIMARY KEY IDENTITY(1,1),
    playlist_id INT FOREIGN KEY REFERENCES Playlists(playlist_id),
    content_id INT FOREIGN KEY REFERENCES Content(content_id),
    episode_id INT FOREIGN KEY REFERENCES Episodes(episode_id),
    added_date DATETIME DEFAULT GETDATE(),
    watch_order INT
);

-- الجدول 9: الممثلين (Actors)
CREATE TABLE Actors (
    actor_id INT PRIMARY KEY IDENTITY(1,1),
    name_ar NVARCHAR(100),
    name_en VARCHAR(100),
    nationality VARCHAR(50),
    birth_date DATE,
    biography NVARCHAR(MAX)
);

-- الجدول 10: بطولة الممثلين (ContentActors)
CREATE TABLE ContentActors (
    content_id INT FOREIGN KEY REFERENCES Content(content_id),
    actor_id INT FOREIGN KEY REFERENCES Actors(actor_id),
    role_name NVARCHAR(100),
    is_lead_role BIT DEFAULT 0,
    PRIMARY KEY (content_id, actor_id)
);
-- إدخال بيانات المستخدمين 
INSERT INTO Users (username, password_hash, email, full_name_ar, full_name_en, phone, city, birth_date, subscription_type)
VALUES
('ahmed_ali', 'hash123', 'ahmed.ali@email.com', N'أحمد علي محمد', 'Ahmed Ali Mohamed', '+201012345678', 'Cairo', '1990-05-15', 'Premium'),
('sara_mahmoud', 'hash456', 'sara.mahmoud@email.com', N'سارة محمود حسن', 'Sara Mahmoud Hassan', '+201112345679', 'Alexandria', '1992-08-22', 'Premium'),
('mohamed_ibrahim', 'hash789', 'mohamed.ib@email.com', N'محمد إبراهيم سعيد', 'Mohamed Ibrahim Said', '+201212345680', 'Giza', '1985-11-30', 'Standard'),
('fatma_ahmed', 'hash101', 'fatma.ahmed@email.com', N'فاطمة أحمد خالد', 'Fatma Ahmed Khaled', '+201312345681', 'Luxor', '1995-03-10', 'Free'),
('omar_hassan', 'hash102', 'omar.hassan@email.com', N'عمر حسن علي', 'Omar Hassan Ali', '+201412345682', 'Aswan', '1988-07-18', 'Premium'),
('nour_elsayed', 'hash103', 'nour.elsayed@email.com', N'نور السيد محمد', 'Nour ElSayed Mohamed', '+201512345683', 'Port Said', '1993-12-05', 'Standard'),
('hala_samir', 'hash104', 'hala.samir@email.com', N'هالة سمير فؤاد', 'Hala Samir Fouad', '+201612345684', 'Mansoura', '1991-09-14', 'Premium'),
('khaled_farouk', 'hash105', 'khaled.farouk@email.com', N'خالد فاروق عبدالله', 'Khaled Farouk Abdullah', '+201712345685', 'Ismailia', '1987-04-25', 'Free'),
('rana_ashraf', 'hash106', 'rana.ashraf@email.com', N'رنا أشرف محسن', 'Rana Ashraf Mohsen', '+201812345686', 'Tanta', '1994-06-30', 'Premium'),
('tamer_hesham', 'hash107', 'tamer.hesham@email.com', N'تامر هشام ناصر', 'Tamer Hisham Nasser', '+201912345687', 'Suez', '1989-02-12', 'Standard');

-- إدخال بيانات الملفات الشخصية
INSERT INTO Profiles (user_id, profile_name, language, maturity_level, is_kids_profile)
VALUES
(1, 'Ahmed', 'Arabic', 'PG-13', 0),
(1, 'Kids', 'Arabic', 'G', 1),
(2, 'Sara', 'Arabic', 'PG-13', 0),
(3, 'Mohamed', 'English', 'R', 0),
(4, 'Fatma', 'Arabic', 'PG', 0),
(5, 'Omar', 'Arabic', 'PG-13', 0),
(6, 'Nour', 'Arabic', 'PG', 0),
(7, 'Hala', 'English', 'PG-13', 0),
(8, 'Khaled', 'Arabic', 'R', 0),
(9, 'Rana', 'Arabic', 'PG', 0),
(10, 'Tamer', 'English', 'PG-13', 0);

-- إدخال محتوى عربي ومصري
INSERT INTO Content (title_ar, title_en, description_ar, description_en, release_year, duration_minutes, content_type, genre, language, director_ar, director_en, country, rating)
VALUES
(N'الرحايا', 'Al-Rahaya', N'فيلم درامي مصري يحكي قصة عائلة تعيش في الصعيد', 'Egyptian drama film about a family living in Upper Egypt', 2020, 130, 'Movie', 'Drama', 'Arabic', N'مصطفى أبو سيف', 'Mostafa Abu Seif', 'Egypt', 8.2),
(N'النهاية', 'The End', N'مسلسل تشويق وإثارة مصري', 'Egyptian thriller series', 2021, 45, 'Series', 'Thriller', 'Arabic', N'محمد ياسين', 'Mohamed Yassin', 'Egypt', 8.5),
(N'أبناء رفاعة', 'Sons of Rifaah', N'مسلسل تاريخي مصري عن عصر محمد علي', 'Historical Egyptian series about Muhammad Ali era', 2019, 50, 'Series', 'Historical', 'Arabic', N'إبراهيم الشقنقيري', 'Ibrahim ElShaknqiry', 'Egypt', 9.1),
(N'اللي اختشوا ماتوا', 'Those Who Shy Away Die', N'فيلم كوميدي مصري كلاسيكي', 'Classic Egyptian comedy film', 2016, 115, 'Movie', 'Comedy', 'Arabic', N'سعيد حامد', 'Saeed Hamed', 'Egypt', 8.7),
(N'المعلم', 'The Teacher', N'فيلم درامي عن معلم في قرية نائية', 'Drama film about a teacher in a remote village', 2022, 120, 'Movie', 'Drama', 'Arabic', N'خالد يوسف', 'Khaled Youssef', 'Egypt', 7.9),
(N'صراع العروش', 'Game of Thrones', N'مسلسل خيال ملحمي', 'Epic fantasy series', 2011, 60, 'Series', 'Fantasy', 'English', N'ديفيد بينيوف', 'David Benioff', 'USA', 9.3),
(N'كليوباترا', 'Cleopatra', N'فيلم وثائقي عن حياة كليوباترا', 'Documentary about Cleopatra life', 2021, 90, 'Documentary', 'Documentary', 'Arabic', N'منى أبو النصر', 'Mona Abou ElNasr', 'Egypt', 8.0),
(N'العميل', 'The Agent', N'مسلسل تشويق وجاسوسية', 'Spy thriller series', 2020, 45, 'Series', 'Action', 'Arabic', N'طارق العريان', 'Tarek ElErian', 'Egypt', 8.4),
(N'أحلام كبيرة', 'Big Dreams', N'فيلم درامي عن طموحات الشباب', 'Drama about youth ambitions', 2023, 105, 'Movie', 'Drama', 'Arabic', N'نادين خان', 'Nadine Khan', 'Egypt', 7.8),
(N'رمضان مبروك', 'Ramadan Mubarak', N'مسلسل كوميدي رمضاني', 'Ramadan comedy series', 2022, 40, 'Series', 'Comedy', 'Arabic', N'أحمد الجندي', 'Ahmed ElGendy', 'Egypt', 8.6);

-- إدخال حلقات للمسلسلات
INSERT INTO Episodes (series_id, season_number, episode_number, title_ar, title_en, duration_minutes, air_date)
VALUES
(2, 1, 1, N'الحلقة الأولى', 'Episode 1', 45, '2021-01-01'),
(2, 1, 2, N'الحلقة الثانية', 'Episode 2', 45, '2021-01-08'),
(2, 1, 3, N'الحلقة الثالثة', 'Episode 3', 45, '2021-01-15'),
(3, 1, 1, N'بداية القصة', 'Beginning of the Story', 50, '2019-01-01'),
(3, 1, 2, N'الصعود', 'The Rise', 50, '2019-01-08'),
(6, 1, 1, 'Winter Is Coming', 'Winter Is Coming', 62, '2011-04-17'),
(6, 1, 2, 'The Kingsroad', 'The Kingsroad', 56, '2011-04-24'),
(8, 1, 1, N'البداية', 'The Beginning', 45, '2020-03-01'),
(8, 1, 2, N'التحقيق', 'The Investigation', 45, '2020-03-08'),
(10, 1, 1, N'ليلة القدر', 'Laylat al-Qadr', 40, '2022-04-02');

-- إدخال بيانات المشاهدة
INSERT INTO WatchHistory (user_id, content_id, episode_id, profile_id, watched_minutes, completion_percentage, device_type, quality)
VALUES
(1, 1, NULL, 1, 130, 100, 'Smart TV', '4K'),
(1, 2, 1, 1, 45, 100, 'Mobile', 'HD'),
(1, 2, 2, 1, 45, 80, 'Mobile', 'HD'),
(2, 3, 1, 3, 50, 100, 'Tablet', 'Full HD'),
(2, 6, 6, 3, 62, 100, 'Laptop', '4K'),
(3, 4, NULL, 4, 115, 100, 'Smart TV', 'HD'),
(4, 5, NULL, 5, 60, 50, 'Mobile', 'SD'),
(5, 6, 7, 6, 56, 100, 'Smart TV', '4K'),
(6, 7, NULL, 7, 90, 100, 'Laptop', 'Full HD'),
(7, 8, 8, 8, 45, 100, 'Tablet', 'HD'),
(8, 9, NULL, 9, 105, 75, 'Mobile', 'HD'),
(9, 10, 10, 10, 40, 100, 'Smart TV', '4K'),
(10, 1, NULL, 11, 130, 100, 'Laptop', 'Full HD');

-- إدخال تقييمات
INSERT INTO Ratings (user_id, content_id, rating_value, review_text)
VALUES
(1, 1, 9, N'فيلم رائع وملحمي!'),
(1, 2, 8, N'مسلسل مشوق ولكن النهاية كانت متوقعة'),
(2, 3, 10, N'أفضل مسلسل تاريخي شاهدته على الإطلاق'),
(3, 4, 7, N'كوميدي خفيف ولكن به بعض المشاهد المملة'),
(4, 5, 6, N'قصة جيدة ولكن التنفيذ كان متوسط'),
(5, 6, 10, N'تحفة فنية لا تنسى'),
(6, 7, 8, N'وثائقي ممتع وغني بالمعلومات'),
(7, 8, 9, N'تشويق من البداية للنهاية'),
(8, 9, 7, N'جيد ولكن يمكن أن يكون أفضل'),
(9, 10, 9, N'مسلسل رمضاني رائع وهادف');

-- إدخال قوائم تشغيل
INSERT INTO Playlists (user_id, playlist_name, description, is_public, item_count)
VALUES
(1, N'الأفلام المصرية', N'مجموعة من أفضل الأفلام المصرية', 1, 3),
(2, N'المسلسلات التاريخية', N'مسلسلات تاريخية من مختلف العصور', 1, 2),
(3, N'الأفلام الكوميدية', N'للضحك والترفيه', 0, 2),
(4, N'الدراما العربية', N'أعمال درامية عربية مؤثرة', 1, 2),
(5, N'الأفلام الوثائقية', N'وثائقيات شيقة ومفيدة', 1, 1);

-- إدخال عناصر القوائم
INSERT INTO PlaylistItems (playlist_id, content_id, episode_id, watch_order)
VALUES
(1, 1, NULL, 1),
(1, 4, NULL, 2),
(1, 5, NULL, 3),
(2, 3, NULL, 1),
(2, 6, NULL, 2),
(3, 4, NULL, 1),
(3, 10, NULL, 2),
(4, 1, NULL, 1),
(4, 9, NULL, 2),
(5, 7, NULL, 1);

-- إدخال بيانات الممثلين
INSERT INTO Actors (name_ar, name_en, nationality, birth_date)
VALUES
(N'محمد رمضان', 'Mohamed Ramadan', 'Egyptian', '1988-05-23'),
(N'ياسمين صبري', 'Yasmin Sabri', 'Egyptian', '1989-01-21'),
(N'عمرو يوسف', 'Amr Youssef', 'Egyptian', '1980-07-01'),
(N'منة شلبي', 'Mona Shalaby', 'Egyptian', '1978-02-12'),
(N'أحمد حلمي', 'Ahmed Helmy', 'Egyptian', '1969-11-18'),
(N'دنيا سمير غانم', 'Donia Samir Ghanem', 'Egyptian', '1985-01-01'),
(N'خالد الصاوي', 'Khaled ElSawy', 'Egyptian', '1961-08-30'),
(N'نيللي كريم', 'Nelly Karim', 'Egyptian', '1974-12-18');

-- إدخال بطولة الممثلين
INSERT INTO ContentActors (content_id, actor_id, role_name, is_lead_role)
VALUES
(1, 1, N'الشيخ أحمد', 1),
(1, 2, N'فاطمة', 1),
(2, 3, N'المحقق', 1),
(2, 4, N'الضحية', 1),
(3, 5, N'محمد علي', 1),
(4, 6, N'علي', 1),
(4, 7, N'والده', 0),
(5, 8, N'المعلمة', 1);
-- 1. SELECT مع شروط AND, OR
SELECT * FROM Users 
WHERE country = 'Egypt' 
AND subscription_type IN ('Premium', 'Standard')
AND (city LIKE '%Cairo%' OR city LIKE '%Alexandria%');

-- 2. SELECT مع LIKE للبحث
SELECT full_name_ar, email, city FROM Users
WHERE full_name_ar LIKE N'%أحمد%' 
OR full_name_en LIKE '%Ahmed%';

-- 3. SELECT مع BETWEEN للتواريخ
SELECT full_name_ar, birth_date FROM Users
WHERE birth_date BETWEEN '1990-01-01' AND '1995-12-31';

-- 4. SELECT مع NOT IN
SELECT * FROM Content 
WHERE content_type NOT IN ('Documentary', 'Show')
AND country = 'Egypt';

-- 5. SELECT مع شروط مركبة
SELECT title_ar, rating, release_year FROM Content
WHERE (rating >= 8.0 OR release_year >= 2020)
AND is_available = 1
AND genre NOT IN ('Comedy');

-- 6. TOP مع ORDER BY تصاعدي وتنازلي
SELECT TOP 5 * FROM Content 
ORDER BY rating DESC, release_year DESC;

-- 7. أفضل 10 مستخدمين حسب وقت المشاهدة
SELECT TOP 10 u.full_name_ar, u.city, u.total_watch_time
FROM Users u
WHERE u.is_active = 1
ORDER BY u.total_watch_time DESC;

-- 8. أحدث 7 محتويات مضافة
SELECT TOP 7 title_ar, content_type, added_date 
FROM Content
ORDER BY added_date DESC;

-- 9. المسلسلات ذات أعلى تقييم (TOP 3)
SELECT TOP 3 title_ar, rating, genre
FROM Content
WHERE content_type = 'Series'
ORDER BY rating DESC;

-- 10. المستخدمين الأكبر سناً (TOP 5)
SELECT TOP 5 full_name_ar, birth_date, 
DATEDIFF(YEAR, birth_date, GETDATE()) as age
FROM Users
ORDER BY birth_date ASC;

-- 11. INNER JOIN بين Users و Profiles
SELECT u.full_name_ar, u.email, p.profile_name, p.language
FROM Users u
INNER JOIN Profiles p ON u.user_id = p.user_id
WHERE p.is_kids_profile = 0;

-- 12. LEFT JOIN لرؤية كل المستخدمين وملفاتهم الشخصية
SELECT u.full_name_ar, COUNT(p.profile_id) as profile_count
FROM Users u
LEFT JOIN Profiles p ON u.user_id = p.user_id
GROUP BY u.full_name_ar;

-- 13. JOIN متعدد الجداول
SELECT 
    u.full_name_ar,
    c.title_ar,
    wh.watched_minutes,
    wh.completion_percentage,
    r.rating_value
FROM WatchHistory wh
JOIN Users u ON wh.user_id = u.user_id
JOIN Content c ON wh.content_id = c.content_id
LEFT JOIN Ratings r ON u.user_id = r.user_id AND c.content_id = r.content_id
WHERE wh.completion_percentage >= 80;

-- 14. JOIN مع Episodes
SELECT 
    c.title_ar as series_name,
    e.season_number,
    e.episode_number,
    e.title_ar as episode_title,
    e.views_count
FROM Content c
JOIN Episodes e ON c.content_id = e.series_id
WHERE c.content_type = 'Series'
ORDER BY c.title_ar, e.season_number, e.episode_number;

-- 15. JOIN مع Playlists
SELECT 
    u.full_name_ar,
    pl.playlist_name,
    COUNT(pi.item_id) as item_count
FROM Users u
JOIN Playlists pl ON u.user_id = pl.user_id
LEFT JOIN PlaylistItems pi ON pl.playlist_id = pi.playlist_id
WHERE pl.is_public = 1
GROUP BY u.full_name_ar, pl.playlist_name;