# 爱开发导航

## 预览网站

**精选：** https://nav.skiy.net  
**全量：** https://navs.skiy.net

## 开发

1. 更新子模块

```bash
git submodule update --recursive --remote
```

2. 测试

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
# 测试
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
