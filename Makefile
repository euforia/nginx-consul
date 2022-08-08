IMAGE_TAG = nginx-consul

.PHONY: docker
docker:
	docker build -f docker/Dockerfile -t "${IMAGE_TAG}" .

.PHONY: podman
podman:
	podman build -f docker/Dockerfile -t "${IMAGE_TAG}" .