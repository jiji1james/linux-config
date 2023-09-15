# Helper Git Commands

## Merge branches with unrelated histories

Problem

```shell
dm-jboss (master) @ 192.168.71.71
> git merge origin/12.0
fatal: refusing to merge unrelated histories
```

Solution

```shell
git fetch origin master
git checkout master
git merge --allow-unrelated-histories myfunnybranch
```