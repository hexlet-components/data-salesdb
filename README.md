<div align="center">

<a href="https://hexlet.io/?utm_source=github&utm_medium=link&utm_campaign=data-salesdb">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Hexlet/brand-assets/master/images/svg/hexlet_wordmark_white_rus.svg">
        <img src="https://raw.githubusercontent.com/Hexlet/brand-assets/master/images/svg/hexlet_wordmark_primary_rus.svg" alt="Хекслет" height="64">
    </picture>
</a>

# data-salesdb

[![CI](https://github.com/hexlet-components/data-salesdb/actions/workflows/main.yml/badge.svg)](https://github.com/hexlet-components/data-salesdb/actions/workflows/main.yml)
[![Check](https://github.com/hexlet-components/data-salesdb/actions/workflows/check.yml/badge.svg)](https://github.com/hexlet-components/data-salesdb/actions/workflows/check.yml)

</div>

Компонент создаёт и поддерживает команда [Хекслета](https://hexlet.io/?utm_source=github&utm_medium=link&utm_campaign=data-salesdb), образовательного проекта.

Образ PostgreSQL с учебными базами для курсов по SQL и аналитике. Он работает на `db.hexlet.app:5432`, студенты подключаются к нему из psql, DBeaver и Superset под ролью `student` с паролем `student`, только на чтение. Через эту же роль к базам ходят CloudBeaver на `beaver.hexlet.app` и `data-charts-api`. Изменение схемы или данных меняет результаты запросов, которые приводят уроки и проекты.

| База | Кто пользуется |
| --- | --- |
| `salesdb` | курс по Superset, проект аналитики данных уровня 1 |
| `chartsdb` | `data-charts-api` |
| `webinarsdb` | урок про JOIN курса по SQL для аналитиков |
| `marketingdb` | проект аналитики данных уровня 2 |
| `marketingdb_v2` | копия `marketingdb` со слагами вместо русских значений |
| `marketingdb_codicala` | копия `marketingdb_v2` для испаноязычной версии проекта, суммы в долларах |
| `setoperationsdb` | в материалах Хекслета не найдена, таблицы `course_members_2022` и `course_members_2023` |
| `flightsdb` | курс по Superset |
| `coursesdb` | урок про psql курса основ SQL |

Контейнер очищает данные на каждом старте и заново прогоняет скрипты init (`scripts/reset_entrypoint.sh`). Ошибка любого скрипта останавливает контейнер. Временные таблицы `student` лежат в табличном пространстве `student_tmp`, на проде под ним tmpfs на 512 МБ.

## Запуск

```sh
make build   # собрать образ data-salesdb
make start   # поднять его на localhost:5432
make test    # собрать, поднять и сверить число строк
```

`make compose` поднимает то же через `docker-compose.yml` с tmpfs, как на проде. Инициализация занимает около минуты.

`make test` запускает `test/smoke.sh`. Он ждёт конца init, падает на любой ошибке в его логе и сверяет число строк всех таблиц с [test/expected_counts.tsv](test/expected_counts.tsv) под ролью `student`. После намеренного изменения данных числа в этом файле обновляются.

## Выкат

Push в `main` собирает образ, гоняет `test/smoke.sh` и только после него отправляет `ghcr.io/hexlet-components/data-salesdb:latest`. Pull request проходит сборку и проверку без отправки. На сервер образ выкатывает роль `sales_db` репозитория own-heroku, выкат запускают руками.

## Проверки

`mise run check` гоняет тот же набор, что CI: разметку, опечатки, ссылки, workflows, Dockerfile и shell-скрипты.
