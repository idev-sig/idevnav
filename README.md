# 爱开发导航

## 示例

**精选：** https://nav.idev.top 
**全量：** https://navs.idev.top

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

## 获取 ICON 图标

1. 从 Google
   ```sh
   https://www.google.com/s2/favicons?sz=48&domain_url=https%3A%2F%2Fgitcode.com
   
   # 或直接
   https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://gitcode.com&size=48
   ```

2. 从自建 PHP 获取方式

    ```sh
    # logo: https://api.iowen.cn/favicon/x.com.png
    # logo: https://api.iowen.cn/favicon/x.com.png#custom.png
    bash icons.sh
    ```

## 发布

```sh
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
- https://gitcode.com/idev/navsites
- https://github.com/idevsig/navsites
