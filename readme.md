## 1 maven profile 打包
### 1.1 配置文件
```xml
<profiles.dir>src/main/profiles</profiles.dir>

<!-- 资源文件 -->
        <resources>
            <resource>
                <directory>src/main/resources</directory>
            </resource>
            <resource>
                <directory>src/main/resources</directory>
                <filtering>true</filtering>
                <targetPath>${project.build.directory}/config</targetPath>
            </resource>
            <resource>
                <directory>${profile.dir}</directory>
                <filtering>true</filtering>
                <targetPath>${project.build.directory}/config</targetPath>
            </resource>
        </resources>
        
        <profiles>
                <profile>
                    <!--不同环境Profile的唯一id-->
                    <id>dev</id>
                    <properties>
                        <profile.dir>${profiles.dir}/dev</profile.dir>
                    </properties>
                </profile>
                <profile>
                    <id>test</id>
                    <properties>
                        <profile.dir>${profiles.dir}/test</profile.dir>
                    </properties>
                </profile>
                <profile>
                    <id>prod</id>
                    <properties>
                        <profile.dir>${profiles.dir}/prod</profile.dir>
                    </properties>
                </profile>
            </profiles>

```
### 1.2 maven打包
clean clean package -DskipTests=true -Ptest


## 2 apollo
用户名;apollo
密码;admin

