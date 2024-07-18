# 1panel-docker
基于[okxlin/docker-1panel](https://github.com/okxlin/docker-1panel)修改了下几个文件，仅解决不使用/opt目录时直接使用应用商店安装应用报错的问题，并将安装目录，端口号，安全入口，用户名和密码放到环境变量中，其他的使用方式和问题都同原项目。
刚玩github，不太懂规则，如果有什么做的不对的，欢迎指正。

## 另外我也会针对一些常用好玩的应用做一些视频教程和文字教程，大家可以关注下小up，B站：koryking，公众号：koryking999，什么值得买：koryking。

# docker-compose使用方式
创建docker-compose.yml文件，将以下内容中的/xxxx/opt替换成你自己的应用安装路径，注意三个/xxxx/opt都需要修改成一样的。

PANEL_PORT=10086 #自定义端口号，不设置默认为10086

PANEL_ENTRANCE=koryking #自定义安全入口，不设置默认为entrance

PANEL_USERNAME=koryking #自定义用户名，不设置默认为1panel

PANEL_PASSWORD=koryking999 #自定义登录密码，不设置默认为1panel_password

文件上传到本地后执行docker compose up -d

```huggingface-cli
services:
  1panel:
    container_name: 1panel # 容器名
    restart: always
    network_mode: "host"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./volumes:/var/lib/docker/volumes
      - /xxxx/opt:/xxxx/opt # 文件存储映射
      - ./root:/root  # 可选的文件存储映射
    environment:
      - TZ=Asia/Shanghai  # 时区设置
      - PANEL_BASE_DIR=/xxxx/opt
      - PANEL_PORT=10086
      - PANEL_ENTRANCE=koryking
      - PANEL_USERNAME=koryking
      - PANEL_PASSWORD=koryking999
    image: docker.io/koryking/1panel:latest
    labels:
      createdBy: "Apps"
```
