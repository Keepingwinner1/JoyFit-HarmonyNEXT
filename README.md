## 环境
- DevEco Studio 5.0.1 
    - Build Version: 5.0.5.300, built on November 9, 2024
- Harmony OS SDK 5.0.1(API 13)

### 工程目录

   ```
   commons                                    # 公共能力层，包括公共UI组件、数据管理、通信和工具库等
   |---uicomponents                               // 公共组件相关
   |---utils                                      // 基础工具类、基础资源相关 
   features                                  # 基础特性层，包含独立的业务模块，如启动页、登录模块等   
   |---mine                                       // 我的模块
   |   |---bean                                   // 数据模型
   |   |---constants                              // 常量
   |   |---model                                  // 业务模型
   |   |---service                                // 业务服务/接口
   |   |---utils                                  // 此模块工具类 需要再加    
   |---exercise                                   // 运动模块
   libs                                           # 本地三方依赖库
   products                                # 产品定制层，作为不同设备或场景应用入口，例如phone、tv等
   |---phone                                      // 手机
   |   |---app                                    // 全局初始化配置
   |   |---bean                                   // 数据模型
   |   |---components                             // 自定义组件 
   |   |---constants                              // 常量
   |   |---model                                  // 业务模型
   |   |---pages                                  // 页面 
   |   |---service                                // 业务服务/接口
   |   |---test                                   // 测试某个效果的例子
   ```



## 开源协议

本项目基于 [Apache License](https://gitee.com/jiaojiaoone/explore-harmony-next/blob/master/LICENSE.txt) ，请自由地享受和参与开源。

