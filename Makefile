include .env
export COPYFILE_DISABLE := 1

cds-build:
	cds build --production

mvn-package:
	mvn clean package -DskipTests=true --batch-mode

pre-build-images: cds-build mvn-package

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