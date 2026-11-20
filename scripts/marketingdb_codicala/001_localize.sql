-- marketingdb_codicala is the marketing database for the Spanish-speaking
-- (Codica LATAM) version of the "Escuela online" project. It is a copy of
-- marketingdb_v2 (createdb -T marketingdb_v2) without the Russian context:
-- Russian ad platforms, messengers and media become their international
-- counterparts, the Hexlet brand becomes Codica, Russian cities in segment
-- codes become Latin American ones, and money is in dollars.
--
-- closing_reason keeps the snake_case codes of marketingdb_v2 on purpose:
-- students turn them into Spanish labels themselves.
--
-- Run with psql --single-transaction: any error rolls the whole patch back.

ALTER TABLE ya_ads RENAME TO google_ads;
ALTER TABLE vk_ads RENAME TO meta_ads;

-- Traffic sources. The same mapping applies to sessions.source and to
-- utm_source of the ad tables, otherwise sessions stop joining their costs.
-- Spelling variants (Yandex, yandex-direct) stay variants on purpose:
-- normalising sources is part of the student task.
CREATE TEMP TABLE source_map (old text PRIMARY KEY, new text NOT NULL);
INSERT INTO source_map (old, new) VALUES
('yandex', 'google'),
('Yandex', 'Google'),
('yandex-direct', 'google-ads'),
('yandex.com', 'google.com'),
('vk', 'meta'),
('vk-senler', 'meta-messenger'),
('vk-group', 'meta-group'),
('vkontakte', 'facebook'),
('vk.com', 'facebook.com'),
('mytarget', 'tiktok-ads'),
('telegram', 'whatsapp'),
('telegram.me', 'wa.me'),
('tg', 'wa'),
('zen_from_telegram', 'medium_from_whatsapp'),
('dzen', 'medium'),
('zen', 'medium.com'),
('tproger', 'freecodecamp'),
('vc', 'reddit'),
('timepad', 'eventbrite'),
('go.mail.ru', 'duckduckgo.com'),
('search.ukr.net', 'search.yahoo.com');

UPDATE sessions AS s
SET source = m.new
FROM source_map AS m
WHERE s.source = m.old;

UPDATE google_ads AS a
SET utm_source = m.new
FROM source_map AS m
WHERE a.utm_source = m.old;

UPDATE meta_ads AS a
SET utm_source = m.new
FROM source_map AS m
WHERE a.utm_source = m.old;

-- Campaigns.
CREATE TEMP TABLE campaign_map (old text PRIMARY KEY, new text NOT NULL);
INSERT INTO campaign_map (old, new) VALUES
('hexlet-blog', 'codica-blog'),
('hexlet', 'codica'),
('hexlet.io/my', 'codica.la/my'),
('button-vk', 'button-meta'),
('yaintern', 'intern'),
('dzen_post', 'medium_post'),
('dzen-post', 'medium-post'),
('zen_post', 'medium_post');

UPDATE sessions AS s
SET campaign = m.new
FROM campaign_map AS m
WHERE s.campaign = m.old;

UPDATE google_ads AS a
SET utm_campaign = m.new
FROM campaign_map AS m
WHERE a.utm_campaign = m.old;

UPDATE meta_ads AS a
SET utm_campaign = m.new
FROM campaign_map AS m
WHERE a.utm_campaign = m.old;

-- dod-* (день открытых дверей) are open days, whatever the course.
UPDATE sessions
SET campaign = regexp_replace(campaign, '^dod-', 'open-day-')
WHERE campaign LIKE 'dod-%';

UPDATE google_ads
SET utm_campaign = regexp_replace(utm_campaign, '^dod-', 'open-day-')
WHERE utm_campaign LIKE 'dod-%';

UPDATE meta_ads
SET utm_campaign = regexp_replace(utm_campaign, '^dod-', 'open-day-')
WHERE utm_campaign LIKE 'dod-%';

-- Segment codes in utm_content: rsy (Yandex display network) becomes
-- display, ru/msc/krd (Russia, Moscow, Krasnodar) become latam/cdmx/bog
-- (Latin America, Mexico City, Bogotá), the brand becomes codica. The same
-- function runs over sessions and both ad tables to keep them joinable.
CREATE FUNCTION pg_temp.localize_content(content text) RETURNS text
LANGUAGE plpgsql IMMUTABLE
AS $$
BEGIN
    content := regexp_replace(content, '^rsy_', 'display_');
    content := regexp_replace(content, '_ru(\.|$)', '_latam\1', 'g');
    content := regexp_replace(content, '_msc(\.|$)', '_cdmx\1', 'g');
    content := regexp_replace(content, '_krd(\.|$)', '_bog\1', 'g');
    content := replace(content, 'geo_ru', 'geo_latam');
    content := replace(content, 'lal-hex', 'lal-codica');
    content := replace(content, 'hexlet', 'codica');
    content := replace(content, 'button-vk', 'button-meta');
    RETURN content;
END;
$$;

UPDATE sessions
SET content = pg_temp.localize_content(content)
WHERE content IS DISTINCT FROM pg_temp.localize_content(content);

UPDATE google_ads
SET utm_content = pg_temp.localize_content(utm_content)
WHERE utm_content IS DISTINCT FROM pg_temp.localize_content(utm_content);

UPDATE meta_ads
SET utm_content = pg_temp.localize_content(utm_content)
WHERE utm_content IS DISTINCT FROM pg_temp.localize_content(utm_content);

-- Blog links in content point to the Codica blog.
UPDATE sessions
SET content = replace(content, 'ru.codica.io/blog', 'codica.la/blog')
WHERE content LIKE '%ru.codica.io/blog%';

-- Money in dollars: 90 rubles per dollar, rounded to whole dollars.
UPDATE leads
SET amount = round(amount / 90.0)
WHERE amount IS NOT NULL;

UPDATE google_ads
SET daily_spent = round(daily_spent / 90.0);

UPDATE meta_ads
SET daily_spent = round(daily_spent / 90.0);

-- Fail the transaction if Russian context is left in the join keys.
DO
$$
DECLARE
    leftovers bigint;
    pattern text := '(yandex|\mvk\M|telegram|hexlet|dzen|rsy_|_ru\.|_msc\.|_krd\.|^dod-)';
BEGIN
    SELECT
        (
            SELECT count(*) FROM sessions
            WHERE
                source ~* pattern
                OR campaign ~* pattern
                OR content ~* pattern
        )
        + (
            SELECT count(*) FROM google_ads
            WHERE
                utm_source ~* pattern
                OR utm_campaign ~* pattern
                OR utm_content ~* pattern
        )
        + (
            SELECT count(*) FROM meta_ads
            WHERE
                utm_source ~* pattern
                OR utm_campaign ~* pattern
                OR utm_content ~* pattern
        )
    INTO leftovers;

    IF leftovers > 0 THEN
        RAISE EXCEPTION 'marketingdb_codicala: % rows still carry Russian context', leftovers;
    END IF;
END;
$$;
