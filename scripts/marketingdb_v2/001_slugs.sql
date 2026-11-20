-- marketingdb_v2 is a copy of marketingdb (createdb -T marketingdb) with
-- language-neutral values: Russian labels are replaced with snake_case slugs,
-- so the database serves students of every locale. Students turn slugs into
-- labels of their report language themselves (CASE in SQL or on a dashboard).
--
-- Run with psql --single-transaction: any error rolls the whole patch back.

UPDATE leads
SET closing_reason = m.slug
FROM (
    VALUES
    ('Успешная продажа', 'successful_sale'),
    ('Не реализовано', 'not_realized'),
    ('В работе', 'in_progress')
) AS m (label, slug)
WHERE leads.closing_reason = m.label;

-- РСЯ (Yandex Advertising Network) becomes display, ДОД (open day) becomes
-- open_day, ПК campaigns already carry base-* in utm_campaign.
UPDATE ya_ads
SET campaign_name = m.slug
FROM (
    VALUES
    ('Freemium / Поиск', 'freemium_search'),
    ('Freemium / РСЯ', 'freemium_display'),
    ('Бренд / Поиск', 'brand_search'),
    ('ДОД  F / РСЯ', 'open_day_frontend_display'),
    ('ДОД J / РСЯ', 'open_day_java_display'),
    ('ДОД PHP / РСЯ', 'open_day_php_display'),
    ('ДОД QA / РСЯ', 'open_day_qa_display'),
    ('ДОД Профориентация / РСЯ', 'open_day_career_guidance_display'),
    ('Интенсив ДОД P & J / РСЯ', 'open_day_intensive_python_java_display'),
    ('ПК / Retarget (smartbanner)', 'base_retarget_smartbanner'),
    ('ПК Base F / РСЯ', 'base_frontend_display'),
    ('ПК Base J / РСЯ', 'base_java_display'),
    ('ПК Base P / РСЯ', 'base_python_display'),
    ('Профессия Frontend / Поиск', 'prof_frontend_search'),
    ('Профессия Frontend / РСЯ', 'prof_frontend_display'),
    ('Профессия Java / Поиск', 'prof_java_search'),
    ('Профессия Java / РСЯ', 'prof_java_display'),
    ('Профессия Python / Поиск', 'prof_python_search'),
    ('Профессия Python / РСЯ', 'prof_python_display'),
    ('Профессия Аналитик данных / Поиск / Россия', 'prof_data_analytics_search_russia'),
    ('Профессия Аналитик данных / РСЯ', 'prof_data_analytics_display')
) AS m (label, slug)
WHERE ya_ads.campaign_name = m.label;

UPDATE vk_ads
SET campaign_name = m.slug
FROM (
    VALUES
    ('Профессия Data Analytics', 'prof_data_analytics'),
    ('Профессия Frontend', 'prof_frontend'),
    ('Профессия Java', 'prof_java'),
    ('Профессия Python', 'prof_python')
) AS m (label, slug)
WHERE vk_ads.campaign_name = m.label;

-- Ad names are technical already, only the Cyrillic tails remain:
-- "пк14" is a desktop placement, "(копия)" marks a duplicated ad, and
-- "cpс hand" hides a Cyrillic "с" in the Latin "cpc".
UPDATE vk_ads
SET
    ad_name = replace(
        replace(replace(ad_name, 'пк', 'pc'), '(копия)', '(copy)'),
        'cpс', 'cpc'
    )
WHERE ad_name ~ '[А-Яа-яЁё]';

-- Obfuscation leftovers: a chat message glued to the source and a stray
-- Cyrillic letter in front of a page slug.
UPDATE sessions
SET source = 'telegram'
WHERE source = 'telegram Этот курс побеждён! 💪💪💪 Было круто! 🚀';

UPDATE sessions
SET content = 'stoit-li-uchit-javascript'
WHERE content = 'нstoit-li-uchit-javascript';

-- Fail the transaction if any Cyrillic text is left, so the copy never ships
-- half translated.
DO
$$
DECLARE
    leftovers bigint;
BEGIN
    SELECT
        (SELECT count(*) FROM leads WHERE closing_reason ~ '[А-Яа-яЁё]')
        + (SELECT count(*) FROM ya_ads WHERE campaign_name ~ '[А-Яа-яЁё]')
        + (
            SELECT count(*) FROM vk_ads
            WHERE campaign_name ~ '[А-Яа-яЁё]' OR ad_name ~ '[А-Яа-яЁё]'
        )
        + (
            SELECT count(*) FROM sessions
            WHERE
                source ~ '[А-Яа-яЁё]'
                OR medium ~ '[А-Яа-яЁё]'
                OR campaign ~ '[А-Яа-яЁё]'
                OR content ~ '[А-Яа-яЁё]'
                OR landing_page ~ '[А-Яа-яЁё]'
        )
    INTO leftovers;

    IF leftovers > 0 THEN
        RAISE EXCEPTION 'marketingdb_v2: % rows still contain Cyrillic', leftovers;
    END IF;
END;
$$;
