# dota1x6-free

## Info
- [Путь где хранятся скрипты панорамы(ui)](game/dota_addons/xeno_free/scripts)
- [Путь где хранятся скрипты lua(logic)](content/dota_addons/xeno_free/panorama)

## Отличия от основной кастомки XENO
- Sand king больше не донатный герой
- Бесплатная подписка
- Дейли шарды рандомно выдаются от 50к до 700к

## Как запустить у себя для внесения правок
- Запустить Dota 2 - Tools
- Создать новый проект "Create New Addon"
- По пути `{Пусть установки доты}/steamapps/common/dota 2 beta/` будет находиться две папки "content" и "game". Содержимое кастомки по отдельному из путей представлено в данном репозитории. Нужно скопировать контект из `content/dota_addons/xeno_free` в папку с названием вашей кастомки с названием из пункта "2". `game/dota_addons/xeno_free` по соответственному принципу
- При запуске в самих "Dota 2 - Tools" запустить свой проект
- Открыть Hammer
- Далее открыть mock карту из `content/**/maps/unranked.vmap` у себя в проекте, куда вы скопировали содержимое (File/Open)
- Открыть меню сборки "File/Build map..."
- В данном меню нажимать "Run (Skip Build)". НЕ надо Build, тк нет исходников карты, что с нуля ее собирать.
- Читаем/Меняем скрипты `content/**/panorama/` ИЛИ `game/**/scripts` и смотрим за результатом

## Добавлять обновления к проекту
- Загрузить https://valveresourceformat.github.io/
- Открываем с графическим интерфейсом софт
- Переходим через закладку "Explorer" к кастомке XENO "Explorer/Dota 2/[Workshop ...] DOTA 1x6 ...". Двойной клик
- Копируем все содержимое "Export as is" по пути кастомки в game
- А файлы из папок `"panorama/(layout|scripts|styles)"` по пути кастомки в content через "Decompile & export"