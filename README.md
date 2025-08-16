# dota1x6-free

## Create mklink folders
Create mklink folders in CMD. Just run ".\create_mklinks.bat". Solution only for windows OS
```cmd
set dota2_path=C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta
set custom_game_folder=xeno_free

mkdir "%dota2_path%\game\dota_addons\%custom_game_folder%"
mkdir "%dota2_path%\content\dota_addons\%custom_game_folder%"

mklink /j game "%dota2_path%\game\dota_addons\%custom_game_folder%"
mklink /j content "%dota2_path%\content\dota_addons\%custom_game_folder%"
```

## Как запустить у себя для внесения правок
- Запустить Dota 2 - Tools (в свойствах steam dota2 / dls ставился галка на установление)
- Создать новый проект "Create New Addon"
- По пути `{Пусть установки доты}/steamapps/common/dota 2 beta/` будет находиться две папки "content" и "game". Содержимое кастомки по отдельному из путей представлено в данном репозитории. Для удобства можно создать до них mklink и появится возможность удаленно в них заходить
- Запуститься в "Dota 2 - Tools" в свой созданный проект
- Открыть Hammer (иконка с молотом)
- Далее открыть mock карту из `content/maps/unranked.vmap` у себя в проекте, куда вы прилинковали содержимое (File/Open). В этом файле просто должна быть любая валидная vmap карта
- Открыть меню сборки "File/Build map... (F9)"
- В данном меню нажимать "Run (Skip Build)". НЕ надо Build, тк нет исходников карты, чтобы с нуля ее собирать. mock карта с названием карты автора помогает запустить нужную. Тут либо solo/duo варианты
- Читаем/Меняем скрипты `content/panorama/` (тут UI) ИЛИ `game/scripts` (тут lua скрипты) и смотрим за результатом

## Добавлять обновления к проекту
- Загрузить https://valveresourceformat.github.io/
- Открываем с графическим интерфейсом софт
- Переходим через закладку "Explorer" в dota2. В конце списка доходим до кастомки DOTA 1x6. Двойной клик
- Копируем все содержимое "Export as is" по пути кастомки в `game/dota_addons/xeno_free`
- А файлы из папок `panorama/(layout|scripts|styles)` по пути кастомки в `content/dota_addons/xeno_free` через "Decompile & export"
- lua скрипты не запаковываются и потому хватает as is экспортировать. А UI (js,css,xml) из панорамы приходится

## Ветки
free - ветка с правками

main - оригинал от авторов

## Сжатие видео ffmpeg в panorama/videos/custom_game (bash)
Такой вариант сжимает xeno "мусор" на 1.6 гига до ~180мегабайт. И плюс минус нормально выглядит. У него вес кастомки это видосики, которые нужны только на стадии пика...
```sh
for file in *.webm; do
  ffmpeg -i "$file" \
    -vf "scale=640:360,fps=24" \
    -c:v libvpx-vp9 \
    -crf 60 \
    -b:v 400k \
    -cpu-used 4 \
    -an \
    tmp.webm;
  rm -f "$file" && mv "tmp.webm" "$file"
done

for file in ./shop/*/*.webm; do
  ffmpeg -i "$file" \
    -vf "scale=640:360,fps=24" \
    -c:v libvpx-vp9 \
    -crf 60 \
    -b:v 400k \
    -cpu-used 4 \
    -an \
    tmp.webm;
  rm -f "$file" && mv "tmp.webm" "$file"
done

for file in ./heroes/*/*.webm; do
  ffmpeg -i "$file" \
    -vf "scale=640:360,fps=24" \
    -c:v libvpx-vp9 \
    -crf 60 \
    -b:v 400k \
    -cpu-used 4 \
    -an \
    tmp.webm;
  rm -f "$file" && mv "tmp.webm" "$file"
done
```

## Отличия от основной кастомки XENO
- донатный герой не заблокирован
- Бесплатная подписка. То есть все ее фишки
- Дейли шарды рандомно выдаются от 50к до 700к