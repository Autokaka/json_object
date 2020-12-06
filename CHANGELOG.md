## [0.0.1]

## 任务清单

目前还没有非常明确后续对这个插件的拓展方向. 我的初衷是使开发app过程中的model层完全消失, 为此我们目前需要实现:

- [x] 核心功能, json 转 object. 使用value = json.key或者value = json[index]的方式访问类的成员.
- [ ] object重新转string. 不是很难, 几小时就能做好.
- [ ] 实现Map和List的基础方法封装, 使得能更高效地操作JsonObject. 具体实现准备直接参考Map和List有关接口.
- [ ] 默认封装一个统一的JsonObject规范. 这个规范在前期将直接写死, 后期可以由开发者自己设定, 用于每个开发团队不同场景下能够适配属于自己的JsonObject. 
- [ ] 创建一个model和JsonObject的成员关联, 削弱由dynamic造成的类型弱化问题. 做点和JavaScript里不一样的.

