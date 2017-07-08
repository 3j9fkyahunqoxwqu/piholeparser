#!/bin/bash
## This Recreates The Valid TLD file

## Variables
source /etc/piholeparser/scripts/scriptvars/staticvariables.var

CHECKME=$VALIDDOMAINTLD
if
ls $CHECKME &> /dev/null;
then
rm $CHECKME
fi

for source in `cat $VALIDDOMAINTLDLINKS`;
do
printf "$cyan"    "The Source In The File Is:"
printf "$yellow"    "$source"
echo ""
UPCHECK=`echo $source | awk -F/ '{print $3}'`
if
[[ -n $UPCHECK ]]
then
SOURCEIPFETCH=`ping -c 1 $UPCHECK | gawk -F'[()]' '/PING/{print $2}'`
SOURCEIP=`echo $SOURCEIPFETCH`
else
printf "$red"    "DOMAIN TLD Host Unavailable."
fi
if
[[ -n $SOURCEIP ]]
then
curl -s -H "$agent" -L $source >> $TEMPFILEN
elif
[[ -z $SOURCEIP ]]
then
cp $VALIDDOMAINTLDBKUP $TEMPFILEN
fi
cat $TEMPFILEN >> $TEMPFILEM
rm $TEMPFILEN
done

cat $TEMPFILEM | sed '/[/]/d; /\#\+/d; s/\s\+$//; /^$/d; /[[:blank:]]/d; /[.]/d' > $TEMPFILEL
cat -s $TEMPFILEL | sort -u | gawk '{if (++dup[$0] == 1) print $0;}' > $VALIDDOMAINTLD
rm $TEMPFILEL
HOWMANYTLD=$(echo -e "\t`wc -l $VALIDDOMAINTLD | cut -d " " -f 1`")
echo "$HOWMANYTLD Valid TLD's"

CHECKME=$VALIDDOMAINTLDBKUP
if
ls $CHECKME &> /dev/null;
then
rm $CHECKME
fi
cp $VALIDDOMAINTLD $VALIDDOMAINTLDBKUP
