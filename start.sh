#!/bin/bash
#by nhw 2017-3-14
#modify by sunhuo 2017-5-19

src_dir=/tmp
project_name=rabbit-marketing-miniapp-server
version=0.0.1-SNAPSHOT
dubbo_port=36250
dest_dir=/data/server
back_dir=/backup/job
dt=`date "+%F-%H-%M"`

#env={dev,test,beta,product}
env=test


export JAVA_HOME=/usr/local/jdk1.8.0_112
export PATH=$JAVA_HOME/bin:$PATH

#export AGENT_PATH=/usr/local/pinpoint-agent
#export AGENT_VERSION=1.5.2
#export AGENT_ID=${project_name}-${env}
#export APPLICATION_NAME=${project_name}-${env}
#export JAVA_AGENT="  -javaagent:$AGENT_PATH/pinpoint-bootstrap-$AGENT_VERSION.jar -Dpinpoint.agentId=$AGENT_ID  -Dpinpoint.applicationName=$APPLICATION_NAME "
export JAVA_AGENT=""


function stop_job()
{
        if [ ! -e ${dest_dir}/${project_name}-${dubbo_port}/bin ];then
                mkdir -p ${dest_dir}/${project_name}-${dubbo_port}/{bin,backupconf,conf,logs,lib}
                return 0
        fi


        cd ${dest_dir}/${project_name}-${dubbo_port}/bin/

        status=$((`ps aux | grep "${project_name}-${dubbo_port}" | wc -l` -1))
        if [ $status -eq 1 ];then
                ./server.sh stop
                Stop_Flag=$?
        elif [ $status -eq 0 ];then

                echo "Job service already stop..."
                return 0
        fi

        if [ $Stop_Flag -eq 0 ];then
                echo "stop job service success!"
                return 0
        else
                echo "stop job service failed!"
                return 1
        fi
}

function backup_job()
{
        if [ ! -e $back_dir ];then
                mkdir -p $back_dir
        elif [ ! -d $back_dir ];then
                echo "$back_dir is not directory,please chek $back_dir."
                return 1
        fi

        cd ${dest_dir}
        tar czf ${project_name}-${dubbo_port}-${dt}.tar.gz --exclude=logs ${project_name}-${dubbo_port}
        if [ $? -eq 0 ];then
                echo "compress success..."
                if [ -f ${project_name}-${dubbo_port}-${dt}.tar.gz ];then
                        mv ${project_name}-${dubbo_port}-${dt}.tar.gz $back_dir
                        if [ $? -eq 0 ];then
                                echo "backup_job success..."
                        fi
                fi
                if [ -d ${project_name}-${dubbo_port} ];then
                        rm -rf ${project_name}-${dubbo_port}/{bin,conf,lib,logs}
                fi
        else
                echo "compress failed... "
        fi

        cd ${back_dir}

        #保留最近4个备份
        ls -lt ${project_name}-${dubbo_port}-*.tar.gz | tail -n +5 | awk '{print $NF}' | xargs rm -rf > /dev/null
        return 0
}


function uncompress_job()
{
        echo "start uncompress_job ------------------>"
        cd ${dest_dir}
        if [ ! -e ${src_dir}/${project_name}-${version}-assembly.tar.gz ];then
                echo "uncompredd_job ${src_dir}/${project_name}-${version}-assembly.tar.gz is not exists"
                exit
        fi
        cp ${src_dir}/${project_name}-${version}-assembly.tar.gz .
        echo "${src_dir}/${project_name}-${version}-assembly.tar.gz .------------>"
        if [ -f ${project_name}-${version}-assembly.tar.gz ];then

                tar zxvf ${project_name}-${version}-assembly.tar.gz -C ${project_name}-${dubbo_port}
                cd ${project_name}-${dubbo_port} && mv ${project_name}-${version}/* . && rmdir ${project_name}-${version}
                if [ $? -eq 0 ];then
                        echo "new tar.gz uncompress success..."
                        cd ${dest_dir}
                        rm -rf ${project_name}-${version}-assembly.tar.gz
                        return 0
                else
                        echo "new tar.gz uncompress failed..."
                        return 1
                fi
        fi
}

function instead_job_conf()
{
        cd ${dest_dir}/${project_name}-${dubbo_port}/backupconf
        if [ -f dubbo.properties ];then
                cp -f dubbo.properties ../conf/
        else
                echo "dubbo.properties file is not exist or not a file...failed"
        fi
}

function start_job()
{
        cd ${dest_dir}/${project_name}-${dubbo_port}/bin/
        echo "start_job: `pwd`"
        #rm -rf start.sh
        #cp /root/start.sh .
        sh start.sh
        if [ $? -eq 0 ];then
                echo "start job service success!"
                return 0
        else
                echo "start job service failed!"
                return 1
        fi
}

#read -p "Do you want to pubish Job Service? [Y/N]:" sure
sure="Y"
if [ $sure == "Y" ] ;then
        stop_job
        Stop_job_Flag=$?
        echo $Stop_job_Flag
        if [ $Stop_job_Flag -eq 0 ];then
                backup_job
                Back_job_Flag=$?
                echo $Back_job_Flag
        fi
        if [ $Back_job_Flag -eq 0 ];then
                uncompress_job
                Uncompress_job_Flag=$?
        fi
        if [ $Uncompress_job_Flag -eq 0 ];then
                instead_job_conf
                Instead_job_conf_Flag=$?
                echo "Instead_job_conf_Flag= ${Instead_job_conf_Flag}"
        fi
        if [ $Instead_job_conf_Flag -eq 0 ];then
                start_job
        fi
else
        echo "exit..."
fi