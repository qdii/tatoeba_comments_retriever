#!/bin/sh

# this script provides facility to retrieve sentence comments from tatoeba.org





########################################## PRIVATE ################################################

tatoeba_url='http://tatoeba.org/eng/sentences/show/'

action_help=0
action_list_ids=1
action_retrieve_author=2
action_retrieve_text=3
action_retrieve_everything=4

selected_action=${action_retrieve_everything}

strip_html=1

usage()
{
    echo -e "Usage: $0 [OPTION] <SENTENCE> [COMMENT]"
    echo -e "\tWhere SENTENCE is a number identifying the sentence"
    echo -e "\tand COMMENT is a number identifying the comment, in the sentence"
    echo -e "\tAnd OPTION is any of the following:"
    echo -e "\t-l|--list\tLists all the comments belonging to the sentence"
    echo -e "\t-a|--author\tOnly displays the author name"
    echo -e "\t-t|--text\tOnly displays the comment text"
    echo -e "\t-u|--unicode\tReplace HTML from comments with UTF-8 characters [default]"
    echo -e "\t--no-strip\tLeave HTML code in comments"
}
#__________________________________________________________________________________________________
# transform html codes such as &eacute; into something readable, UTF-8 encoded
strip_html()
{
   sed -e 's/&eacute;/é/g' -e 's/&ecirc;/ê/g' -e 's/&#039;/’/g' -e 's/&laquo;/«/g' -e 's/&raquo;/»/g' -e 's/&ccedil;/ç/' -e 's/&ucirc;/û/' -e 's/&agrave;/à/g' -e 's/&egrave;/è/g' -e 's/&icirc;/î/g' -e 's/&quot;/"/g' -e "s/&nbsp;/ /g" -e "s/&iexcl;/¡/g" -e "s/&cent;/¢/g" -e "s/&pound;/£/g" -e "s/&curren;/¤/g" -e "s/&yen;/¥/g" -e "s/&brvbar;/¦/g" -e "s/&sect;/§/g" -e "s/&uml;/¨/g" -e "s/&copy;/©/g" -e "s/&ordf;/ª/g" -e "s/&laquo;/«/g" -e "s/&not;/¬/g" -e "s/&shy;/­/g" -e "s/&reg;/®/g" -e "s/&macr;/¯/g" -e "s/&deg;/°/g" -e "s/&plusmn;/±/g" -e "s/&sup2;/²/g" -e "s/&sup3;/³/g" -e "s/&acute;/´/g" -e "s/&micro;/µ/g" -e "s/&para;/¶/g" -e "s/&middot;/·/g" -e "s/&cedil;/¸/g" -e "s/&sup1;/¹/g" -e "s/&ordm;/º/g" -e "s/&raquo;/»/g" -e "s/&frac14;/¼/g" -e "s/&frac12;/½/g" -e "s/&frac34;/¾/g" -e "s/&iquest;/¿/g" -e "s/&Agrave;/À/g" -e "s/&Aacute;/Á/g" -e "s/&Acirc;/Â/g" -e "s/&Atilde;/Ã/g" -e "s/&Auml;/Ä/g" -e "s/&Aring;/Å/g" -e "s/&AElig;/Æ/g" -e "s/&Ccedil;/Ç/g" -e "s/&Egrave;/È/g" -e "s/&Eacute;/É/g" -e "s/&Ecirc;/Ê/g" -e "s/&Euml;/Ë/g" -e "s/&Igrave;/Ì/g" -e "s/&Iacute;/Í/g" -e "s/&Icirc;/Î/g" -e "s/&Iuml;/Ï/g" -e "s/&ETH;/Ð/g" -e "s/&Ntilde;/Ñ/g" -e "s/&Ograve;/Ò/g" -e "s/&Oacute;/Ó/g" -e "s/&Ocirc;/Ô/g" -e "s/&Otilde;/Õ/g" -e "s/&Ouml;/Ö/g" -e "s/&times;/×/g" -e "s/&Oslash;/Ø/g" -e "s/&Ugrave;/Ù/g" -e "s/&Uacute;/Ú/g" -e "s/&Ucirc;/Û/g" -e "s/&Uuml;/Ü/g" -e "s/&Yacute;/Ý/g" -e "s/&THORN;/Þ/g" -e "s/&szlig;/ß/g" -e "s/&agrave;/à/g" -e "s/&aacute;/á/g" -e "s/&acirc;/â/g" -e "s/&atilde;/ã/g" -e "s/&auml;/ä/g" -e "s/&aring;/å/g" -e "s/&aelig;/æ/g" -e "s/&ccedil;/ç/g" -e "s/&egrave;/è/g" -e "s/&eacute;/é/g" -e "s/&ecirc;/ê/g" -e "s/&euml;/ë/g" -e "s/&igrave;/ì/g" -e "s/&iacute;/í/g" -e "s/&icirc;/î/g" -e "s/&iuml;/ï/g" -e "s/&eth;/ð/g" -e "s/&ntilde;/ñ/g" -e "s/&ograve;/ò/g" -e "s/&oacute;/ó/g" -e "s/&ocirc;/ô/g" -e "s/&otilde;/õ/g" -e "s/&ouml;/ö/g" -e "s/&divide;/÷/g" -e "s/&oslash;/ø/g" -e "s/&ugrave;/ù/g" -e "s/&uacute;/ú/g" -e "s/&ucirc;/û/g" -e "s/&uuml;/ü/g" -e "s/&yacute;/ý/g" -e "s/&thorn;/þ/g" -e "s/&yuml;/ÿ/g" -e "s/&gt;/>/g" -e "s#&lsquo;#‘#g" -e "s#&rsquo;#’#g" -e "s#<br />##g" $1
}

