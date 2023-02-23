# 教程

## 创建项目

```bash
# 创建项目
mkdir navsites
cd $_

# 初始化项目
git init

# 按 WebStack-Hugo 官方教程：https://www.yuque.com/shenweiyan/cookbook/webstack-hugo#Yk0FM
# 将 WebStack-Hugo 源下载到 themes/WebStack-Hugo 文件夹
git submodule add https://github.com/shenweiyan/WebStack-Hugo.git themes/WebStack-Hugo
cp -r themes/WebStack-Hugo/exampleSite/* ./

# 安装 hugo
go install github.com/gohugoio/hugo@latest

# 本地测试
hugo server

# 生成 docs 文件夹，将并静态内容生成至此处
hugo -D
```

## 发布项目

1. 使用 GitHub Pages 布署（此处略过）
2. 使用 [CloudFlare Pages](https://developers.cloudflare.com/pages/get-started/) 布署（推荐）

   - `GitHub` / `GitLab` 仓库发布方式;
   - 静态文件（夹）直接上传方式;
   - `Wrangler` 命令行方式;

   3 种布署方式，我推荐用第 3 种。第 1 种限制了那两个平台，而我使用 `JihuLab`，第 2 种不方便，第 3 种需要使用代理。

### [Wrangler 命令行工具](https://developers.cloudflare.com/workers/wrangler/)

前提是，需要有代理和安装 `Node` 环境。

1. 安装 [Wrangler](https://developers.cloudflare.com/workers/wrangler/install-and-update/)
   ```bash
   npm install -g wrangler
   ```
2. 使用，[可能需要使用代理](https://developers.cloudflare.com/workers/wrangler/configuration/#proxy-support)

   ```bash
   # 登录，可能登录不成功
   wrangler login

   # 若登录不成功，需要使用代理。
   # 每个命令行前，均需要加 HTTP_PROXY=http://localhost:8080
   HTTP_PROXY=http://localhost:1080 wrangler login

   # 创建项目，名为 nav，提示有具体的项目网址
   HTTP_PROXY=http://localhost:1080 wrangler pages project create nav

   # 发布到 docs 文件夹到项目 nav
   HTTP_PROXY=http://localhost:1080 wrangler pages publish docs
   ```

3. 访问项目网址  
   可以在 CloudFlare 后台，Pages 页面查看项目

## 开发

```bash
git clone ...
git module init
```
