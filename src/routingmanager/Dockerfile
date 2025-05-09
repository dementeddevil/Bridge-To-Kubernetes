FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine AS base
ARG TARGETARCH
ARG KUBECTL_VERSION=v1.33.0
ARG INSTALL_LOCATION=/app/kubectl/linux
WORKDIR /app

# Apply patch updates
RUN apk upgrade --no-cache

# Install cultures and font support (same approach as Alpine SDK image)
RUN apk add --no-cache \
	icu-libs \
	icu-data-full \
	fontconfig \
    procps \
    bind-tools

# Disable the invariant mode (set in base image)
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

# Pull version of kubectl
WORKDIR ${INSTALL_LOCATION}
RUN wget https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl
RUN chmod +x kubectl
RUN mv kubectl "${INSTALL_LOCATION}"
WORKDIR /app

# Build container
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build
ARG TARGETARCH
ARG Configuration=Release
ARG TelemetryType=TELEMETRY_DEVELOPMENT
ARG MindaroBuildNumber=0.0
WORKDIR /src/routingmanager
COPY /src/routingmanager/routingmanager.csproj .
COPY /src/common/common.csproj /src/common/
RUN dotnet restore -a ${TARGETARCH}

COPY /src/routingmanager/ /src/routingmanager/
COPY /src/common/ /src/common/
COPY /build/ /build/
ENV TelemetryType=${TelemetryType}
ENV MINDARO_BUILD_NUMBER=${MindaroBuildNumber}
RUN dotnet publish -c ${Configuration} -a ${TARGETARCH} --self-contained false --no-restore -o /src/publish

# Final container
FROM base AS final
WORKDIR /src/routingmanager
COPY --from=build /src/publish /src/routingmanager
ENTRYPOINT ["dotnet", "/src/routingmanager/Microsoft.BridgeToKubernetes.RoutingManager.dll"]
