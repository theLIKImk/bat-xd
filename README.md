# bat-xd
此客户端并非官方客户端，且大概率弃坑（有点想GIVE UP了)。  

这玩意偏向于整活，但是发现已经有个命令行客户端就效果不好了，加上batch一系列限制。  
尤其是UTF-8编码与batch兼容性很差.....很多内容无法正确显示，加上HTML标签的"<>&"在batch都表示含义很难转换。  
效率上json解析即使有第三方也挺大打折扣的。  

总之，这个玩意只能查看串发串|д` )。  

好好享受吧(`ε´ )，如果真的很多肥肥需要的话本PO可以写出一个能用的脚本客户端吧。  
(草，才发现有些变量名写错了（（（( ﾟ∀。)）））)  


串串地址：https://www.nmbxd1.com/t/66799926  
GITHUB地址：https://github.com/theLIKImk/bat-xd  

>[!TIP]  
>导入饼干详情请查看 `.\bin\config.ini`

> BAT-XD V0.1.7  
> NMD-CORE V0.0.8  

# 配置文件
.\bin\config.ini  
```
[BAT_XD]
USE_READ=read_test
READ_LINE=30
READ_PAGE_LINE=03

# 代理范例:
#
# http://user:pwd@127.0.0.1:1234
# http://127.0.0.1:1234
NA_PROXY=

# Cookie导入时请把每一个 % 重复4遍
COOKIE=
```
