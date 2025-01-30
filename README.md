# 爱开发导航

## 示例

- **精选：** https://nav.idev.top    
- **全量：** https://navs.idev.top

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

4. 构建与拉取 ICON
```sh
bash ./.deploy.sh

# 部署
bash ./.deploy.sh -d
```

## 获取 ICON 图标

需要先修改 `logo:` 部分的文件名，以提供下述方式 `favicon:` 保存。

1. 从 Google
   ```sh
   # favicon: <URL>

   https://www.google.com/s2/favicons?sz=48&domain_url=https%3A%2F%2Fgitcode.com

   # 或直接
   https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://gitcode.com&size=48
   https://t3.gstatic.cn/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://gitcode.com&size=48

   # 中国加速
   https://c.kkgo.cc/t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://gitcode.com&size=48
   ```

2. 从自建 PHP 获取方式 [**GetFavicon**](https://github.com/sy-records/GetFavicon)
    ```sh
    # favicon: <URL>
    ```

3. [使用教程](https://git.jetsung.com/idev/navsites/-/wikis/%E4%BD%BF%E7%94%A8%E6%95%99%E7%A8%8B)

## 仓库镜像

- https://git.jetsung.com/idev/navsites
- https://framagit.org/idev/navsites
- https://gitcode.com/idev/navsites
- https://github.com/idevsig/navsites
