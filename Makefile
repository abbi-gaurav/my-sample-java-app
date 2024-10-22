include .env
export COPYFILE_DISABLE := 1

APP_REPO=${DOCKER_ACCOUNT}/${APP}
APP_IMAGE=${APP_REPO}:${VERSION}

cds-build:
	cds build --production

mvn-package:
	mvn clean package -DskipTests=true --batch-mode

pre-build-images: cds-build mvn-package

build-srv: pre-build-images
	DOCKER_DEFAULT_PLATFORM=linux/amd64 pack build ${APP_IMAGE} \
            --path . \
            --builder paketobuildpacks/builder-jammy-base \
            --env BP_JVM_VERSION=21

push-srv:
	docker push ${APP_IMAGE}

deploy-dry-run: cds-build
	helm upgrade --install ${HELM_RELEASE_NAME} ./gen/chart \
			--namespace ${NAMESPACE} \
			--set global.image.tag=${VERSION} \
			--dry-run --debug

deploy: cds-build
	helm upgrade --install ${HELM_RELEASE_NAME} ./gen/chart \
			--namespace ${NAMESPACE} \
			--set global.image.tag=${VERSION}

deploy-template: cds-build
	helm template ${HELM_RELEASE_NAME} ./gen/chart \
			--namespace ${NAMESPACE} \
			--set global.image.tag=${VERSION}