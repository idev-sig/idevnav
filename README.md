# 爱开发导航

## 预览网站

**精选：** https://nav.skiy.net  
**全量：** https://navs.skiy.net

## 开发

1. 初始化子模块

```bash
# 首次使用时
git submodule update --init --recursive
```

2. 更新子模块

```bash
# 需要更新 submodule 时
git submodule update --recursive --remote
```

3. 测试

```bash
hugo server
```

## 下载 icon

```bash
# logo: https://api.iowen.cn/favicon/x.com/x.png
bash icons.sh
```

## 发布

```bash
# 打包
bash deploy

# 发布到 CloudFlare Pages
bash deploy.sh yes

# 编写 commit
bash deploy.sh "commit"
```

1. [使用教程](https://git.jetsung.com/idev/navsites/-/wikis/%E4%BD%BF%E7%94%A8%E6%95%99%E7%A8%8B)

## 仓库镜像

- https://git.jetsung.com/idev/navsites
- https://framagit.org/idev/navsites
- https://github.com/idev-sig/navsites
