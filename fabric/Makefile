include project.properties

DETACH :=
CMD := bash inside/dev.sh && bash

MOUNT_HF_VOLUME := "afsc-fabric-crypto-db" # данные в контейнере
MOUNT_HF_VOLUME := $(PWD)/hf-volume # для локального размещения данных

# -----------------
# commands
# -----------------

.PHONY: help
help: Makefile
	@echo "Choose a command in:"
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'

## build-image - собрать образ
.PHONY: build-image
build-image:
	@docker build -f ./Dockerfile -t $(DOCKER_IMG) .

## dev - контейнер для разработки. Запуск приложения внутри контейнера: `dev/run.sh`
.PHONY: dev
dev:
	@docker run --rm -it $(DETACH) \
		--name $(DOCKER_CONTAINER_NAME) \
		-w /app \
		-v $(PWD):/app:ro \
		-v $(MOUNT_HF_VOLUME):$(MOUNT_DIR):rw \
		-e PRODUCTION=off \
		-e BCCSP_DEFAULT=PKCS11 \
		-e LOGS_DIR=/tmp \
		-e HSM_LIB=/usr/lib/softhsm/libsofthsm2.so \
		-e HSM_SLOT=afsc \
		-e HSM_PIN=RecnCbhtyb \
		-e SOFTHSM2_CONF=/app/cfg/softhsm.conf \
		"$(DOCKER_IMG)" bash -c "$(CMD)"
