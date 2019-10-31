# pull official base image
FROM python:3.7-alpine

#设置时区
ENV TZ "Asia/Shanghai"

#声明镜像制作者
MAINTAINER niracler niracler@gmail.com

# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

# install psycopg2
RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add postgresql-dev \
    && pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && pip install psycopg2-binary==2.8.3 -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && apk del build-deps

#install any needed pacakges in requirements.txt，你要把所有需要安装的Python模块加到这文件中。
COPY requirements.txt ./

RUN pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# copy entrypoint.sh
COPY ./entrypoint.sh /usr/src/app/entrypoint.sh

# run entrypoint.sh
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]

#暴露端口8000，到时候执行docker run 的时候才好把宿主机端口映射到8000
EXPOSE 8000
