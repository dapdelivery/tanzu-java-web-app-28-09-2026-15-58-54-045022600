ARG BUILDER_IMAGE=dev.registry.tanzu.vmware.com/tanzu-advanced-edition/maven
ARG RUNTIME_IMAGE=dev.registry.tanzu.vmware.com/tanzu-advanced-edition/java17-debian11 


FROM $BUILDER_IMAGE AS build

        ADD . .
        RUN unset MAVEN_CONFIG && mkdir -p /workspace && cp -r .mvn /workspace/ 2>/dev/null || true; SETTINGS_ARG=""; if [ -f /platform/bindings/maven-settings-binding/settings.xml ]; then SETTINGS_ARG="-s /platform/bindings/maven-settings-binding/settings.xml"; elif [ -f .mvn/settings.xml ]; then SETTINGS_ARG="-s .mvn/settings.xml"; fi; ./mvnw clean package -B -DskipTests $SETTINGS_ARG


FROM $RUNTIME_IMAGE AS runtime

        COPY --from=build /target/demo-0.0.1-SNAPSHOT.jar /demo.jar
        CMD [ "/demo.jar" ]
