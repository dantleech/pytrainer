#!/bin/sh

NO_LANGUAGE='None (generate .pot)'

LANGUAGE=$(zenity --list --text="Select your language" --radiolist --column "Pick" --column "Language" TRUE "$NO_LANGUAGE" FALSE "es" FALSE "eu" FALSE "ca" FALSE "fr" FALSE "da" FALSE "de" FALSE "pl" FALSE "no" FALSE "cs" FALSE "ru" FALSE "pl" FALSE "sv" FALSE "gl")
if [ $? != 0 ]; then exit ; fi

cd ../

echo "Extracting translatable strings from input files"
xgettext glade/*.glade -o ./messages.pot
if [ $? != 0 ]; then echo "WARNING: xgettext not found. Please install gettext package"; exit; fi
find ./ -iname "*.py" -exec xgettext -k_ -j -o ./messages.pot {} \;

CWD=$(pwd)
echo "Generated $CWD/messages.pot"

if test "$LANGUAGE" = "$NO_LANGUAGE"; then exit; fi

echo "Initializing translations for desired language"
msginit -i ./messages.pot -l $LANGUAGE -o ./locale/$LANGUAGE/LC_MESSAGES/pytrainer_$LANGUAGE.po_new

cd ./locale/$LANGUAGE/LC_MESSAGES/
echo "Merging old po file with newly generated one"
make merge

SOFTWARE=$(zenity --list --text="Select your translation software" --radiolist --column "Pick" --column "Software" TRUE "gtranslator" FALSE "kbabel" FALSE "poedit")
if [ $? != 0 ]; then exit ; fi

# Editing our new gettext catalog (.po file)
$SOFTWARE pytrainer_$LANGUAGE.po
if [ $? != 0 ]; then echo "WARNING: $SOFTWARE not found"; exit ; fi

echo "Compiling new message catalog"
make
