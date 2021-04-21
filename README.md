# streamlit-nginx

**streamlit-nginx** is a **Docker** image with [_Streamlit_](https://streamlit.io/) and [_Nginx_](https://www.nginx.com/) for web-based demo applications in Python 3.6 and above, in a single container.


## Description

The [Docker](https://www.docker.com) image is configured using a _server upstream_ in **Nginx**, which allows the deployment to Kubernetes clusters without the risk to get a socket connection timeout without editing the default values (see discussion [here](https://discuss.streamlit.io/t/streamlit-reruns-all-30-seconds/7201/4))


## Supported tags

Here's the supp:orted tags with the corresponding `Dockerfile`:

- [`python3.6`](python3.6.dockerfile)
- [`python3.7`](python3.7.dockerfile)
- [`python3.8`](python3.8.dockerfile)
- [`python3.9`](python3.9.dockerfile)


## How to use

**streamlit-nginx** should be used as a base image for the containers hosting your own Streamlit application. You should set the base image in your `Dockerfile`, without cloning the repository:

```dockerfile
FROM lucone83/streamlit-nginx:python3.8

<your Dockerfile code>

CMD ["streamlit", "run", "your_application_file_path.py"]


## Advanced use

### Custom nginx settings

You can override the default nginx settings file with your own. All you need to do is to copy it in the right container folder. Your `Dockerfile`will look like:

```dockerfile
FROM lucone83/streamlit-nginx:python3.8

<your Dockerfile code ... >

COPY --chown=streamlitapp your-nginx-file-path /home/streamlitapp/.nginx/nginx.conf

< ... rest of your Dockerfile code>
```

**NOTE:** at the moment I haven't introduced the possibility to change the app directory in an easy way. The Docker image has a default user (`streamlitapp`) with its own home directory (`/home/streamlitapp`), which is also set as `WORKDIR`.
At the moment it is not possible to change the nginx listening port, which is set to `8080`.
