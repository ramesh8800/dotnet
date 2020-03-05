FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["src/Gateway/Gateway.WebApi/Gateway.WebApi.csproj","dotnetcore/"]
RUN dotnet restore "dotnetcore/Gateway.WebApi.csproj"
COPY . .
WORKDIR "/src/dotnetcore"
RUN dotnet build "Gateway.WebApi.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Gateway.WebApi.csproj" -c Release -o /app
FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet","Gateway.WebApi.dll"]
