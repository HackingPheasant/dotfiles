
tools_dir="$(pwd)/tools"
nsw_dir="$tools_dir/nsw"
nfo_img_dir="$nsw_dir/nfo_img/raw"
url_base="http://rom-news.org"

function nsw_release()
{
check_dirs
	max_page="$(curl -ss -g -k "http://rom-news.org/nsw/releaselist/1/date/desc" | grep "a href" | tail -n 2 | tr ' ' '\n' | tr -s '\n' | tail -n 6 | head -n 1)"
	for page in $(jot $max_page)
	do
		process_page $page&
	done
	wait
}

function process_page()
{
	page="$1"
	links="$(curl -ss -g -k "http://rom-news.org/nsw/releaselist/$page/date/desc" | grep "a href" | grep "nf" | awk '{print $4}' | sed 's/href//g' | tr -d '\=\"\<\>')"
	for page_base in $links
	do
		nfo_link="$url_base/$page_base"
		image_link="$url_base/$(curl -ss -g -k "$nfo_link" | grep "NFO DOWNLOAD" | awk '{print $4}' | sed 's/href="//g' | sed 's/">NFO//g')"
		image_filename="$(echo $image_link | tr '/' ' ' | awk '{print $6}')"
#		echo $nfo_link $image_link $image_filename
		if [[ -z $image_filename ]]
		then
			echo $nfo_link
		elif [[ ! -z $image_filename ]] && [ ! -f $nfo_img_dir/"$image_filename" ]
		then
#			echo "$image_file Uncached"
			fetch_image&
		fi
	done
}

function fetch_image()
{
	cd $nfo_img_dir
	curl -ss -g -k -O -R $image_link
}

function check_dirs()
{
	if [ ! -d $nfo_img_dir ]
	then
		mkdir -p $nfo_img_dir
	fi	
}


nsw_release