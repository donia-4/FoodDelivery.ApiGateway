# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /source

COPY ApiGateway/*.csproj ApiGateway/
RUN dotnet restore ApiGateway/ApiGateway.csproj

COPY ApiGateway/. ./ApiGateway/

WORKDIR /source/ApiGateway
RUN dotnet publish -c Release -o /app --no-restore

# Final Stage: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app .
EXPOSE 8080
ENTRYPOINT ["dotnet", "ApiGateway.dll"]