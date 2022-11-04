基于 [官方镜像 postgres](https://hub.docker.com/_/postgres) 添加 [zhparser](https://github.com/amutu/zhparser) 插件，每周自动构建以保证使用最近版本的基础镜像。

# Quick reference

-	**Maintained by**:  
	[loyayz/docker-zhparser](https://github.com/loyayz/docker-zhparser)
-	**Docker Pull Command**:  
        ```
        docker push loyayz/postgres-zhparser:15
        ```

# Supported tags and respective `Dockerfile` links

-	[`15`](https://github.com/loyayz/docker-zhparser/blob/master/15/Dockerfile)
-	[`14`](https://github.com/loyayz/docker-zhparser/blob/master/14/Dockerfile)
-	[`13`](https://github.com/loyayz/docker-zhparser/blob/master/13/Dockerfile)
-	[`12`](https://github.com/loyayz/docker-zhparser/blob/master/12/Dockerfile)

# How to use this image

```console
$ docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d loyayz/postgres-zhparser:15
```
- 使用方式与 [postgres](https://hub.docker.com/_/postgres) 的区别只有镜像名
- 容器在启动后将自动执行[脚本](https://github.com/loyayz/docker-zhparser/blob/master/15/load-extensions.sh)
  - 创建模板数据库`template_db`
  - 在`template_db`和`$POSTGRES_DB`库中添加插件`zhparser`、`pg_trgm`
  - 在`template_db`和`$POSTGRES_DB`库中添加全文搜索配置`chn (PARSER = zhparser)`
