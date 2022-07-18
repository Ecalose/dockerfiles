## 简介

Jellyfin AMD显卡版本，集成了AMD显卡闭源驱动，所以体积会大一些。只要显卡支持，就可以硬解4K x265，并且还可以开启色调映射。

注：未集成Intel相关驱动。主要是自己用，可能有没发现的问题存在。

## 创建：

1. 请确认宿主机`/dev/dri`目录下存在`renderD128`，有关硬解这里不多说，详细介绍请见：https://jellyfin.org/docs/general/administration/hardware-acceleration.html

2. 请在宿主机上运行`cat /etc/group | grep render | awk -F: '{print $3}'`，会输出一个数字，用这个数字代替下面的`render_id`。

compose.yml如下：

```yaml
version: "3.8"
services:
  jellyfin:
    image: nevinee/jellyfin:latest
    container_name: jellyfin
    restart: always
    hostname: jellyfin
    privileged: true
    environment:
      - TZ=Asia/Shanghai        # 时区
    group_add:
      - "render_id"             # 保留引号，引号内应该是上面命令输出的数字，没有其他字符
    volumes:
      - ./config:/config
      - ./cache:/cache
      - <媒体目录>:<媒体目录>
      - <媒体目录>:<媒体目录>
    network_mode: host
    devices:
      - /dev/dri:/dev/dri
```

## 安装AMD闭源驱动

创建好请运行一次以下命令以安装AMD闭源驱动，如果连接性不好可能会报错，可以多次运行直到安装完成。注意最后提示的`amdgpu-dkms`错误可以忽视。

```shell
docker exec -it jellyfin amdgpu-install
```

经我测试安装好闭源驱动后在AMD 5700G上可以完美硬解4K x265视频，并可以开启`控制台 -> 播放 -> 启用色调映射`（注意不是`启用 VPP 色调映射`），将HDR转成PC上的SDR。

## 可以硬解什么

如想知道你的核显到底可以硬解什么编码，可以运行下面命令，运行后可以在`控制台 -> 播放 -> 启用硬件解码`下面勾选支持的编码格式。

```shell
docker exec jellyfin /usr/lib/jellyfin-ffmpeg/vainfo
```

## Dockerfile

见：https://github.com/devome/dockerfiles/tree/master/jellyfin

