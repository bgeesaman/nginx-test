IMAGE=bradgeesaman/nginx-test:latest


build:
	@echo 'building latest'
	docker build -t $(IMAGE) .

push:
	@echo 'publishing latest'
	docker push $(IMAGE)

template:
	@echo 'Helm template'
	helm template .

.PHONY: all build push template