#__________________________________________________________________________________________________
# retrieve a specific comment from a sentence
# usage:
#    parse_specific_comments <comment-number>
parse_specific_comment()
{
    local comment_id="$1"
    local div_regex='<a id="comment-'${comment_id}'" \/>'

    sed -n '
   	/'"${div_regex}"'/,/<li>/ {
	    s/ *<a id="comment-\([0-9]*\).*" \/>//
	    /<div class="author">/,/<\/div>/ {
	    	/<div class="author">/ d
		    s/.*<a[^>]*>/AUTHOR=/
		    s/<\/a>        <\/div>//
   	        p
	   }
	   /<div class="commentText">/,/<\/div>/ {
            /<div class="commentText">/ N
            s/.*<div class="commentText">[[:space:]]*/CONTENTS=/
            /^[[:space:]]*<\/div>/ d
            s/[[:space:]]*<\/div>//
            p
	   }
   }'
}


#__________________________________________________________________________________________________
# retrieve all the comments of a sentence
# usage:
#    parse_all_comments <comment-number>
parse_all_comments()
{
    sed -n -e '
   	/'ol class=\"comments\"'/,/<li>/ {
	    s/ *<a id="comment-\([0-9]*\).*" \/>//
	    /<div class="author">/,/<\/div>/ {
	    	/<div class="author">/ d
	   	s/.*<a[^>]*>/AUTHOR=/
		s/<\/a>        <\/div>//
   	        p
	   }
	   /<div class="commentText">/,/<\/div>/ {
	   	/<div class="commentText">/ N
		s/.*<div class="commentText">[[:space:]]*/CONTENTS=/
		s/[[:space:]]*<\/div>//
		p
	   }
        }
   '
}

#__________________________________________________________________________________________________
# 
extract_author_from_parsed_comment()
{
   sed -n 's/AUTHOR=\(.*\)/\1/p'
}
#__________________________________________________________________________________________________

extract_text_from_parsed_comment()
{
   sed -e 's/CONTENTS=//' -e '/AUTHOR=.*/d'
}

#__________________________________________________________________________________________________

# output the list of comment ids from a sentence
list_ids_from_parsed_comment()
{
    sed -n 's/.*id=\"comment-\([0-9]\+\).*/\1/p'
}

