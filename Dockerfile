
# Multi step build

# 1.  Production react build
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
COPY yarn.lock .
RUN yarn install
COPY . .
RUN yarn build
# dont need to execute any commands here with CMD no dev server for prod

# 2. RUN
FROM nginx
# export 80required for AWS elasticbeanstalk -- looks for expose instructoion 
EXPOSE 80 
# copy files from as builder above
# look in app/build -- where yarn build place content
# nginx default to rendering static content is @ file loction /usr/share/nginx/html
COPY --from=builder /app/build /usr/share/nginx/html
# default command of nginx will start so we dont have to override with CMD

# build
# docker build . OR docker build -t weeznog/react-docker . -> because its a normal DockerFile no -f needed
# run
# docker run -p 8080:80 <container-id> --> default port for ngix is 80
