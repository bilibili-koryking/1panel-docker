# 使用 Ubuntu 22.04 作为基础镜像
FROM ubuntu:22.04

# 设置环境变量，避免交互式配置
ARG DEBIAN_FRONTEND=noninteractive

# 设置时区为亚洲/上海
ENV TZ=Asia/Shanghai

# 安装所需的软件包并清理APT缓存
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    unzip \
    zip \
    curl \
    git \
    sudo \
    gnupg \
    sqlite3 \
    tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y docker-ce-cli && \
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 设置工作目录为/app
WORKDIR /app

# 复制必要的文件
COPY ./install.override.sh .
COPY ./update_app_version.sh .

# 下载并安装 1Panel
RUN INSTALL_MODE="stable" && \
    ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "armhf" ]; then ARCH="armv7"; fi && \
    if [ "$ARCH" = "ppc64el" ]; then ARCH="ppc64le"; fi && \
    package_file_name="1panel-$(curl -s https://resource.fit2cloud.com/1panel/package/stable/latest)-linux-${ARCH}.tar.gz" && \
    package_download_url="https://resource.fit2cloud.com/1panel/package/${INSTALL_MODE}/$(curl -s https://resource.fit2cloud.com/1panel/package/stable/latest)/release/${package_file_name}" && \
    echo "Downloading ${package_download_url}" && \
    curl -sSL -o ${package_file_name} "$package_download_url" && \
    tar zxvf ${package_file_name} --strip-components 1 && \
    rm /app/install.sh && \
    mv -f /app/install.override.sh /app/install.sh && \ 
    cp /app/1panel.service /etc/systemd/system/1panel.service && \
    chmod +x /app/install.sh && \
    chmod +x /app/update_app_version.sh
# 设置工作目录为根目录
WORKDIR /


# 创建 Docker 套接字的卷
VOLUME /var/run/docker.sock

# 启动
CMD ["/bin/bash", "-c", "/app/install.sh && /app/update_app_version.sh && /usr/local/bin/1panel"]
