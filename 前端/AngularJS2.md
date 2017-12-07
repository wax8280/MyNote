# 创建一个App

```
npm install -g @angular/cli
ng new my-app
cd my-app
ng serve --open
```

# 项目结构

SRC文件

| 文件                                       | 作用                                       |
| ---------------------------------------- | ---------------------------------------- |
| `app/app.component.{ts,html,css,spec.ts}` | 定义`AppComponent`的HTML模板、CSS和单元测试。 随着应用程序的发展，它将成为嵌套组件树的根本部分。 |
| `app/app.module.ts`                      | 定义`AppModule`， 根模块告诉Angular如何组装应用程序。 现在它只声明了AppComponent。 很快会有更多的组件声明。 |
| `assets/*`                               | 图像等构建app的时候完全拷贝用                         |
| `environments/*`                         | This folder contains one file for each of your destination environments, each exporting simple configuration variables to use in your application. The files are replaced on-the-fly when you build your app. You might use a different API endpoint for development than you do for production or maybe different analytics tokens. You might even use some mock services. Either way, the CLI has you covered. |
| `favicon.ico`                            |                                          |
| `index.html`                             | 主页。CLI主动添加js和css                         |
| `main.ts`                                |                                          |

先略

# AngularJS2 架构

## 数据绑定

![img](http://www.runoob.com/wp-content/uploads/2016/09/databinding.png)

```
//插值: 在 HTML 标签中显示组件值。
<h3>
{{title}}
<img src="{{ImageUrl}}">
</h3>

//属性绑定: 把元素的属性设置为组件中属性的值。
<img [src]="userImageUrl">

//事件绑定: 在组件方法名被点击时触发。
<button (click)="onSave()">保存</button>

//双向绑: 使用Angular里的NgModel指令可以更便捷的进行双向绑定。
<input [value]="currentUser.firstName"
       (input)="currentUser.firstName=$event.target.value" >
```
