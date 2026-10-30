# GitHub 学习路线

这份练习把 Git 的版本控制与 GitHub 的远程协作放在真实的 Verilog 迭代中使用。项目已经连接到：

```text
https://github.com/njueewang/verilog64-multiplier-lab
```

下面的命令都在 **Git Bash** 的仓库根目录执行。

## 0. 确认 Git 环境

从开始菜单打开 Git Bash：

```bash
cd /e/Work/AI_Agents
git --version
gh auth status
git config --local --get user.name
git config --local --get user.email
```

`user.name` 会写进每次 commit；`user.email` 是提交者身份，不会自动公开，但会成为提交元数据。

本项目使用 GitHub 免公开邮箱：

```text
96346145+njueewang@users.noreply.github.com
```

本机网络阻断了普通 Git HTTPS 端点，所以 `origin` 使用 `ssh.github.com` 的 443 端口，并通过仅限本仓库的 Deploy Key 认证。不要把这个仓库配置直接复制给其他项目；每个仓库可以单独决定访问权限。

## 1. 仓库、工作区、暂存区、提交

- 工作区：磁盘上正在编辑的文件。
- 暂存区：下一次提交准备包含的快照。
- 提交（commit）：本地的一条不可变历史记录。
- 仓库：由提交和分支组成的历史。

常用检查命令：

```bash
git status
git diff
git log --oneline --decorate --graph --all
```

`git status` 只展示当前状态，不会上传文件。看完后可以用 `git diff` 检查尚未暂存的具体修改。

## 2. 阅读第一次提交

第一次提交已经完成，不需要重新初始化。先观察仓库状态和历史：

```bash
git status
git log --oneline --decorate --graph --all
git show --stat v1.0-baseline
git remote -v
```

`main` 已跟踪 `origin/main`，标签 `v1.0-baseline` 也已推送到 GitHub。

提交前必须检查 `git status` 和 `git diff --staged`。不要把 Vivado 的构建缓存、波形或包含本机路径的工程生成文件提交进去。

## 3. 新增 V2 的完整 GitHub 流程

```bash
git switch main
git pull --ff-only
git switch -c feature/v2-pipeline
```

修改设计并运行仿真后：

```bash
git status
git diff
git add rtl tb docs scripts README.md
git diff --staged
git commit -m "feat(v2): pipeline the multiplier"
git push -u origin feature/v2-pipeline
```

然后到 GitHub 仓库页面点击 **Compare & pull request**：

1. 标题写清版本和目的。
2. 描述中写设计改动、仿真结果以及资源/时序对比。
3. 自己审阅 Files changed。
4. 合并 Pull Request。
5. 在本地更新并打标签：

```bash
git switch main
git pull --ff-only
git tag -a v2.0-pipeline -m "V2: two-stage pipelined multiplier"
git push origin v2.0-pipeline
```

## 4. 每一版必须回答的问题

- 输入和输出位宽是什么？有符号还是无符号？
- 预测结果如何计算？
- 是组合逻辑还是时序逻辑？延迟和吞吐率是多少？
- 仿真覆盖了哪些边界值和随机值？
- 综合后的 LUT、FF、DSP 数量是多少？
- 时序约束是否满足？最差负裕量（WNS）是多少？
- 这一版相对上一版改进了什么，又付出了什么代价？

## 5. 出问题时的恢复方式

查看文件在上一提交中的内容，不会修改工作区：

```bash
git show HEAD:rtl/multiplier64.v
```

舍弃某一个文件尚未提交的修改前，先查看差异：

```bash
git diff -- rtl/multiplier64.v
git restore rtl/multiplier64.v
```

`git restore` 会覆盖该文件中未提交的修改，执行前一定要确认。
