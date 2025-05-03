FROM verdaccio/verdaccio:6.1.2
LABEL maintainer="ShiDong"

USER root
WORKDIR /verdaccio

# 创建必要目录并设置权限
RUN mkdir -p /verdaccio/storage /verdaccio/conf && \
    chmod -R 755 /verdaccio && \
    chmod -R 777 /verdaccio/storage

# 声明存储卷
VOLUME ["/verdaccio/storage", "/verdaccio/conf"]

# 暴露默认端口
EXPOSE 4873

user 10001:10001
# 启动 Verdaccio
CMD ["verdaccio", "--config", "/verdaccio/conf/config.yaml"]