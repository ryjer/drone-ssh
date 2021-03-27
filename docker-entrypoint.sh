#!/bin/sh
set -e

# 创建 所需文件目录环境
workdir="/ssh"

# 检查 环境变量完备性: 主机名host 端口port 用户名username 密码password 源文件source 目标文件target
if [[ ! ${PLUGIN_HOST} ]] || [[ ! ${PLUGIN_PORT} ]] || [[ ! ${PLUGIN_USERNAME} ]] || [[ ! ${PLUGIN_PASSWORD} ]] || [[ ! ${PLUGIN_SCRIPT} ]]; then
    echo "\"host\" or \"port\" or \"username\" or \"password\" or \"script\" is not exist!"
    echo "\"host\" 或 \"port\" 或 \"username\" 或 \"password\" 或 \"script\" 未定义！"
    exit 1
fi

# 从环境变量读取 host 列表，导入 hosts 文件中备用
echo ${PLUGIN_HOST} | sed "s/,/\n/g" > ${workdir}/hosts

# 从环境变量读取 script 脚本列表（将分隔符逗号 全部替换为换行）
echo ${PLUGIN_SCRIPT} | sed "s/,/\n/g" > ${workdir}/script

# 获取 PLUGIN_ 其他环境变量，并转换为本地变量格式
port=${PLUGIN_PORT}
username=${PLUGIN_USERNAME}
password=${PLUGIN_PASSWORD}

# 添加目标主机 hash 指纹，防止接下来 scp 命令提示是否接受目标主机 HASH 公钥指纹
ssh-keyscan -f ${workdir}/hosts -p ${port}  >> ${HOME}/.ssh/known_hosts
# 循环处理 主机列表
cat ${workdir}/hosts | while read line
do
    host=`echo $line | awk '{print $1}'`
    echo  "================ Host: ${host} start ================"
    ## 执行预定义的脚本文件 ${workdir}/script
    sshpass -p ${password} ssh ${username}@${host} < ${workdir}/script
    ## 根据 ssh 执行结果进行反馈
    if [[ $? != 0 ]]; then
        echo "======== ❌  ssh failed! ssh命令运行失败！========"
        cat ${workdir}/script
        exit 1
    else
        echo "======== ✅  ssh successed!  ssh命令运行完成！========"
    fi
    echo "================ Host: ${host} successed ================"
done

echo "================================"
printf "   All completed！ 全部完成！\n"
echo "================================"
