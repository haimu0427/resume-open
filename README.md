# 中文 LaTeX 简历模板

一份适合技术岗位的单页中文简历模板，使用 XeLaTeX 编译。仓库不包含任何真实个人履历、联系方式或生成的 PDF；所有内容均为可替换的匿名示例。

## 特性

- 中文排版：Noto Serif CJK + IBM Plex + FontAwesome 5
- 结构化模块：个人简介、教育、工作/实习、项目、技能
- Docker 一键编译，不必在本机安装 LaTeX
- 仅编辑一个文件即可生成简历

## 快速开始

克隆后，先编辑 [`resume-zh.tex`](resume-zh.tex) 中的匿名示例文字。通常只需要修改：

| 要修改的内容 | 位置 |
| --- | --- |
| 姓名、联系方式、学校 | 顶部的 `\name` 与 `\profile` |
| 求职方向 | `\tagline` 与「个人简介」 |
| 教育、实习、项目、技能 | 对应的章节 |
| 字体、颜色、布局 | `resume.cls`（通常不需要改） |

使用已发布的构建镜像 [`haimu0427/resume:v1`](https://hub.docker.com/r/haimu0427/resume) 生成 PDF：

```bash
docker pull haimu0427/resume:v1
docker run --rm -v "$PWD":/build haimu0427/resume:v1 \
  sh -c "cd /build && make zh && chown -R $(id -u):$(id -g) ."
```

完成后会生成 `resume-zh.pdf`。macOS 上可以删除命令最后的 `chown -R ...`；Linux 上保留它，以免生成的文件属于 root。

也可以在安装好 XeLaTeX、`latexmk`、Ghostscript 和所需字体的本机直接运行：

```bash
make zh
```

## 自行构建 Docker 镜像

仓库包含 `Dockerfile`，可在本机构建完整编译环境：

```bash
docker build -t resume-template:local .
docker run --rm -v "$PWD":/build resume-template:local \
  sh -c "cd /build && make zh && chown -R $(id -u):$(id -g) ."
```

该镜像仅提供编译依赖，不会把你的简历文件打包进镜像；`-v "$PWD":/build` 会在运行时挂载当前项目目录。

## 常用命令

```bash
make zh       # 生成中文 PDF
make clean    # 删除编译中间文件
make cleanall # 连同 PDF 一起删除
```

## 许可证与致谢

- `resume.cls` 基于 [YACC: Another Awesome CV](https://github.com/darwiin/yaac-another-awesome-cv)，遵循 LPPL 1.3c 或更高版本。
- 本仓库的示例内容、说明和构建文件采用 [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)；使用或改编时请保留署名及变更说明。
- 使用的字体包括 IBM Plex 与 Noto Serif CJK，图标来自 Font Awesome 5；请遵守它们各自的许可证。
