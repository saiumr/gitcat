## gitcat  

帮助您管理git仓库的bat脚本，能够检查git仓库的状态，更新git仓库以及提取git log  

## 使用  

将`gitcat.cmd`放置在git仓库上一级目录，gitcat对和它同级目录的所有git仓库生效  
使用`.\gitcat -h`查看帮助信息，使用不同的选项管理你的仓库：  

```bash  
-c/--check    列出所有git仓库和他们所在的分支，提示git仓库的状态  
-l/--log      根据version.txt生成version_new.txt和ChangeListDraft.txt
-u/--update   更新所有git仓库
```  

## version.txt  

`version.txt`的内容很简单，每一行是一个仓库的version信息：  
*仓库名称 主分支 完整的commit hash*  
  
而它存储的应该是所有git仓库上个版本的信息，`.\gitcat -l`会根据`version.txt`提取自上个版本到最新版本所有的log并生成`ChangeListDraft.txt`，并且给你提供最新的版本信息`version_new.txt`  
  
当然，在提取log之前，你应该更新所有的仓库（使用`.\gitcat -u`）  

