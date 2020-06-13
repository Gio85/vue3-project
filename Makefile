BASE_PATH=$(shell git rev-parse --show-toplevel)
PROJECT=missing_pets
MAKEFLAGS += --no-print-directory
BUILD_VCS_REF=$(shell git rev-parse HEAD)
DEFAULT_BUILD_ARGUMENTS=--build-arg IMAGE_NAME=${IMAGE_NAME} \
	--build-arg BUILD_VERSION=${BUILD_VERSION} \
	--build-arg BUILD_DATE=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ') \
	--build-arg BUILD_VCS_REF=${BUILD_VCS_REF}

############################ API ############################
build-api : BUILD_PATH = /tmp/${PROJECT}_api
build-api push-api: IMAGE_NAME = ${PROJECT}/api

build-api:
	@echo "Building - ${IMAGE_NAME}:${BUILD_VERSION} - image. Log available at: ${BUILD_PATH}/docker.log"
	@make check-build-version
	@make init-build-path BUILD_PATH=${BUILD_PATH}
	@cp -R ${BASE_PATH}/src ${BUILD_PATH}
	@cp ${BASE_PATH}/architecture/api/Dockerfile ${BUILD_PATH}
	@cp ${BASE_PATH}/architecture/api/assets/proxy.conf ${BUILD_PATH}
	@cp ${BASE_PATH}/architecture/api/assets/supervisord.conf ${BUILD_PATH}
	@cp ${BASE_PATH}/package.json ${BUILD_PATH}
	@cp ${BASE_PATH}/tsconfig.json ${BUILD_PATH}
	@cd ${BUILD_PATH} && docker build --target production . -t ${IMAGE_NAME}:${BUILD_VERSION} ${DEFAULT_BUILD_ARGUMENTS} > ${BUILD_PATH}/docker.log
	@make image-size IMAGE=${IMAGE_NAME}
	@make cleanup-build-path BUILD_PATH=${BUILD_PATH}
	@echo "Build completed"

push-api:
	@make tag-container IMAGE_NAME=${IMAGE_NAME}
	@make push IMAGE_NAME=${IMAGE_NAME}

############################ SHARED ############################
init-build-path:
	@echo "Init ${BUILD_PATH}"
	@rm -rf ${BUILD_PATH}
	@mkdir -p ${BUILD_PATH}

check-build-version:
	@echo "Build version is - ${BUILD_VERSION} -"
	@test ${BUILD_VERSION}

cleanup-build-path:
	@echo "Clean up build path ${BUILD_PATH}"
	@rm -rf ${BUILD_PATH}

image-size:
	@echo "Size $(shell docker images --format="table {{.Repository }}\t {{.Size }}" | grep -w ${IMAGE} | awk '{print $2}' | sed -n 1p  | xargs)"


.PHONY: build-api
