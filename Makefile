IMAGE_TAG = nginx-consul

.PHONY: docker
docker:
	docker build -f docker/Dockerfile -t "${IMAGE_TAG}" .

#docker build --platform linux/amd64 -f docker/Dockerfile -t "${IMAGE_TAG}" .
#docker run -it -p 8080:80 --rm "${IMAGE_TAG}"
#.PHONY: docker

podman:
	podman build -f docker/Dockerfile -t "${IMAGE_TAG}" .

deps:
	@cd src/ && dep ensure -update
.PHONY: deps
