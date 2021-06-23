#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://*:8080

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["DotnetappLinuxContainer.csproj", "."]
RUN dotnet restore "./DotnetappLinuxContainer.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DotnetappLinuxContainer.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotnetappLinuxContainer.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotnetappLinuxContainer.dll"]
