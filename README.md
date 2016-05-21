# dashing-team-status
Awesome team status widget for Dashing

This dashing widget allows you to display the mood of your team.

## Run the plugin

### 1. Create an empty dashboard in `sample`

You have to create a dashing project in the sample directory.

```shell
docker run \
  -it \
  --rm \
  -v $(pwd)/sample:/usr/src/app \
  -e "HOME=/usr/src/app" \
  --user 1000:1000 \
  -w /usr/src/app \
  ruby:latest ./create_sample.sh
```

### 2. Start dashing

You can install this widget and run dashing with docker.

```shell
cd sample/sweet_dashboard_project
docker run -d \
  -p 3030:3030 \
  -v $(pwd)/../../dashboards:/dashboards \
  -v $(pwd)/../../public:/public \
  -v $(pwd)/../../widgets:/widgets \
  frvi/dashing
cd ../../
```

### 3. Inject data

To have data, you can execute this script several time in oder to have some votes on the graph.

```shell
./data.sh
```

## Unit tests

```shell
docker run -it \
  -e "HOME=/data" \
  -v $(pwd):/data \
  --user 1000:1000 \
  --rm \
  digitallyseamless/nodejs-bower-grunt
```

Once in the container :

```shell
npm install
npm test
```