# drone-ssh

![buildx](https://github.com/ryjer/drone-ssh/workflows/buildx/badge.svg)
[![Docker Stars](https://img.shields.io/docker/stars/ryjer/drone-ssh.svg)](https://hub.docker.com/r/ryjer/drone-ssh/)
[![Docker Pulls](https://img.shields.io/docker/pulls/ryjer/drone-ssh.svg)](https://hub.docker.com/r/ryjer/drone-ssh/)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Drone plugin to execute commands on a remote host through SSH. 
# Usage in drone ci
```bash
  - name: ssh commands
    image: ryjer/drone-ssh
    settings:
      host:
        - example.com
        - 10.0.0.1
      port: 22
      username: root
      password: 12345678
      timeout: 3m
      script:
        - echo "hello world"
        - ls
```

**注意：**建议使用 **from_secret:** 保护机密信息，具体用法参考 drone 文档

保护 username 和 password 的from_secret示例如下
```bash
  - name: ssh commands
    image: ryjer/drone-ssh
    settings:
      host: example.com
      port: 22
      username: 
        from_secret: ssh_username
      password: 
        from_secret: ssh_password
      timeout: 3m
      script:
        - echo "hello world"
        - ls
```
# 参数说明
### host
远程主机名，支持 域名和ip两种格式。支持多主机，但这些主机的端口、用户名和密码必须相同
### port
ssh 登录端口，通常为 22
### username
ssh 的登陆用户名
### password
ssh 登录用户名
### timeout
超时限制，限制最长执行时间。示例如下
| 时间格式 | Time format | timeout argument    timeout命令参数 |
| :------- | ----------- | ----------------------------------- |
| 3秒      | 3 seconds   | 3                                   |
| 3秒      | 3 seconds   | 3s                                  |
| 5分钟    | 5 minutes   | 5m                                  |
| 4小时    | 4 hours     | 4h                                  |
| 6天      | 6 days      | 6d                                  |

### script
在远程主机执行的命令列表

# Usage in docker

```bash
docker run -it --rm \
  -v $PWD:/root \
  -e PLUGIN_HOST=example.com,10.0.0.1 \
  -e PLUGIN_PORT=22 \
  -e PLUGIN_USERNAME=root \
  -e PLUGIN_PASSWORD=12345678 \
  -e PLUGIN_TIMEOUT=3m \
  -e PLUGIN_SCRIPT=echo hello world,ls \
  ryjer/drone-ssh
```

