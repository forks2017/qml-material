#!/bin/bash
#===============================================================================================
#   System Required:  CentOS Debian or Ubuntu (32bit/64bit)
#   Description:  Install Ngrok for CentOS Debian or Ubuntu
#   Author: Clang <admin@clangcn.com>
#   Intro:  http://clang.cn
#===============================================================================================
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
#export PATH
shell_run_start=`date "+%Y-%m-%d %H:%M:%S"`   #shell run start time
version="V2.3"
g_str_dir_sh=$(cd `dirname $0`; pwd)
g_str_dir_ca="${g_str_dir_sh}/ca"
g_str_dir_ngrok_src="${g_str_dir_sh}"
str_ngrok_dir="/usr/local/ngrok"

function generate_qrc_content(){
    local mark=$1
    local file_name=$2

    echo "    <qresource prefix=\"/icons/${mark}\">" >> ${file_name}
    #ls -l | awk '{print $NF}' | grep ${mark} >> icons_${mark}.qrc
    ls -l | awk '{print $NF}' | grep -v '.qrc' | grep ${mark} | awk -F "[_]" '{for(i=1;i<=NF;i++) if (i==1) printf "        <file alias=\""; else if (i==NF) printf $i"\">";  else printf $i"_";  printf $0"</file>"; printf "\n"}' >> ${file_name}

    echo "    </qresource>" >> ${file_name}
}

function generate_single_qrc_file() {
	local file_name_all="icons_all.qrc"
	echo "<RCC>" > ${file_name_all}

	for i in `ls -l | grep -vE '.sh|.qrc' | awk '{print $NF}' | awk -F "[_]" '{print $1}' | awk '!a[$0]++' | awk '{if(NR > 1){print $0}}' | grep -v '.svg'`; do
	 	#echo $i;
	 	generate_qrc_content $i ${file_name_all};
	 done;

	 echo "</RCC>" >> ${file_name_all}
}

# generate_qrc_file
function generate_split_qrc_file(){
    local mark=$1

    echo "<RCC>" > icons_${mark}.qrc

    generate_qrc_content ${mark} icons_${mark}.qrc

	echo "</RCC>" >> icons_${mark}.qrc
}

function generate_split_qrc_files() {
	 for i in `ls -l | grep -vE '.sh|.qrc' | awk '{print $NF}' | awk -F "[_]" '{print $1}' | awk '!a[$0]++' | awk '{if(NR > 1){print $0}}' | grep -v '.svg'`; do
	 	#echo $i;
	 	generate_split_qrc_file $i;
	 done;
}

function generate_all_qrc_file() {
	 generate_single_qrc_file
	 generate_split_qrc_files
}

clear

action=$1
[  -z $1 ]
case "$action" in
    action)
        generate_split_qrc_file ${action}
    ;;
    all)
        generate_all_qrc_file
    ;;
    *)
        fun_clangcn
        echo "Arguments error! [${action} ]"
        echo "Usage: `basename $0` {all|action|}"
    ;;
esac

echo "done!"

