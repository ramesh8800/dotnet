FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["src/App/Console/SimpleBanking.ConsoleApp.csproj","dotnetcore/"]
RUN dotnet restore "dotnetcore/SimpleBanking.ConsoleApp.csproj"
COPY . .
WORKDIR "/src/dotnetcore"
RUN dotnet build "SimpleBanking.ConsoleApp.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "SimpleBanking.ConsoleApp.csproj" -c Release -o /app
FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet","Transaction.WebApi.dll"]
