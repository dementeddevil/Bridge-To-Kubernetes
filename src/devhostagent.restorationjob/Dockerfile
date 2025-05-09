FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine AS base
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

# Build container
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build
ARG TARGETARCH
ARG Configuration=Release
ARG TelemetryType=TELEMETRY_DEVELOPMENT
ARG MindaroBuildNumber=0.0

WORKDIR /src/devhostagent.restorationjob
COPY /src/devhostagent.restorationjob/devhostAgent.restorationjob.csproj .
COPY /src/common/common.csproj /src/common/
RUN dotnet restore -a ${TARGETARCH}

COPY /src/devhostagent.restorationjob/ .
COPY /src/common/ /src/common/
COPY /build/ /build/
ENV TelemetryType=${TelemetryType}
ENV MINDARO_BUILD_NUMBER=${MindaroBuildNumber}
RUN dotnet publish -c ${Configuration} -a ${TARGETARCH} --self-contained false --no-restore -o /output devhostAgent.restorationjob.csproj

# Final container
FROM base AS final
WORKDIR /app
COPY --from=build /output /app
ENTRYPOINT ["/app/restorationjob"]
