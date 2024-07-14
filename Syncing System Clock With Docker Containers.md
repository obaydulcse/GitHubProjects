Syncing System Clock With Docker Containers
https://vasanthdeveloper.com/syncing-system-clock-with-docker-containers/

Often times, when we spin up a Docker container the time & time zone within the container may be different than the host machine.

This could cause problems to the services inside the container. Time sensitive tasks like logging and Cron jobs can behave incorrectly and produce inaccurate data.

To fix this issue, you can mount /etc/timezone to sync system time and /etc/localtime to sync the time from your host machine.

With Docker

When starting a standalone Docker container using the docker run command, you can add the following 👇 two volume mounts to the command.
docker run -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro <image> 


With Docker Compose

And when running multiple containers that need to have their time synced with with the host machine, add the following two 👇 
volume mounts to all the services within the docker-compose.yml file.
volumes:
    - "/etc/timezone:/etc/timezone:ro"
    - "/etc/localtime:/etc/localtime:ro"
	
This should fix ✅ the where the Docker container time doesn't match with the host machine.

I haven't faced this issue on containers managed by Kubernetes, but doing some research reveals that adding the TZ environment variable to the Pod definition YAML file should resolve it.