#__________________________________________________________________________________________________
#
# usage retrieve_page_and_strip <SENTENCE> <ENABLE_STRIP>
# where SENTENCE is the sentence id
# and ENABLE_STRIP is either 0 or 1 
retrieve_page_and_strip()
{
    local sentence_id="$1"
    local raw_page=`wget -q -O- "${tatoeba_url}$1"`

    [ $? -ne 0 ] && echo "Unable to connect to the website." && exit -1
    if [ "$2" =  "1" ]
    then
        raw_page=`echo "$raw_page" | strip_html`
    fi

    echo "$raw_page"
}
#__________________________________________________________________________________________________

retrieve()
{
    local sentence_id=$1
    local comment_id=$2
    local action=$3
    local strip_html=$4

    if [ "$comment_id" = "0" ]
    then
        if [ "$action" = "${action_retrieve_author}" ]
        then
            retrieve_page_and_strip $sentence_id $strip_html | parse_all_comments | extract_author_from_parsed_comment
        elif [ "$action" = "${action_retrieve_text}" ]
        then
            retrieve_page_and_strip $sentence_id $strip_html | parse_all_comments | extract_text_from_parsed_comment
        elif [ "$action" = "${action_retrieve_everything}" ]
        then
            retrieve_page_and_strip $sentence_id $strip_html | parse_all_comments
        fi
    else
        if [ "$action" = "${action_retrieve_author}" ]
        then
            retrieve_page_and_strip $sentence_id $strip_html | parse_specific_comment $comment_id | extract_author_from_parsed_comment
        elif [ "$action" = "${action_retrieve_text}" ]
        then
            retrieve_page_and_strip $sentence_id $strip_html | parse_specific_comment $comment_id | extract_text_from_parsed_comment
        elif [ "$action" = "${action_retrieve_everything}" ]
        then
            retrieve_page_and_strip $sentence_id $strip_html | parse_specific_comment $comment_id
        fi
        
    fi
}

#__________________________________________________________________________________________________

retrieve_author()
{
    local sentence_id=$1
    local comment_id=$2

    if [ "$comment_id" = "0" ]
    then
        retrieve_page_and_strip $sentence_id $strip_html | parse_all_comments | extract_author_from_parsed_comment
    else
        retrieve_page_and_strip $sentence_id $strip_html | parse_specific_comment $comment_id | extract_author_from_parsed_comment
    fi
}
#__________________________________________________________________________________________________

retrieve_text()
{
    local sentence_id=$1
    local comment_id=$2

    if [ "$comment_id" = "0" ]
    then
        retrieve_page_and_strip $sentence_id $strip_html | parse_all_comments | extract_text_from_parsed_comment
    else
        retrieve_page_and_strip $sentence_id $strip_html | parse_specific_comment $comment_id | extract_text_from_parsed_comment
    fi
}


params=`getopt -o latuh --long list,author,text,unicode,help,no-strip -n $0 -- "$@"`
[ $? != 0 ] && exit 1

eval set -- "$params"
while true ; do
	case "$1" in
		-h|--help) usage ; exit 0 ; shift ;;
        	-l|--list) selected_action=${action_list_ids}; shift ;;
        	-a|--author) selected_action=${action_retrieve_author}; shift ;;
        	-t|--text) selected_action=${action_retrieve_text}; shift ;;
        	-u|--unicode) strip_html=1; shift ;;
		--no-strip) strip_html=0; shift ;;
		--) shift ; break ;;
		*) echo "Internal error!" ; exit 1 ;;
	esac
done

sentence_id=$1
comment_id=$2
[ -z "$sentence_id" ] && usage && exit 1

retrieved_page=`retrieve_page_and_strip $sentence_id $strip_html`
echo $retrieved_page | parse_specific_comment $comment_id


case "${selected_action}" in
    ${action_list_ids}) retrieve_page_and_strip $sentence_id 0 | list_ids_from_parsed_comment ;;
    ${action_retrieve_author}) retrieve_author $sentence_id $comment_id ;;
    ${action_retrieve_text}) retrieve $sentence_id $comment_id $selected_action $strip_html ;;
    ${action_retrieve_everything}) retrieve $sentence_id $comment_id $selected_action $strip_html ;;
esac
